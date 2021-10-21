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
class CSUTargetViewController: BaseNavigatableViewController, ReactorKit.View {

    weak var csuDelegate: CSUDelegate?

    
    // MARK: - UI
    
    lazy var closeButton = UIBarButtonItem(
        image: UIImage(named: "navi-close"),
        style: .done,
        target: self,
        action: nil
    )

    private var stopButton = SRPSegmentButton(title: "작업 위치")

    private var innerPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

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

        stackView.addArrangedSubview(self.stopButton)

        self.view.addSubview(self.innerPageViewController.view)
        self.innerPageViewController.view.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }


    // MARK: - ReactorKit

    func bind(reactor: CSUTargetViewReactor) {
        
        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)

        self.stopButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.setLocationPage(reactor)
            }).disposed(by: self.disposeBag)

        self.rx.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.setLocationPage(reactor)
            }).disposed(by: self.disposeBag)
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
        let viewController = CSURecipientViewController()
        viewController.reactor = self.reactor?.reactorForRecipients(serviceUnitModel)
        viewController.csuDelegate = self.csuDelegate
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
