//
//  CSUFreightsViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxKeyboard

class CSUFreightsViewController: BaseNavigatableViewController, ReactorKit.View {
    
    weak var csuDelegate: CSUDelegate?
    
    
    // MARK: - UI
    
    lazy var closeButton = UIBarButtonItem(
        image: UIImage(named: "navi-close"),
        style: .done,
        target: self,
        action: nil
    )
    
    lazy var textView = SRPClearTextView().then {
        $0.placeholder = "ex) 간식류"
        $0.placeholderColor = .grayCDCDCD
        $0.placeholderTextView.textAlignment = .center
        $0.srpClearTextViewDelegate = self
    }
    
    let freightsTypeSelectView = FreightTypeSelectView()

    let confirmButton = SRPButton("확인").then {
        $0.isEnabled = false
    }

    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .fillEqually
    }


    // MARK: - Life cycles

    override func setupConstraints() {
        self.view.addSubview(self.textView)
        self.textView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(ScreenSize.height * 0.084)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(ScreenSize.height * 0.22)
        }
        
        self.view.addSubview(self.stackView)
        self.stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(132)
            $0.bottom.equalToSuperview()
        }

        self.stackView.addArrangedSubview(self.freightsTypeSelectView)
        self.stackView.addArrangedSubview(self.confirmButton)

        self.freightsTypeSelectView.snp.makeConstraints {
            $0.width.equalTo(self.stackView)
            $0.height.equalTo(60)
        }

        self.confirmButton.snp.makeConstraints {
            $0.width.equalTo(self.stackView)
            $0.height.equalTo(60)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.textView.becomeFirstResponder()
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = "품목 입력"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        if self.csuDelegate != nil {
            self.navigationItem.setLeftBarButton(self.closeButton, animated: true)
        }
    }

    override func bind() {
        self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.closeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .filter { $0 > 0 }
            .drive(onNext: { [stackView] visibleHeight in
                stackView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-(visibleHeight + 12))
                }
            }).disposed(by: self.disposeBag)
    }


    // MARK: - ReactorKit

    func bind(reactor: CSUFreightsViewReactor) {
        self.rx.viewDidLoad
            .map { _ in Reactor.Action.setFreightType }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.textView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { $0.count > 0 }
            .bind(to: self.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        self.textView.rx.text.orEmpty
            .debug()
            .distinctUntilChanged()
            .map(Reactor.Action.setName)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.freightsTypeSelectView.didTap
            .map { _ in Reactor.Action.toggleFreightMode }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.confirmButton.rx.tap
            .map(reactor.reactorForQuantitiy)
            .subscribe(onNext: { [weak self] reactor in
                guard let self = self else { return }
                let viewController = CSUQuantityViewController()
                viewController.csuDelegate = self.csuDelegate
                viewController.reactor = reactor
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
            
        reactor.state.map { $0.freightType }
            .distinctUntilChanged()
            .bind { [weak self] in self?.freightsTypeSelectView.toggleFreightMode($0) }
            .disposed(by: self.disposeBag)
    }
}


extension CSUFreightsViewController: SRPClearTextViewDelegate {
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        
        if textView.text.count >= 40 {
            return false
        }
        return !(text == "\n")
    }
}
