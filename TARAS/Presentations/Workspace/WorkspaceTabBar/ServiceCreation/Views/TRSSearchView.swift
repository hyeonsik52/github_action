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
    
    private let textField = UITextField().then {
        $0.clearButtonMode = .never
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
    
    //temp
    private let recentKeywordsView = UIView().then {
        $0.isHidden = true
    }
    
    let searchTerm = PublishRelay<String?>()
    
    private let disposeBag = DisposeBag()
    
    init(placeholder: String = Text.placeholderDefault) {
        super.init(frame: .zero)
        
        self.textField.placeholder = placeholder
        
        self.setupConstraints()
        self.bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
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
            $0.centerY.leading.trailing.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        let inputContainer = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 8
            $0.clipsToBounds = true
            $0.backgroundColor = .lightGrayF5F5F5
            $0.layer.cornerRadius = 8
        }
        searchContainer.addArrangedSubview(inputContainer)
        
        let leftPadding = UIView()
        inputContainer.addArrangedSubview(leftPadding)
        leftPadding.snp.makeConstraints {
            $0.width.equalTo(4)
        }
        
        let iconImageView = UIImageView(image: Image.search).then {
            $0.contentMode = .center
        }
        inputContainer.addArrangedSubview(iconImageView)
        iconImageView.snp.makeConstraints {
            $0.width.equalTo(24)
        }
        
        inputContainer.addArrangedSubview(self.textField)
        
        inputContainer.addArrangedSubview(self.clearButton)
        self.clearButton.snp.makeConstraints {
            $0.width.equalTo(24)
        }
        
        let rightPadding = UIView()
        inputContainer.addArrangedSubview(rightPadding)
        rightPadding.snp.makeConstraints {
            $0.width.equalTo(4)
        }
        
        searchContainer.addArrangedSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints {
            $0.width.equalTo(48)
        }
        
        contentView.addArrangedSubview(self.recentKeywordsView)
        self.recentKeywordsView.snp.makeConstraints {
            $0.height.equalTo(76)
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
                self?.textField.text = nil
                if self?.textField.isFirstResponder == true {
                    self?.endEditing(true)
                }
                self?.updateUI()
            }).disposed(by: self.disposeBag)
        
        self.textField.rx.text.skip(1)
            .subscribe(onNext: { [weak self] text in
                self?.updateUI()
            }).disposed(by: self.disposeBag)
    }
    
    private func updateUI() {
        self.searchTerm.accept(self.textField.text)
        let isKeyboardActive = self.textField.isFirstResponder
        let isEmpty = self.textField.text?.isEmpty ?? true
        
        let isClearHidden = isEmpty
        let isCnacelHidden = (!isKeyboardActive && isEmpty)
        let isRecentHidden = !(isKeyboardActive && isEmpty)
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            animations: {
                self.clearButton.isHidden = isClearHidden
                self.cancelButton.isHidden = isCnacelHidden
                self.recentKeywordsView.isHidden = isRecentHidden
                self.contentView.layoutIfNeeded()
            },
            completion: { success in
                self.clearButton.isHidden = isClearHidden
                self.cancelButton.isHidden = isCnacelHidden
                self.recentKeywordsView.isHidden = isRecentHidden
            }
        )
    }
}
