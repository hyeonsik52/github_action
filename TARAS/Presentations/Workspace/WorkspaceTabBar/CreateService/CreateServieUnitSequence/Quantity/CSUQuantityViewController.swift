//
//  CSUQuantityViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import RxKeyboard

class CSUQuantityViewController: BaseNavigatableViewController, ReactorKit.View {

    weak var csuDelegate: CSUDelegate?


    // MARK: - UI

    lazy var textField = UITextField().then {
        $0.font = .bold.30
        $0.textColor = .purple4A3C9F
        $0.textAlignment = .center
        $0.keyboardType = .numberPad
        $0.delegate = self
    }

    let minusButton = QuantityButton(type: .minus)

    let plusButton = QuantityButton(type: .plusGray)

    let confirmButton = SRPButton("확인").then {
        $0.isEnabled = false
    }

    let guideLabel = UILabel().then {
        $0.text = "품목의 수량을 입력해주세요."
        $0.textColor = .black
        $0.font = .medium.16
        $0.textAlignment = .center
    }


    // MARK: - Life cycles

    override func setupConstraints() {
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.alignment = .center
            $0.distribution = .equalCentering
        }

        self.view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(ScreenSize.height * 0.13)
            $0.width.equalTo(180)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }

        stackView.addArrangedSubview(self.minusButton)
        stackView.addArrangedSubview(self.textField)
        stackView.addArrangedSubview(self.plusButton)

        self.minusButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }

        self.textField.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(100)
        }

        self.plusButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }

        self.view.addSubview(self.guideLabel)
        self.guideLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(ScreenSize.height * 0.092)
            $0.leading.trailing.equalToSuperview()
        }

        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.textField.becomeFirstResponder()
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = "수량 입력"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func bind() {
        self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)

        RxKeyboard.instance.visibleHeight
            .filter { $0 > 0 }
            .drive(onNext: { [confirmButton] visibleHeight in
                confirmButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-(visibleHeight + 12))
                }
            }).disposed(by: self.disposeBag)
    }


    // MARK: - ReactorKit

    func bind(reactor: CSUQuantityViewReactor) {

        self.textField.rx.text
            .map { $0?.count ?? 0 > 0 && $0 != "0" }
            .bind(to: self.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)

        self.textField.rx.text
            .map(Reactor.Action.updateQuantity)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.textField.rx.text
            .filter { $0 == "" }
            .map { _ in Reactor.Action.updateQuantity("0") }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.minusButton.rx.tap
            .map { _ in Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.plusButton.rx.tap
            .map { _ in Reactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.confirmButton.rx.tap
            .map(reactor.updateCreateServiceUnitInput)
            .subscribe(onNext: { [weak self] serviceUnit in
                guard let self = self else { return }
                
                if let csuDelegate = self.csuDelegate {
                    // let freights = serviceUnit.freights.compactMap { $0 }
                    csuDelegate.didUpdate(serviceUnit)
                    self.navigationController?.dismiss(animated: true, completion: nil)
                } else {
                    let viewController = CSUDetailViewController()
                    viewController.reactor = reactor.reactorForDetail()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.quantity }
            .distinctUntilChanged()
            .map { String($0) }
            .bind(to: self.textField.rx.text)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.quantity }
            .distinctUntilChanged()
            .map { $0 != 0 }
            .bind(to: self.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
}

extension CSUQuantityViewController: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        if textField.text == "0" {
            if string != "" {
                textField.text = string
                self.reactor?.action.onNext(.updateQuantity(string))
            }
            return false
        }

        if string != "" {
            return !(textField.text?.count ?? 0 == 4)
        }
        return true
    }
}
