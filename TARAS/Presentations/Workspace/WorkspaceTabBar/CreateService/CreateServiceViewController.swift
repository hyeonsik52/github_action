//
//  CreateServiceViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources
import RxSwift
import RxCocoa
import SnapKit

protocol CSUEditDelegate: AnyObject {
    func didEdit(_ serviceUnitModel: CreateServiceUnitModel, index: Int)
}

class CreateServiceViewController: BaseViewController, ReactorKit.View {
    
    /// self.tableView 의 footer 와 header 에서 공통으로 사용되는 CGRect 입니다.
    let headerFooterRect = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 40), height: 60)
    
    // MARK: - UI

    let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "navi-close"), for: .normal)
    }

    let titleLabel = UILabel().then {
        $0.text = "0개의 목적지"
        $0.textColor = .black
        $0.font = .bold[24]
    }

    lazy var footerView = CreateServiceFooterView(frame: headerFooterRect)

    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor.clear
        let containerView = UIView(frame: headerFooterRect).then {
            $0.addSubview(self.titleLabel)
            self.titleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(16)
                $0.height.equalToSuperview()
            }
        }
        $0.tableHeaderView = containerView
        $0.tableFooterView = self.footerView
        $0.contentInset.bottom = 100
        $0.dragInteractionEnabled = true
        $0.dragDelegate = self
        $0.dropDelegate = self
        $0.register(CreateServiceCell.self)
    }

    let requestButton = SRPButton("요청하기")

    // MARK: - Life cycles

    override func setupConstraints() {
        
        self.view.backgroundColor = .lightGrayF1F1F1
        
        self.view.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }

        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.closeButton.snp.bottom).offset(8) // 위 주석 풀 시, 삭제 필요
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }

        let buttonBackgroundView = UIView().then {
            $0.backgroundColor = .lightGrayF1F1F1
        }

        buttonBackgroundView.addSubview(self.requestButton)
        self.requestButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
        }

        self.view.addSubview(buttonBackgroundView)
        buttonBackgroundView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func setupNaviBar() {
        self.navigationController?.navigationBar.isHidden = true
    }


    // MARK: - ReactorKit

    func bind(reactor: CreateServiceViewReactor) {
        
        self.closeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
        /// 단위서비스가 '생성'되었을 때에만 (수정할 때는 제외) tableView 를 footerView 까지 내립니다.
        func scrollToFooter() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.layoutIfNeeded()
                let rect = CGRect(
                    x: 0,
                    y: self.tableView.contentSize.height - self.tableView.bounds.size.height,
                    width: self.tableView.bounds.size.width,
                    height: self.tableView.bounds.size.height)
                
                self.tableView.scrollRectToVisible(rect, animated: true)
            }
        }
        
        let dataSource = RxTableViewSectionedReloadDataSource<CreateServiceSection>(
            configureCell: { [weak self] _, tableView, indexPath, cellReactor in
                guard let self = self else { return UITableViewCell() }
                let cell = tableView.dequeueCell(
                    ofType: CreateServiceCell.self,
                    indexPath: indexPath
                )
                
                cell.reactor = cellReactor
                cell.setIndex(row: indexPath.row)
                cell.createServiceCellDelegate = self
                
                if indexPath.row == reactor.serviceUnits.count - 1,
                   reactor.currentState.scrollToFooter {
                    scrollToFooter()
                }
                return cell
            })

        dataSource.canMoveRowAtIndexPath = { _, _ in true }

        self.tableView.rx.itemMoved
            .map(Reactor.Action.moveServiceUnit)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.itemSelected
            .map(reactor.reactorForDetail)
            .subscribe(onNext: { [weak self] reactor in
                let viewController = CSUDetailViewController()
                viewController.reactor = reactor
                viewController.csuEditDelegate = self
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .fullScreen
                self?.navigationController?.present(navigationController, animated: true, completion: nil)
                
            }).disposed(by: self.disposeBag)

        self.footerView.didSelect
            .map { _ in reactor.reactorForTarget() }
            .subscribe(onNext: { [weak self] reactor in
                guard let self = self else { return }
                let viewController = CSUTargetViewController()
                viewController.reactor = reactor
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        self.requestButton.rx.tap
            .map { _ in Reactor.Action.setRequest }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.serviceId }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] serviceId in
                let str = "서비스가 생성되었습니다."
                str.sek.showToast()
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
                
        let section = reactor.state.map { $0.section }
        
        section
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)

        section.map { "\($0.first?.items.count ?? 0)개의 목적지" }
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        // '서비스 생성' 버튼 비활성화 조건은 다음과 같습니다.
        // 1. 단위서비스가 두 개 미만일 때
        section.map { $0.first?.items.count ?? 0 >= 2 }
            .bind(to: self.requestButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
         
        // 2. 생성 요청 중일 때
        // 관련 이슈: https://github.com/twinnyKR/ServiceRobotPlatform-iOS/issues/144
        // 관련 문제 해결 문서: https://twinny.atlassian.net/wiki/spaces/IOS/pages/1220116491
        reactor.state.map { $0.isNetworking }
            .skip(1)
            .distinctUntilChanged()
            .map { !$0 }
            .bind(to: self.requestButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isNetworking }
            .distinctUntilChanged()
            .map { $0 == true ? "요청 중": "요청하기" }
            .bind(to: self.requestButton.rx.title(for: .normal))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }

    func editWaypointAlert(
        editHandler: @escaping (() -> Void),
        deleteHandler: @escaping (() -> Void)
    ) {
        let actions: [UIAlertController.AlertAction] = [
                .action(title: "경유 위치 수정", style: .default),
                .action(title: "삭제", style: .destructive),
                .action(title: "취소", style: .cancel)
        ]

        UIAlertController.present(
            in: self,
            title: "경유지 설정",
            style: .actionSheet,
            actions: actions
        ).subscribe(onNext: { actionIndex in
            if actionIndex == 0 {
                editHandler()
            } else if actionIndex == 1 {
                deleteHandler()
            }
        }).disposed(by: self.disposeBag)
    }

    func deleteCellAlert(
        deleteHandler: @escaping (() -> Void)
    ) {
        let actions: [UIAlertController.AlertAction] = [
                .action(title: "목적지 삭제", style: .destructive),
                .action(title: "취소", style: .cancel)
        ]

        UIAlertController.present(
            in: self,
            title: "해당 목적지를 삭제합니다.",
            style: .actionSheet,
            actions: actions
        ).subscribe(onNext: { actionIndex in
            if actionIndex == 0 {
                deleteHandler()
            }
        }).disposed(by: self.disposeBag)
    }

    func warnWaypointAlert() {
        let actions: [UIAlertController.AlertAction] = [
                .action(title: "확인", style: .default)
        ]

        UIAlertController.present(
            in: self,
            title: "목적지 이동 불가 🤖",
            message: "경유지가 포함된 목적지는 첫 번째 목적지가 될 수 없습니다.",
            style: .alert,
            actions: actions
        ).subscribe(onNext: { _ in })
            .disposed(by: self.disposeBag)
    }
}

