//
//  WorkspaceMoreViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/25.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

class WorkspaceMoreViewController: BaseNavigatableViewController, ReactorKit.View {
    
    enum Text {
        static let Title = "정보"
        static let QuitTitle = "워크스페이스 탈퇴"
        static let QuitContent = NSMutableAttributedString(
            string: "\n탈퇴 시 워크스페이스 접근 권한을 잃게 됩니다.\n\n⋅ 워크스페이스 이용 내역 확인 불가\n⋅ 재가입 시 가입 승인 필요\n\n위 내용을 확인하고 워크스페이스에서 탈퇴합니다.",
            attributes: [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.black
            ]).then {
                $0.addAttribute(
                    .foregroundColor,
                    value: UIColor.redEB4D39,
                    range: NSRange(location: 29, length: 37)
                )
            }
        static let Cancel = "취소"
        static let Quit = "탈퇴"
        static let QuitComplate = "워크스페이스 탈퇴 완료"
    }
    
    private let settingButton = UIButton().then {
        //TODO
        $0.setImage(nil, for: .normal)
    }
    private lazy var titleView = WorkspaceTitleView(title: Text.Title, button: self.settingButton, buttonWidth: 52)
    private lazy var workspaceView = JoinRequestView(entry: .joined).then {
        $0.delegate = self
        $0.isHidden = true
    }
    
    override func setupConstraints() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.titleView)
        self.titleView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.view.addSubview(self.workspaceView)
        self.workspaceView.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bind(reactor: WorkspaceMoreViewReactor) {
        
        // Action
        self.rx.viewWillAppear
            .map {_ in Reactor.Action.reload }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.settingButton.rx.throttleTap
            .subscribe(onNext: { [weak self] in
                let viewController = DefaultMyInfoViewController()
                viewController.reactor = reactor.reactorForSetting()
                self?.trsNavigationController?.pushViewController(viewController, animated: true, hideBottom: true)
            }).disposed(by: self.disposeBag)

        // State
        reactor.state.compactMap { $0.workspace }
            .bind(to: self.workspaceView.rx.workspace)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .filterNil()
            .flatMapLatest { [weak self] message in
                UIAlertController.present(
                    in: self,
                    title: nil,
                    message: message,
                    style: .alert,
                    actions: [.action(title: "확인", style: .default)]
                )
            }
            .subscribe()
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.isQuit }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                Text.QuitComplate.sek.showToast()
                self?.tabBarController?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
    }
}

extension WorkspaceMoreViewController: JoinRequestViewDelegate {
    
    func buttonDidTap(_ workspaceId: String,_ memberState: WorkspaceMemberState) {
        guard let reactor = self.reactor else { return }
        switch memberState {
        case .member:

            let actions: [UIAlertController.AlertAction] = [
                .action(title: Text.Cancel, style: .cancel),
                .action(title: Text.Quit, style: .destructive)
            ]

            UIAlertController.present(
                in: self,
                title: Text.QuitTitle,
                attributedMessage: Text.QuitContent,
                style: .alert,
                actions: actions
            )
            .filter { $0 == 1 }
            .map {_ in Reactor.Action.quit }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
            
        default: break
        }
    }
}


