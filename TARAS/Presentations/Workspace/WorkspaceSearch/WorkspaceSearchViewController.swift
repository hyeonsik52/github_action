//
//  WorkspaceSearchViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/05/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxKeyboard

// 네비 루트가 아닌 푸시로 써야 할 경우는 BaseNavigationViewController 를 상속 할 것
// BaseNavigationViewController 에 self.backButton 이 정의되어 있음

class WorkspaceSearchViewController: BaseNavigationViewController, ReactorKit.View {

    enum Text {
        static let WSSVC_1 = "워크스페이스 가입"
        static let WSSVC_2 = "워크스페이스 코드 입력"
        static let WSSVC_3 = "워크스페이스 코드를 입력해주세요."
        static let WSSVC_4 = "검색"
    }
    
    lazy var textFieldView = SignTextFieldView(Text.WSSVC_2).then {
        $0.textField.autocapitalizationType = .none
        $0.textField.keyboardType = AccountInputType.name.keyboardType
        $0.textField.delegate = self
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = .medium[16]
        $0.textColor = .black0F0F0F
        $0.numberOfLines = 0
        $0.text = Text.WSSVC_3
    }
    
    let errorMessageLabel = UILabel().then {
        $0.font = .bold[14]
        $0.textColor = .redEB4D39
        $0.numberOfLines = 0
    }
    
    let searchButton = SRPButton(Text.WSSVC_4).then {
        $0.isEnabled = false
    }

    // MARK: - Life Cycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.textFieldView.textField.becomeFirstResponder()
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = Text.WSSVC_1
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.textFieldView)
        self.textFieldView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(38)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
        }
        
        self.view.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.textFieldView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(self.errorMessageLabel)
        self.errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(self.searchButton)
        self.searchButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }

    // MARK: - ReactorKit

    func bind(reactor: WorkspaceSearchViewReactor) {
        
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.updateIsInitialOpen }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.textFieldView.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .map(Reactor.Action.updateCode)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.searchButton.rx.tap
            .map { Reactor.Action.confirmCode }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.code ?? "" }
        .distinctUntilChanged()
        .map { InputPolicy.workspaceCode.matchRange($0) }
        .bind(to: self.searchButton.rx.isEnabled)
        .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .bind(to: self.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.isLoading }
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.workspaceInfo }
            .filterNil()
            .compactMap { _ in reactor.reactorForResult() }
            .subscribe(onNext: { [weak self] reactor in
                let viewController = WorkspaceSearchResultViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        
        let margin = height+12
        self.searchButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-margin)
        }
    }
}

extension WorkspaceSearchViewController: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return textField.shouldChangeCharactersIn(in: range, replacementString: string, policy: .workspaceCode)
    }
}