extension CreateServiceViewController: CreateServiceCellDelegate {

    func didDeleteButtonTap(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        self.deleteCellAlert {
            self.reactor?.action.onNext(.deleteServiceUnit(indexPath))
        }
    }
}

extension CreateServiceViewController: CSUEditDelegate {
    func didEdit(_ serviceUnitModel: CreateServiceUnitModel, index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.reactor?.action.onNext(.updateServiceUnit(indexPath, serviceUnitModel))
    }
}

//extension CreateServiceViewController: UITableViewDelegate {
//    func tableView(
//        _ tableView: UITableView,
//        targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
//        toProposedIndexPath proposedDestinationIndexPath: IndexPath
//    ) -> IndexPath {
//        return proposedDestinationIndexPath
//    }
//}

extension CreateServiceViewController: UITableViewDragDelegate {
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        guard let reactor = self.reactor else { return [] }
        return reactor.dragItems(for: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        dragPreviewParametersForRowAt indexPath: IndexPath
    ) -> UIDragPreviewParameters? {
        return clearPreviewParameters(at: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        dropPreviewParametersForRowAt indexPath: IndexPath
    ) -> UIDragPreviewParameters? {
        return clearPreviewParameters(at: indexPath)
    }

    func clearPreviewParameters(at indexPath: IndexPath) -> UIDragPreviewParameters? {
        let cell = tableView.cellForRow(at: indexPath) as! CreateServiceCell
        let previewParameters = UIDragPreviewParameters()
        let path = UIBezierPath(
            roundedRect: CGRect(
                x: 16,
                y: 0,
                width: cell.frame.width - 32,
                height: cell.frame.height - 14
            ),
            cornerRadius: 8
        )
        previewParameters.visiblePath = path
        previewParameters.backgroundColor = .clear
        return previewParameters
    }
}

extension CreateServiceViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        guard let reactor = self.reactor else { return false }
        return reactor.draggedItem(session: session)
    }

    func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UITableViewDropProposal {
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            }
        }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func tableView(
        _ tableView: UITableView,
        performDropWith coordinator: UITableViewDropCoordinator
    ) { }
}
