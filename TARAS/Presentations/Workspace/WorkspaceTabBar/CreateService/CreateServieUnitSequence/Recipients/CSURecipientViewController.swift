//
//  CSURecipientViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class CSURecipientViewController: BaseNavigatableViewController, ReactorKit.View {

    weak var csuDelegate: CSUDelegate?
    
    
    // MARK: - UI

    lazy var closeButton = UIBarButtonItem(
        image: UIImage(named: "navi-close"),
        style: .done,
        target: self,
        action: nil
    )

    private var userButton = SRPSegmentButton(title: "회원")

    private var groupButton = SRPSegmentButton(title: "그룹")

    private var innerPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    private var recipientUserViewController: RecipientUserViewController!

    private var recipientGroupViewController: RecipientGroupViewController!


    // MARK: - Life cycles

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = "수신자 선택"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func setupConstraints() {
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }

        self.view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }

        stackView.addArrangedSubview(self.userButton)
        stackView.addArrangedSubview(self.groupButton)

        self.view.addSubview(self.innerPageViewController.view)
        self.innerPageViewController.view.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func bind() {
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)

        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }


    // MARK: - ReactorKit

    func bind(reactor: CSURecipientViewReactor) {
        self.setSegmentButtons(on: .user)
        
        self.userButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.setSegmentButtons(on: .user)
                self?.setUsersPage(reactor)
            }).disposed(by: self.disposeBag)

        self.groupButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.setSegmentButtons(on: .group)
                self?.setGroupsPage(reactor)
            }).disposed(by: self.disposeBag)

        self.rx.viewDidLoad.map { _ in Reactor.Action.setInitialPage }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        /// recipientType 의 값에 따라 pageViewController 초기 설정을 분기합니다.
        /// - nil 일 경우: '회원' 화면 세팅
        /// - .user 일 경우: '회원' 화면 및 버튼 세팅
        /// - .group 일 경우: '그룹' 화면 및 버튼 세팅
        reactor.state.map { $0.recipientType }
            .subscribe(onNext: { [weak self] recipientType in
                guard let self = self else { return }
                self.setSegmentButtons(on: recipientType)

                switch recipientType {
                case nil: self.setUsersPage(reactor)
                case .user: self.setUsersPage(reactor)
                case .group: self.setGroupsPage(reactor)
                default: break
                }
            }).disposed(by: self.disposeBag)
    }

    private func setSegmentButtons(on: ServiceUnitRecipientType?) {
        if let type = on {
            let isUserButtonOn = (type == .user)
            self.userButton.isSelected = isUserButtonOn ? true : false
            self.groupButton.isSelected = isUserButtonOn ? false : true
        }
    }

    private func setUsersPage(_ reactor: CSURecipientViewReactor) {
        var viewController = self.recipientUserViewController

        if viewController == nil {
            viewController = RecipientUserViewController().then {
                $0.reactor = reactor.reactorForRecipientUsers()
                $0.recipientDelegate = self
            }
            self.recipientUserViewController = viewController
        }

        self.innerPageViewController.setViewControllers(
            [viewController!],
            direction: .forward,
            animated: false
        )
    }

    private func setGroupsPage(_ reactor: CSURecipientViewReactor) {
        var viewController = self.recipientGroupViewController

        if viewController == nil {
            viewController = RecipientGroupViewController().then {
                $0.reactor = reactor.reactorForRecipientGroup()
                $0.recipientDelegate = self
            }
            self.recipientGroupViewController = viewController
        }

        self.innerPageViewController.setViewControllers(
            [viewController!],
            direction: .forward,
            animated: false
        )
    }
}


extension CSURecipientViewController: CSURecipientDelegate {

    func didRecipientsSelected(_ serviceUnit: CreateServiceUnitModel) {
        if let csuDelegate = self.csuDelegate {
            csuDelegate.didUpdate(serviceUnit)
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            let viewController = CSUFreightsViewController()
            viewController.reactor = self.reactor?.reactorForFreight(serviceUnit)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
