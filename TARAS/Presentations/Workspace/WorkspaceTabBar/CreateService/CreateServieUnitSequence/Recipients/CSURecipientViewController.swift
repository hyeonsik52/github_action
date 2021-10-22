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

    private var innerPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    private var recipientUserViewController: RecipientUserViewController!


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

        self.view.addSubview(self.innerPageViewController.view)
        self.innerPageViewController.view.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }


    // MARK: - ReactorKit

    func bind(reactor: CSURecipientViewReactor) {
        
        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        self.rx.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.setUsersPage(reactor)
            }).disposed(by: self.disposeBag)
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
}


extension CSURecipientViewController: CSURecipientDelegate {

    func didRecipientsSelected(_ serviceUnit: CreateServiceUnitModel) {
        self.csuDelegate?.didUpdate(serviceUnit)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
