//
//  TRSSearchView.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/18.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TRSSearchView: UIView {
    
    enum Text {
        static let placeholderDefault = "검색"
        static let cancel = "취소"
    }
    
    enum Image {
        static let search = UIImage(named: "search")
        static let clear = UIImage(named: "text-delete")
    }
    
    private let contentView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 12
    }
    
    private let inputContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 8
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGrayF5F5F5
        $0.layer.cornerRadius = 8
    }
    
    private lazy var textField = UITextField().then {
        $0.font = .light[16]
        $0.textColor = .black1C1B1F
        $0.clearButtonMode = .never
        $0.enablesReturnKeyAutomatically = true
        $0.returnKeyType = .search
        $0.delegate = self
    }
    
    private let clearButton = UIButton().then {
        $0.setImage(Image.clear, for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.isHidden = true
    }
    
    private let cancelButton = UIButton().then {
        $0.titleLabel?.font = .regular[14]
        $0.setTitle(Text.cancel, for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.isHidden = true
    }
    
    private lazy var recentKeywordsView = TRSRecentSearchTermsView().then {
        $0.tagListView.tagListDelegate = self
        $0.isHidden = true
    }
    
    let searchTerm = BehaviorRelay<String?>(value: nil)
    var usingRecentSearchTerms: Bool = true
    
    private let disposeBag = DisposeBag()
    
    init(
        placeholder: String = Text.placeholderDefault,
        usingRecentSearchTerms: Bool = true
    ) {
        super.init(frame: .zero)
        
        self.textField.attributedPlaceholder = .init(
            string: placeholder,
            attributes: [
                .font: UIFont.light[16],
                .foregroundColor: UIColor.gray787579
            ]
        )
        self.usingRecentSearchTerms = usingRecentSearchTerms
        
        self.setupConstraints()
        self.bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //터치 이벤트 제한 용도임. 삭제 금지
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        let searchArea = UIView()
        self.contentView.addArrangedSubview(searchArea)
        searchArea.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        let searchContainer = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 4
        }
        searchArea.addSubview(searchContainer)
        searchContainer.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(36)
        }
        
        searchContainer.addArrangedSubview(self.inputContainer)
        
        let leftPadding = UIView()
        self.inputContainer.addArrangedSubview(leftPadding)
        leftPadding.snp.makeConstraints {
            $0.width.equalTo(4)
        }
        
        let iconImageView = UIImageView(image: Image.search).then {
            $0.contentMode = .center
        }
        self.inputContainer.addArrangedSubview(iconImageView)
        iconImageView.snp.makeConstraints {
            $0.width.equalTo(24)
        }
        
        self.inputContainer.addArrangedSubview(self.textField)
        
        self.inputContainer.addArrangedSubview(self.clearButton)
        self.clearButton.snp.makeConstraints {
            $0.width.equalTo(24)
        }
        
        let rightPadding = UIView()
        self.inputContainer.addArrangedSubview(rightPadding)
        rightPadding.snp.makeConstraints {
            $0.width.equalTo(4)
        }
        
        searchContainer.addArrangedSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints {
            $0.width.equalTo(48)
        }
        
        if self.usingRecentSearchTerms {
            self.contentView.addArrangedSubview(self.recentKeywordsView)
            self.recentKeywordsView.snp.makeConstraints {
                $0.height.equalTo(76)
            }
        }
    }
    
    private func bind() {
        
        self.clearButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.textField.text = nil
                if self?.textField.isFirstResponder == false {
                    self?.textField.becomeFirstResponder()
                }
                self?.updateUI()
            }).disposed(by: self.disposeBag)
        
        self.cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.endEditing()
            }).disposed(by: self.disposeBag)
        
        self.textField.rx.text.skip(1)
            .subscribe(onNext: { [weak self] text in
                self?.updateUI()
            }).disposed(by: self.disposeBag)
        
        self.textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                guard let term = self?.textField.text else { return }
                SimpleDefualts.shared.saveRecentSearchTerms(term)
                self?.updateUI(with: true)
            }).disposed(by: self.disposeBag)
        
        if self.usingRecentSearchTerms {
            self.recentKeywordsView.deleteAllButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    SimpleDefualts.shared.removeRecentSearchTermsAll()
                    self?.updateUI(with: true)
                }).disposed(by: self.disposeBag)
        }
    }
    
    func endEditing() {
        self.textField.text = nil
        if self.textField.isFirstResponder == true {
            self.endEditing(true)
        }
        self.updateUI(with: true)
    }
    
    func updateUI(with recentSearchTerms: Bool = false) {
        
        if recentSearchTerms, self.usingRecentSearchTerms == true {
            self.recentKeywordsView.update()
        }
        
        self.searchTerm.accept(self.textField.text)
        let isKeyboardActive = self.textField.isFirstResponder
        let isEmpty = self.textField.text?.isEmpty ?? true
        
        let isClearHidden = isEmpty
        let isCnacelHidden = (!isKeyboardActive && isEmpty)
        let isRecentHidden = SimpleDefualts.shared.isRecentSearchTermsEmpty || !(isKeyboardActive && isEmpty)
        
        self.clearButton.isHidden = isClearHidden
        self.inputContainer.layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            animations: {
                self.cancelButton.isHidden = isCnacelHidden
                if self.usingRecentSearchTerms {
                    self.recentKeywordsView.isHidden = isRecentHidden
                }
                self.contentView.layoutIfNeeded()
            },
            completion: { success in
                self.cancelButton.isHidden = isCnacelHidden
                if self.usingRecentSearchTerms {
                    self.recentKeywordsView.isHidden = isRecentHidden
                }
            }
        )
    }
}

extension TRSSearchView: TRSTagListViewDelegate {
    
    func tagListView(_ tagListView: TRSTagListView, didSelect model: TRSTagListViewModel) {
        self.textField.text = model.string
        SimpleDefualts.shared.saveRecentSearchTerms(model.string)
        self.updateUI(with: true)
    }
    
    func tagListView(_ tagListView: TRSTagListView, didRemove model: TRSTagListViewModel) {
        SimpleDefualts.shared.removeRecentSearchTerms(model.string)
        self.updateUI(with: true)
    }
}

extension TRSSearchView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.shouldChangeCharactersIn(in: range, replacementString: string, policy: .search)
    }
}
