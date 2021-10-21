//
//  WorkspaceSearchViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/05/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxKeyboard

// 네비 루트가 아닌 푸시로 써야 할 경우는 BaseNavigatableViewController 를 상속 할 것
// BaseNavigatableViewController 에 self.backButton 이 정의되어 있음

class WorkspaceSearchViewController: BaseNavigatableViewController, ReactorKit.View {

    enum Text {
        static let WSSVC_1 = "워크스페이스"
        static let WSSVC_2 = "워크스페이스 코드를 입력해주세요."
        static let WSSVC_3 = "확인"
    }

    lazy var workspaceSearchView = SRPInputView(description: Text.WSSVC_2).then {
        $0.textView.keyboardType = .asciiCapable
        $0.textView.autocapitalizationType = .none
        $0.textView.srpClearTextViewDelegate = self
    }
    
    // MARK: - Init

    init(reactor: WorkspaceSearchViewReactor) {
        super.init()
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life Cycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.workspaceSearchView.textView.becomeFirstResponder()
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = Text.WSSVC_1
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func setupConstraints() {
        super.setupConstraints()

        self.view.addSubview(self.workspaceSearchView)
        self.workspaceSearchView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(38)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - ReactorKit

    func bind(reactor: WorkspaceSearchViewReactor) {
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.updateIsInitialOpen }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.workspaceSearchView.textView.rx.text.orEmpty
            .distinctUntilChanged()
            .map(Reactor.Action.updateCode)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.workspaceSearchView.confirmButton.rx.tap
            .map { Reactor.Action.confirmCode }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.errorMessage }
            .bind(to: self.workspaceSearchView.errorMessageLabel.rx.text)
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
            }, onError: { [weak self] error in
                self?.workspaceSearchView.errorMessageLabel.text = "error"
            }).disposed(by: self.disposeBag)
        
        let codeText = self.workspaceSearchView.textView.rx.text.orEmpty

        // 코드 입력 소문자 강제
        codeText
            .map { $0.lowercased() }
            .bind(to: workspaceSearchView.textView.rx.text)
            .disposed(by: self.disposeBag)

        // 리턴키 교체
        codeText
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.workspaceSearchView.textView.returnKeyType = text.count < 5 ? .default : .done
                self.workspaceSearchView.textView.reloadInputViews()
            }).disposed(by: self.disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .filter { $0 > 0 }
            .drive(onNext: { [workspaceSearchView] visibleHeight in
                workspaceSearchView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-(visibleHeight + 12))
                }
            }).disposed(by: self.disposeBag)
    }
}


extension WorkspaceSearchViewController: SRPClearTextViewDelegate {
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        if text == "\n" {
            if textView.returnKeyType == .done {
                self.workspaceSearchView.confirmButton.sendActions(for: .touchUpInside)
            }
            return false
        }
        return true
    }
}
