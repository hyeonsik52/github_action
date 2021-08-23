//
//  CSUTargetViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

/// 단위서비스 생성 과정 중 '대상을 선택'하는 viewController 입니다.
/// CSU 는 Create Service Unit(단위서비스 생성) 의 약자입니다.
class CSUTargetViewController: BaseNavigationViewController, ReactorKit.View {

    weak var csuDelegate: CSUDelegate?

    
    // MARK: - UI
    
    lazy var closeButton = UIBarButtonItem(
        image: UIImage(named: "navi-close"),
        style: .done,
        target: self,
        action: nil
    )

    private var memberButton = SRPSegmentButton(title: "회원 및 그룹")

    private var stopButton = SRPSegmentButton(title: "작업 위치")

    private var innerPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    private var targetMemberViewController: TargetMemberViewController!

    private var targetStopViewController: TargetStopViewController!


    // MARK: - Life cycles

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = "대상 선택"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false

        if csuDelegate != nil {
            self.navigationItem.setLeftBarButton(self.closeButton, animated: true)
        }
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

        stackView.addArrangedSubview(self.memberButton)
        stackView.addArrangedSubview(self.stopButton)

        self.view.addSubview(self.innerPageViewController.view)
        self.innerPageViewController.view.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func bind() {
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)

        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }


    // MARK: - ReactorKit

    func bind(reactor: CSUTargetViewReactor) {
        self.setSegmentButtons(on: .recipient)

        self.memberButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.setSegmentButtons(on: .recipient)
                self?.setUsersPage(reactor)
            }).disposed(by: self.disposeBag)

        self.stopButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.setSegmentButtons(on: .stop)
                self?.setLocationPage(reactor)
            }).disposed(by: self.disposeBag)

        self.rx.viewDidLoad.map { _ in Reactor.Action.setInitialPage }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        /// targetType 의 값에 따라 pageViewController 초기 설정을 분기합니다.
        /// - nil 일 경우: '회원 및 그룹' 화면 세팅
        /// - .recipient 일 경우: '회원 및 그룹' 화면 및 버튼 세팅
        /// - .stop 일 경우: '정차지' 화면 및 버튼 세팅
        reactor.state.map { $0.targetType }
            .subscribe(onNext: { [weak self] targetType in
                guard let self = self else { return }
                self.setSegmentButtons(on: targetType)

                switch targetType {
                case nil: self.setUsersPage(reactor)
                case .recipient: self.setUsersPage(reactor)
                case .stop: self.setLocationPage(reactor)
                default: break
                }
            }).disposed(by: self.disposeBag)
    }

    private func setSegmentButtons(on: ServiceUnitTargetType?) {
        if let targetType = on {
            let isRecipientsButtonOn = (targetType == .recipient)
            self.memberButton.isSelected = isRecipientsButtonOn ? true : false
            self.stopButton.isSelected = isRecipientsButtonOn ? false : true
        }
    }

    private func setUsersPage(_ reactor: CSUTargetViewReactor) {
        var viewController = self.targetMemberViewController

        if viewController == nil {
            viewController = TargetMemberViewController().then {
                $0.reactor = reactor.reactorForTargetMemeber()
                $0.targetDelegate = self
            }
            self.targetMemberViewController = viewController
        }

        self.innerPageViewController.setViewControllers(
            [viewController!],
            direction: .forward,
            animated: false
        )
    }

    private func setLocationPage(_ reactor: CSUTargetViewReactor) {
        var viewController = self.targetStopViewController

        if viewController == nil {
            viewController = TargetStopViewController().then {
                $0.reactor = reactor.reactorForTargetStop()
                $0.targetDelegate = self
            }
            self.targetStopViewController = viewController
        }

        self.innerPageViewController.setViewControllers(
            [viewController!],
            direction: .forward,
            animated: false
        )
    }
}


extension CSUTargetViewController: CSUTargetDelegate {

    func didTargetSelected(_ serviceUnitModel: CreateServiceUnitModel) {
        if serviceUnitModel.serviceUnit.info.targetType == .recipient
        {
            if self.csuDelegate == nil {
                let viewController = CSUFreightsViewController()
                viewController.reactor = self.reactor?.reactorForFreight(serviceUnitModel)
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                self.csuDelegate?.didUpdate(serviceUnitModel)
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        else if serviceUnitModel.serviceUnit.info.targetType == .stop
        {
            let viewController = CSURecipientViewController()
            viewController.reactor = self.reactor?.reactorForRecipients(serviceUnitModel)
            viewController.csuDelegate = self.csuDelegate
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