//import UIKit
//import SnapKit
//import Then
//import ReactorKit
//
//class WorkspaceMoreViewController: BaseViewController, View {
//
//    private let scrollView = UIScrollView().then {
//        $0.contentInset.top = 10
//        $0.refreshControl = UIRefreshControl()
//    }
//
//    private let titleView = LargeTitleView(title: "더보기")
//
//    private let workspaceHeader = SettingScrollViewHeader(title: "워크스페이스")
//    private let workspaceCellView = SettingWorkspaceInfoView()
//    private let profileImageCellView = SettingProfileCellView(title: "프로필 사진")
//    private let nameCellView = SettingTextCellView(title: "이름")
//    private let emailCellView = SettingTextCellView(title: "이메일")
//    private let phoneNumberCellView = SettingTextCellView(title: "전화번호")
//    private let groupCellView = SettingTextCellView(title: "내가 속한 그룹")
//    private let placeCellView = SettingTextCellView(title: "기본 위치")
//    private let withdrawWorkspaceCellView = SettingTextCellView(title: "워크스페이스 탈퇴")
//
//    private let myInfoHeader = SettingScrollViewHeader(title: "내 정보")
//    private let defaultMyInfoCellView = SettingTextCellView(title: "기본 정보 설정")
//
//    private let helpHeader = SettingScrollViewHeader(title: "고객 센터")
//    private let helpCellView = SettingTextCellView(title: "도움말")
//    private let contactCellView = SettingTextCellView(title: "문의하기")
//
//    override init() {
//        super.init()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func setupNaviBar() {
//        super.setupNaviBar()
//
//        self.navigationController?.isNavigationBarHidden = true
//    }
//
//    override func setupConstraints() {
//        super.setupConstraints()
//
//        self.view.addSubview(self.titleView)
//        self.titleView.snp.makeConstraints {
//            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
//            $0.height.equalTo(44)
//        }
//        self.view.addSubview(self.scrollView)
//        self.scrollView.snp.makeConstraints {
//            $0.top.equalTo(self.titleView.snp.bottom)
//            $0.leading.trailing.bottom.equalToSuperview()
//        }
//
//        let contentView = UIStackView().then {
//            $0.axis = .vertical
//        }
//        self.scrollView.addSubview(contentView)
//        contentView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//            $0.width.equalToSuperview()
//        }
//
//        func addContent(_ view: UIView, height: CGFloat = 48) {
//            contentView.addArrangedSubview(view)
//            view.snp.makeConstraints {
//                $0.leading.trailing.equalTo(contentView)
//                $0.height.equalTo(height)
//            }
//        }
//
//        addContent(self.workspaceHeader, height: 55)
//        addContent(self.workspaceCellView, height: 66)
//        addContent(self.profileImageCellView)
//        addContent(self.nameCellView)
//        addContent(self.emailCellView)
//        addContent(self.phoneNumberCellView)
//        addContent(self.groupCellView)
//        addContent(self.placeCellView)
//        addContent(self.withdrawWorkspaceCellView)
//
//        addContent(self.myInfoHeader, height: 71)
//        addContent(self.defaultMyInfoCellView)
//
//        addContent(self.helpHeader, height: 71)
//        addContent(self.helpCellView)
//        addContent(self.contactCellView)
//
//        //footer
//        addContent(UIView(), height: 26)
//    }
//
//    func bind(reactor: WorkspaceMoreViewReactor) {
//
//        self.rx.viewDidLoad
//            .map { _ in Reactor.Action.refresh }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
//
//        self.rx.viewWillAppear.skip(1)
//            .map { _ in Reactor.Action.refresh }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
//
//        self.workspaceCellView.didSelect
//            .map(reactor.reactorForWorkspaceInfo)
//            .subscribe(onNext: { [weak self] reactor in
//
//                let viewController = WorkspaceInfoViewController()
//                viewController.reactor = reactor
//
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        self.profileImageCellView.didSelect
//            .map(reactor.reactorForProfileImageUpdate)
//            .subscribe(onNext: { [weak self] reactor in
//            })
//            .disposed(by: self.disposeBag)
//
//        self.nameCellView.didSelect
//            .map(reactor.reactorForNameUpdate)
//            .subscribe(onNext: { [weak self] reactor in
//
//                let viewController = UpdateNameViewController()
//                viewController.reactor = reactor
//
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        self.emailCellView.didSelect
//            .map(reactor.reactorForEmailUpdate)
//            .subscribe(onNext: { [weak self] reactor in
//
//                let viewController = UpdateEmailViewController()
//                viewController.reactor = reactor
//
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        self.phoneNumberCellView.didSelect
//            .map(reactor.reactorForPhoneNumberUpdate)
//            .subscribe(onNext: { [weak self] reactor in
//
//                let viewController = UpdatePhoneNumberViewController()
//                viewController.reactor = reactor
//
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        self.groupCellView.didSelect
//            .map(reactor.reactorForGroups)
//            .subscribe(onNext: { [weak self] reactor in
//
//                let viewController = BelongingGroupListViewController()
//                viewController.preferredTitle = "내가 속한 그룹"
//                viewController.reactor = reactor
//
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        self.placeCellView.didSelect
//            .map(reactor.reactorForSelectDefaultPlace)
//            .subscribe(onNext: { [weak self] reactor in
//
//                let viewController = SelectDefaultPlaceViewController()
//                viewController.reactor = reactor
//
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        self.withdrawWorkspaceCellView.didSelect
//            .subscribe(onNext: { [weak self] _ in
//                self?.quitSWSAlert {
//                    reactor.action.onNext(.requestQuitSWS)
//                }
//            })
//            .disposed(by: self.disposeBag)
//
//        self.defaultMyInfoCellView.didSelect
//            .map(reactor.reactorForDefaultMyInfo)
//            .subscribe(onNext: { [weak self] reactor in
//                let viewController = DefaultMyInfoViewController()
//                viewController.reactor = reactor
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        self.helpCellView.didSelect
//            .subscribe(onNext: { [weak self] _ in
//                let viewController = HelpViewController()
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        self.contactCellView.didSelect
//            .map(reactor.reactorForContact)
//            .subscribe(onNext: { [weak self] reactor in
//
//            })
//            .disposed(by: self.disposeBag)
//
//        self.scrollView.refreshControl?.rx.controlEvent(.valueChanged)
//            .map {_ in Reactor.Action.refresh }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
//
//        //State
//        reactor.state.compactMap { $0.workspace }
//            .bind(to: self.workspaceCellView.rx.workspace)
//            .disposed(by: self.disposeBag)
//
//        let userInfo = reactor.state.compactMap { $0.userInfo }
//
//        userInfo
//            .bind(to: self.profileImageCellView.rx.info)
//            .disposed(by: self.disposeBag)
//
//        userInfo
//            .map { $0.validName }
//            .bind(to: self.nameCellView.rx.detail)
//            .disposed(by: self.disposeBag)
//
//        userInfo
//            .map { $0.validEmail }
//            .bind(to: self.emailCellView.rx.detail)
//            .disposed(by: self.disposeBag)
//
//        userInfo
//            .map { $0.validPhoneNumber }
//            .map { reactor.provider.userManager.denationalizePhoneNumber($0) }
//            .bind(to: self.phoneNumberCellView.rx.detail)
//            .disposed(by: self.disposeBag)
//
//        reactor.state.compactMap { $0.userInfo?.swsUserInfo?.groups }
//            .map { groups -> String in
//                if groups.isEmpty {
//                    return "없음"
//                } else if groups.count == 1 {
//                    return groups.first!.name
//                } else {
//                    let first = groups.first!
//                    let remainder = groups.count - 1
//                    return "\(first.name) 외 \(remainder)"
//                }
//            }
//            .bind(to: self.groupCellView.rx.detail)
//            .disposed(by: self.disposeBag)
//
//        reactor.state.compactMap { $0.userInfo?.swsUserInfo }
//            .compactMap { $0.place?.name ?? $0.groups.first?.place?.name ?? "없음" }
//            .bind(to: self.placeCellView.rx.detail)
//            .disposed(by: self.disposeBag)
//
//        reactor.state.map { $0.alertMessage }
//            .distinctUntilChanged()
//            .subscribe(onNext: { [weak self] message in
//                self?.errorAlert(message)
//            }).disposed(by: self.disposeBag)
//
//        reactor.state.map { $0.didQuitSWS }
//            .distinctUntilChanged()
//            .filter { $0 == true }
//            .subscribe(onNext: { [weak self] _ in
//                let string = "워크스페이스에서 탈퇴되었습니다."
//                string.sek.showToast()
//
//                self?.tabBarController?.navigationController?.popViewController(animated: true)
//            }).disposed(by: self.disposeBag)
//
//        reactor.state.map { $0.isLoading }
//            .filter { $0 == false }
//            .subscribe(onNext: { [weak self] isLoading in
//                self?.scrollView.refreshControl?.endRefreshing()
//            })
//            .disposed(by: self.disposeBag)
//
//        reactor.state.map { $0.isLoading }
//            .distinctUntilChanged()
//            .queueing(2)
//            .map { $0[0] == nil && $0[1] == true }
//            .bind(to: self.activityIndicatorView.rx.isAnimating)
//            .disposed(by: self.disposeBag)
//    }
//
//    func errorAlert(_ title: String) {
//        let actions: [UIAlertController.AlertAction] = [.action(title: "확인", style: .cancel)]
//
//        UIAlertController.present(
//            in: self,
//            title: title,
//            style: .alert,
//            actions: actions
//        ).subscribe(onNext: { _ in })
//            .disposed(by: self.disposeBag)
//    }
//
//    func quitSWSAlert(quitHandler: @escaping (() -> Void)) {
//        let actions: [UIAlertController.AlertAction] = [
//                .action(title: "워크스페이스 탈퇴", style: .destructive),
//                .action(title: "취소", style: .cancel)
//        ]
//
//        UIAlertController.present(
//            in: self,
//            title: "워크스페이스 탈퇴",
//            message: """
//            \n워크스페이스 탈퇴 시 아래 정보를 잃게 되며, 재가입하더라도 삭제된 데이터는 복구되지 않습니다.\n\n
//            • 워크스페이스 관련 서비스 접근 및 조작 불가
//            • 워크스페이스 내 모든 서비스 이용 내역 삭제\n\n
//            위 내용을 확인하고 워크스페이스에서 탈퇴합니다.
//            """,
//            style: .alert,
//            actions: actions
//        ).subscribe(onNext: { actionIndex in
//            if actionIndex == 0 {
//                quitHandler()
//            }
//        }).disposed(by: self.disposeBag)
//    }
//}
