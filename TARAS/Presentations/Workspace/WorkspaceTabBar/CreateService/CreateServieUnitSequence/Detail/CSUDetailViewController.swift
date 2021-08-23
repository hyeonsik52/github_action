//
//  CSUDetailViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

/// '단위서비스 생성'단 에서 사용되는 delegate 입니다.
/// CSU 는 Create Service Unit(단위서비스 생성) 의 줄임말입니다.
protocol CSUDelegate: class {
    
    /// 단위서비스 생성 과정에서 정보(대상, 수신자, 품목, 상세 요청 사항) 가 업데이트 되었음을 알려줍니다.
    func didUpdate(_ serviceUnitModel: CreateServiceUnitModel)
}

extension CSUDelegate {
    func didUpdate(_ serviceUnitModel: CreateServiceUnitModel) { }
}


class CSUDetailViewController: BaseNavigationViewController, ReactorKit.View {
    
    weak var csuEditDelegate: CSUEditDelegate?
    
    
    // MARK: - UI

    let scrollView = UIScrollView()

    let stackView = DetailStackView()
    
    let confirmButton = SRPButton("생성하기")
    
    /// 단위서비스를 수정할 때 closeButton 을 표출합니다.
    lazy var closeButton = UIBarButtonItem(
        image: UIImage(named: "navi-close"),
        style: .done,
        target: self,
        action: nil
    )
    

    // MARK: - Life cycles

