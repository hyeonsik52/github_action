//
//  ServiceShortcutRegistrationViewController.swift
//  TARAS
//
//  Created by nexmond on 2022/02/15.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import UITextView_Placeholder

class ServiceShortcutRegistrationViewController: BaseNavigationViewController, View {
    
    enum Text {
        static let title = "간편 생성 등록"
        static let nameTitle = "간편 생성 이름"
        static let namePlaceholder = "이름"
        static let descriptionPlaceholder = "설명을 입력해주세요"
        static let descriptionTitle = "간편 생성 설명"
        static let confirmButtonTitle = "등록하기"
        static let alertMessage = "간편 생성 등록을 취소하시겠습니까?"
        static let alertAllow = "예"
        static let alertCancel = "아니오"
    }
    
    private let scrollView = UIScrollView().then {
        $0.contentInset.top = 12
        $0.contentInset.bottom = 88
        $0.alwaysBounceVertical = true
        $0.keyboardDismissMode = .onDrag
    }
    
    private lazy var textFieldView = SignTextFieldView(Text.namePlaceholder).then {
        $0.textField.autocapitalizationType = .none
        $0.textField.keyboardType = AccountInputType.name.keyboardType
        $0.textField.delegate = self
    }
    
    private lazy var detailTextView = UITextView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .lightGrayF6F6F6
        $0.textContainerInset = .init(top: 22, left: 18, bottom: 22, right: 18)
        $0.font = .bold[18]
        $0.textColor = .black0F0F0F
        $0.placeholderColor = .gray9A9A9A
        $0.placeholder = Text.descriptionPlaceholder
        $0.delegate = self
    }
    
    private let confirmButton = SRPButton(Text.confirmButtonTitle)
    
    override var navigationPopWithBottomBarHidden: Bool {
        return true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let contentView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 8
        }
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        func addSectionView(
            title: String,
            container: UIView? = nil,
            addContentView: (_ container: UIView, _ titleView: UIView, _ sectionView: UIView) -> Void
        ) {
            let sectionContainer = container ?? UIView()
            contentView.addArrangedSubview(sectionContainer)
            
            let sectionView = UIView()
            sectionContainer.addSubview(sectionView)
            sectionView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(40)
            }
            
            let label = UILabel().then {
                $0.font = .regular[16]
                $0.textColor = .gray666666
                $0.text = title
                $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
            sectionView.addSubview(label)
            label.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(16)
            }
            
            addContentView(sectionContainer, label, sectionView)
        }
        
        addSectionView(title: Text.nameTitle) { container, titleView, sectionView in

            container.addSubview(self.textFieldView)
            self.textFieldView.snp.makeConstraints {
                $0.top.equalTo(sectionView.snp.bottom)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(60)
            }
        }
        
        addSectionView(title: Text.descriptionTitle) { container, titleView, sectionView in

            container.addSubview(self.detailTextView)
            self.detailTextView.snp.makeConstraints {
                $0.top.equalTo(sectionView.snp.bottom)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(self.detailTextView.snp.width).multipliedBy(0.6)
            }
        }
        
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(60)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = Text.title
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textFieldView.textField.becomeFirstResponder()
    }
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        let padding = (height == 0 ? -24: -(height+8))
        self.confirmButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(padding)
        }
        self.scrollView.contentInset.bottom = 60 - padding
    }
    
    override func bind() {
        super.bind()
        
        self.backButtonDisposeBag = DisposeBag()
        self.backButton.rx.tap
            .flatMapLatest { [weak self] _ -> Observable<Int> in
                guard let self = self else { return .just(0) }
                guard self.textFieldView.textField.text?.count != 0 ||
                      self.detailTextView.text.count != 0
                else { return .just(1) }
                return UIAlertController.present(
                    in: self,
                    title: Text.alertMessage,
                    style: .alert,
                    actions: [
                        .init(title: Text.alertCancel, style: .default),
                        .init(title: Text.alertAllow, style: .destructive)
                    ])
            }.filter { $0 == 1 }
            .subscribe(onNext: { [weak self] _ in
                self?.navigationPop(
                    to: ServiceDetailViewController.self,
                    animated: true,
                    bottomBarHidden: true
                )
            }).disposed(by: self.backButtonDisposeBag)
    }
    
    func bind(reactor: ServiceShortcutRegistrationViewReactor) {
        
        //Action
        self.confirmButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(
                    self.textFieldView.textField.rx.text.orEmpty,
                    self.detailTextView.rx.text
                )
            ).map(Reactor.Action.register)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        Observable.merge(
            self.detailTextView.rx.didBeginEditing.asObservable(),
            self.detailTextView.rx.text.map {_ in () }
        ).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let textView = self.detailTextView
            if let selectedRange = textView.selectedTextRange {
                let cursorRect = textView.caretRect(for: selectedRange.start)
                let rect = textView.convert(cursorRect, to: self.scrollView)
                self.scrollView.scrollRectToVisible(rect, animated: true)
            }
        }).disposed(by: self.disposeBag)
        
        self.textFieldView.textField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: self.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        self.textFieldView.textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.detailTextView.becomeFirstResponder()
            }).disposed(by: self.disposeBag)
        
        //State
        reactor.state.compactMap(\.isProcessing)
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.isConfirmed)
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                self?.navigationPop(
                    to: ServiceDetailViewController.self,
                    animated: true,
                    bottomBarHidden: true
                )
            }).disposed(by: self.disposeBag)
        
        reactor.state.map(\.errorMessage)
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: Toaster.rx.showToast(color: .redEB4D39))
            .disposed(by: self.disposeBag)
        
        //네트워크 통신 중엔 비활성화
        reactor.state
            .map { !($0.isProcessing == true) }
            .distinctUntilChanged()
            .bind(to: self.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
}

extension ServiceShortcutRegistrationViewController: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return textField.shouldChangeCharactersIn(in: range, replacementString: string, policy: .name)
    }
}

extension ServiceShortcutRegistrationViewController: UITextViewDelegate {
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        return textView.shouldChangeText(in: range, replacementText: text, policy: .serviceShortcutDescription)
    }
}