    override func setupConstraints() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.scrollView.addSubview(self.stackView)
        self.stackView.snp.makeConstraints {
            $0.top.equalTo(self.scrollView.contentLayoutGuide.snp.top)
            $0.width.equalTo(ScreenSize.width)
            $0.bottom.equalTo(self.scrollView.contentLayoutGuide.snp.bottom)
        }
        
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = ""
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        if let isEditing = self.reactor?.isEditing, isEditing {
            self.navigationItem.setLeftBarButton(self.closeButton, animated: true)
        }
    }

    override func bind() {
        self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.cancelCreateServiceAlert { [weak self] in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }
        }).disposed(by: self.disposeBag)
        
        self.closeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }


    // MARK: - ReactorKit

    func bind(reactor: CSUDetailViewReactor) {
        
        self.rx.viewDidLoad.map { _ in Reactor.Action.setServiceUnit }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // 단위서비스 수정 시에는 '생성하기' 버튼의 문구를 '수정하기'로 바꾸어 표출합니다.
        if reactor.isEditing {
            self.confirmButton.setTitle("수정하기", for: .normal)
        }

        self.stackView.headerView.recipientChangeButton.rx.tap
            .map { reactor.reactorForTarget() }
            .subscribe(onNext: { [weak self] reactor in
                let viewController = CSUTargetViewController()
                viewController.reactor = reactor
                viewController.csuDelegate = self
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .fullScreen
                self?.present(navigationController, animated: true, completion: nil)
            }).disposed(by: self.disposeBag)

        func presentFreightVC(_ type: ServiceUnitFreightType) {
            let reactor = reactor.reactorForFreight(type)
            let viewController = CSUFreightsViewController()
            reactor.freightType = type
            viewController.reactor = reactor
            viewController.csuDelegate = self
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        
        self.stackView.loadView.headerView.addButton.rx.tap
            .subscribe(onNext: { _ in
                presentFreightVC(.load)
            }).disposed(by: self.disposeBag)
        
        self.stackView.unloadView.headerView.addButton.rx.tap
            .subscribe(onNext: { _ in
                presentFreightVC(.unload)
            }).disposed(by: self.disposeBag)
        
        self.stackView.loadView.indexOfDeletedButton
            .subscribe(onNext: { [weak self] index in
                self?.freightDeleteAlert(deleteHandler: {
                    reactor.action.onNext(.deleteFreight(type: .load, index: index))
                })
            }).disposed(by: self.disposeBag)
        
        self.stackView.unloadView.indexOfDeletedButton
        .subscribe(onNext: { [weak self] index in
            self?.freightDeleteAlert(deleteHandler: { 
                reactor.action.onNext(.deleteFreight(type: .unload, index: index))
            })
        }).disposed(by: self.disposeBag)

        self.stackView.messageView.didTap
            .map { reactor.reactorForMessage() }
            .subscribe(onNext: { [weak self] reactor in
                guard let self = self else { return }
                let viewController = CSUMessageViewController()
                viewController.reactor = reactor
                viewController.csuDelegate = self
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        self.confirmButton.rx.tap.map { reactor.serviceUnitModel }
            .subscribe(onNext: { [weak self] serviceUnitModel in
                if serviceUnitModel.serviceUnit.info.freights.count == 0 {
                    self?.warnFreightsCountAlert()
                } else {
                    if reactor.isEditing { // '수정하기'일 때
                        if let index = reactor.indexOfEditingRow {
                            self?.csuEditDelegate?.didEdit(serviceUnitModel, index: index)
                        }
                        self?.navigationController?.dismiss(animated: true, completion: nil)
                    } else { // '생성하기'일 때
                        let rootViewController = self?.navigationController?.viewControllers.first as? CreateServiceViewController
                        rootViewController?.reactor?.action.onNext(.appendServiceUnit(serviceUnitModel))
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
        }).disposed(by: self.disposeBag)

        reactor.state.map { $0.headerCellModel }
            .filterNil()
            .map { DetailHeaderCellViewReactor($0) }
            .subscribe(onNext: { [weak self] reactor in
                self?.stackView.headerView.reactor = reactor
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.headerCellModel }
            .filterNil()
            .map { _ in reactor.reactorForRecipientList() }
            .subscribe(onNext: { [weak self] reactor in
                self?.stackView.recipientsView.reactor = reactor
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.headerCellModel }
            .map { _ in reactor.serviceUnitModel.serviceUnit.info.targetType == .recipient }
            .bind(to: self.stackView.recipientsView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.loadFreights }
            .filterNil()
            .subscribe(onNext: { [weak self] _ in
                self?.stackView.loadView.reactor = reactor.reactorForFreightList(.load)
            }).disposed(by: self.disposeBag)

        reactor.state.map { $0.unloadFreights }
            .filterNil()
            .subscribe(onNext: { [weak self] _ in
                self?.stackView.unloadView.reactor = reactor.reactorForFreightList(.unload)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.message }
            .bind(to: self.stackView.messageView.messageTextfield.rx.text)
            .disposed(by: self.disposeBag)
    }

    func freightDeleteAlert(
        deleteHandler: @escaping (() -> Void)
    ) {
        let actions: [UIAlertController.AlertAction] = [
                .action(title: "물품 삭제", style: .destructive),
                .action(title: "취소", style: .cancel)
        ]

        UIAlertController.present(
            in: self,
            title: "해당 물품을 삭제합니다.",
            style: .actionSheet,
            actions: actions
        ).subscribe(onNext: { actionIndex in
            if actionIndex == 0 {
                deleteHandler()
            }
        }).disposed(by: self.disposeBag)
    }
    
    func cancelCreateServiceAlert(
        cancelCreateServiceHandler: @escaping (() -> Void)
    ) {
        let actions: [UIAlertController.AlertAction] = [
                .action(title: "서비스 생성 취소", style: .destructive),
                .action(title: "취소", style: .cancel)
        ]

        UIAlertController.present(
            in: self,
            title: "서비스 생성 취소",
            message: "작성 중인 서비스 생성을 취소할까요?",
            style: .alert,
            actions: actions
        ).subscribe(onNext: { actionIndex in
            if actionIndex == 0 {
                cancelCreateServiceHandler()
            }
        }).disposed(by: self.disposeBag)
    }
    
    func warnFreightsCountAlert() {
        let actions: [UIAlertController.AlertAction] = [
            .action(title: "확인", style: .default)
        ]

        UIAlertController.present(
            in: self,
            title: "보낼/받을 물품이 없어요 😭",
            message: "최소 1개 이상의 물품이 존재해야 합니다.",
            style: .alert,
            actions: actions
        ).subscribe(onNext: { _ in })
        .disposed(by: self.disposeBag)
    }
}

extension CSUDetailViewController: CSUDelegate {
    
    func didUpdate(_ serviceUnitModel: CreateServiceUnitModel) {
        self.reactor?.serviceUnitModel = serviceUnitModel
        self.reactor?.action.onNext(.setServiceUnit)
    }
}
