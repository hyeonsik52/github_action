//
//  WorkRequestViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/18.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import PanModal

class WorkRequestViewController: BaseNavigatableViewController, View {
    
    private let scrollView = UIScrollView().then {
        $0.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    }
    
    private let profileTopView = WorkRequestTopView()
    
    private var closeButton = UIButton().then{
        $0.setImage(UIImage(named: "navi-close"), for: .normal)
    }
    
    private var detailLabelContainer = UIView()
    private var detailLabel = UILabel().then{
        $0.font = .bold.20
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }
    
    private var workPlaceView = WorkRequestSelectedPlaceView().then { $0.isHidden = true }
    private var workTargetView = WorkRequestTargetView().then { $0.isHidden = true }
    private var loadingSectionView = WorkRequestTaskView(title: "실을 물품").then { $0.isHidden = true }
    private var unloadingSectionView = WorkRequestTaskView(title: "내릴 물품").then { $0.isHidden = true }
    private var robotInfoView = WorkRequestRobotView().then { $0.isHidden = true }
    private var targetSeletionView = WorkRequestSimpleTargetView(title: "작업 대상").then { $0.isHidden = true }
    private var destinationSeletionView = WorkRequestSimpleTargetView(title: "목적지").then { $0.isHidden = true }
    
    private var buttonContainer = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.isHidden = true
    }
    
    private var rejectButton = UIButton().then {
        $0.setTitle("거절", for: .normal)
        $0.titleLabel?.font = .bold.15
        $0.setTitleColor(.gray8C8C8C, for: .disabled)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .grayE6E6E6
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private var allowButton = SRPButton("수락하기")
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.backgroundColor = .white
        
        let creatorContainer = UIView()
        self.view.addSubview(creatorContainer)
        creatorContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(58)
        }
        
        creatorContainer.addSubview(self.profileTopView)
        self.profileTopView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(26)
        }
        
        creatorContainer.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(40)
            $0.leading.equalTo(self.profileTopView.snp.trailing).offset(10)
        }
        
        //--
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            $0.top.equalTo(creatorContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        let contentStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 10
        }
        self.scrollView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentStackView.addArrangedSubview(self.detailLabelContainer)
        self.detailLabelContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        self.detailLabelContainer.addSubview(self.detailLabel)
        self.detailLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.bottom.equalToSuperview().offset(-2)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().offset(-26)
        }
        
        contentStackView.addArrangedSubview(self.workPlaceView)
        self.workPlaceView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        contentStackView.addArrangedSubview(self.workTargetView)
        self.workTargetView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        contentStackView.addArrangedSubview(self.loadingSectionView)
        self.loadingSectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        contentStackView.addArrangedSubview(self.unloadingSectionView)
        self.unloadingSectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        contentStackView.addArrangedSubview(self.robotInfoView)
        self.robotInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        contentStackView.addArrangedSubview(self.targetSeletionView)
        self.targetSeletionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        contentStackView.addArrangedSubview(self.destinationSeletionView)
        self.destinationSeletionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        self.view.addSubview(self.buttonContainer)
        self.buttonContainer.snp.makeConstraints {
            $0.top.equalTo(self.scrollView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(90)
        }
        
        let insetUnit: CGFloat = 20
        let padding: CGFloat = 10
        let buttonUnit = (UIScreen.main.bounds.width - insetUnit*2 - padding)/3
        
        let buttonStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 10
        }
        self.buttonContainer.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
        }
        
        buttonStackView.addArrangedSubview(self.rejectButton)
        self.rejectButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(buttonUnit)
        }
        
        buttonStackView.addArrangedSubview(self.allowButton)
        self.allowButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: WorkRequestViewReactor) {

        //State        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { $0[0] == nil && $0[1] == true }
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.setupDatas(state: state)
                }
            })
            .disposed(by: self.disposeBag)
        
        //거절하면 창 닫기
        reactor.state.compactMap { $0.isRejected }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                reactor.action.onNext(.refresh)
            })
            .disposed(by: self.disposeBag)
        
        //수락, 작업 시작, 작업 완료, 작업 완료 철회 시 현재 화면 새로고침
        reactor.state.compactMap { $0.isAccepted }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                reactor.action.onNext(.refresh)
            })
            .disposed(by: self.disposeBag)
        reactor.state.compactMap { $0.isStarted }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                reactor.action.onNext(.refresh)
            })
            .disposed(by: self.disposeBag)
        reactor.state.compactMap { $0.isEnded }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                reactor.action.onNext(.refresh)
            })
            .disposed(by: self.disposeBag)
            //1단계 기능 제외
//        reactor.state.compactMap { $0.isRetry }
//            .distinctUntilChanged()
//            .subscribe(onNext: { _ in
//                reactor.action.onNext(.refresh)
//            })
//            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.alertMessage }
            .queueing(2)
            .filter { $0[0] == nil && $0[1] != nil }
            .map { $0[1] }
            .subscribe(onNext: { [weak self] errorMessage in
                
                //원래 '요청 수락 실패' 이지만, 다른 상황에서도 실패할 수 있기 때문에 '요청 실패'로 임시 수정함
                let actionController = UIAlertController(title: "요청 실패", message: errorMessage, preferredStyle: .alert)
                actionController.addAction(
                    UIAlertAction(title: "확인", style: .default) { action in
                        
                    }
                )
                self?.navigationController?.present(actionController, animated: true)
                
            })
            .disposed(by: self.disposeBag)
        
        //Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)

        self.workTargetView.didSelect
            .subscribe(onNext: { [weak self] notDetermined in

                if notDetermined {
                    let viewController = WorkTargetsViewController()
                    viewController.reactor = reactor.reactorForWorkTargetList()
                    let navigationController = PanModalFullNavigationController(rootViewController: viewController)
                    
                    self?.presentPanModal(navigationController)
                }else{
                    if let acceptor = reactor.currentState.serviceUnit?.acceptors.first as? ServiceUser {
                        
                        let viewController = SWSUserInfoViewController()
                        viewController.reactor = reactor.reactorForSwsUserInfo(userIdx: acceptor.idx)
                        let navigationController = PanModalFullNavigationController(rootViewController: viewController)
                        
                        self?.presentPanModal(navigationController)
                    }
                }
            })
            .disposed(by: self.disposeBag)

        self.targetSeletionView.didSelect
            .subscribe(onNext: { [weak self] in

                let viewController = WorkTargetsViewController()
                viewController.reactor = reactor.reactorForWorkTargetList()
                let navigationController = PanModalFullNavigationController(rootViewController: viewController)
                
                self?.presentPanModal(navigationController)
            })
            .disposed(by: self.disposeBag)

        self.destinationSeletionView.didSelect
            .subscribe(onNext: { [weak self] in

                let viewController = ServiceDetailViewController()
                viewController.reactor = reactor.reactorForServiceDetail(mode: .preview)
                let navigationController = PanModalFullNavigationController(rootViewController: viewController)
                
                self?.presentPanModal(navigationController)
            })
            .disposed(by: self.disposeBag)

        self.rejectButton.rx.tap
        .subscribe(onNext: { _ in
        //1단계 기능 제외
//            .subscribe(onNext: { [weak self] in
//            guard let serviceUnit = reactor.currentState.serviceUnit else { return }
                
//                func answerUserOrGroupActionSheet(_ group: ServiceUserGroup) {
//                    let myName = reactor.currentState.myInfo?.validName ?? "(이름 없음)"
//
//                    let actionController = UIAlertController(title: "그룹을 대상으로 요청한 서비스입니다.", message: nil, preferredStyle: .actionSheet)
//
//                    actionController.addAction(
//                        UIAlertAction(title: "\(group.name)으로 거절", style: .default) { action in
//                            reactor.action.onNext(.reject(.group))
//                        }
//                    )
//                    actionController.addAction(
//                        UIAlertAction(title: "\(myName)으로 거절", style: .default) { action in
//                            reactor.action.onNext(.reject(.user))
//                        }
//                    )
//                    actionController.addAction(UIAlertAction(title: "취소", style: .cancel))
//
//                    self?.present(actionController, animated: true)
//                }
//
//                if let groupTarget = serviceUnit.target as? ServiceUserGroup {
//                    answerUserOrGroupActionSheet(groupTarget)
//                }else if serviceUnit.target is ServiceUser {
//                    reactor.action.onNext(.reject(.user))
//                }else if serviceUnit.target is ServicePlace {
//                    let receivers = serviceUnit.receiverList
//                    if receivers.count == 1 {
//                        if let group = receivers.first as? ServiceUserGroup {
//                            answerUserOrGroupActionSheet(group)
//                        }else if receivers.first is ServiceUser {
//                            reactor.action.onNext(.reject(.user))
//                        }
//                    }else if receivers.count > 1 {
//                        reactor.action.onNext(.reject(.user))
//                    }
//                }
                
            //1단계 임시
                reactor.action.onNext(.reject(.user))
            })
            .disposed(by: self.disposeBag)

        self.allowButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let serviceUnit = reactor.currentState.serviceUnit else { return }
                
                func pushToSelectPlace(type: ServiceUnitResponseType) {
                    if reactor.currentState.serviceUnit?.isStopFixed == false {
                        let viewController = ChangeWorkPlaceViewController()
                        viewController.reactor = reactor.reactorForChangeWorkPlace(type)
                        viewController.delegate = self

                        self?.navigationController?.pushViewController(viewController, animated: true)
                    }else{
                        reactor.action.onNext(.accept(type))
                    }
                }
                
                switch serviceUnit.status {
                case .waitingResponse:

                    //1단계 기능 제외
//                    func answerUserOrGroupActionSheet(isPlace: Bool, _ group: ServiceUserGroup) {
//                        let myName = reactor.currentState.myInfo?.validName ?? "(이름 없음)"
//
//                        let actionController = UIAlertController(title: "그룹을 대상으로 요청한 서비스입니다.", message: nil, preferredStyle: .actionSheet)
//
//                        actionController.addAction(
//                            UIAlertAction(title: "\(group.name)으로 수락", style: .default) { action in
//                                if isPlace {
//                                    reactor.action.onNext(.accept(.group))
//                                }else{
//                                    pushToSelectPlace(type: .group)
//                                }
//                            }
//                        )
//                        actionController.addAction(
//                            UIAlertAction(title: "\(myName)으로 수락", style: .default) { action in
//                                if isPlace {
//                                    reactor.action.onNext(.accept(.user))
//                                }else{
//                                    pushToSelectPlace(type: .user)
//                                }
//                            }
//                        )
//                        actionController.addAction(UIAlertAction(title: "취소", style: .cancel))
//
//                        self?.present(actionController, animated: true)
//                    }

                    if let groupTarget = serviceUnit.target as? ServiceUserGroup {
                        //1단계 기능 제외
//                        answerUserOrGroupActionSheet(isPlace: false, groupTarget)
                        //1단계 임시
                        pushToSelectPlace(type: .user)
                    }else if serviceUnit.target is ServiceUser {
                        pushToSelectPlace(type: .user)
                    }else if serviceUnit.target is ServicePlace {
                        let receivers = serviceUnit.receiverList
                        if receivers.count == 1 {
                            if let group = receivers.first as? ServiceUserGroup {
                                //1단계 기능 제외
//                                answerUserOrGroupActionSheet(isPlace: true, group)
                    //1단계 임시
                    reactor.action.onNext(.accept(.user))
                            }else if receivers.first is ServiceUser {
                                reactor.action.onNext(.accept(.user))
                            }
                        }else if receivers.count > 1 {
                            reactor.action.onNext(.accept(.user))
                        }
                    }
                case .stop:
                    reactor.action.onNext(.beginWorking)
                case .working:
                    reactor.action.onNext(.endWorking)
                    //1단계 기능 제외
//                case .completed:
//                    reactor.action.onNext(.retryWorking)
                default:
                    break
                }
            })
            .disposed(by: self.disposeBag)
        
        //1단계 기능 제외
//        Observable<Int>
//            .interval(.seconds(1), scheduler: MainScheduler.instance)
//            .map { _ in Reactor.Action.setRemainTime }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
    }
    
    private func setupDatas(state: WorkRequestViewReactor.State) {
        guard let service = state.service,
            let serviceUnit = state.serviceUnit else { return }


        //요청 진행중 여부
        let amIRecipient = serviceUnit.amIRecipient
        let waitingResponse = service.combinePause(conditions: .waitingResponse, .canceledOnWaiting)//(serviceUnit.status == .waitingResponse)
        let amIRejector = state.serviceUnit?.rejectors.contains(where: {$0.isMe}) ?? false
        
        print(serviceUnit.status.rawValue)

        self.loadingSectionView.isHidden = false
        self.unloadingSectionView.isHidden = false
        
        if waitingResponse {
            
            //서비스 요청 대기 중인 경우
            if amIRecipient {
                
                //내 작업
                self.robotInfoView.isHidden = true
                self.destinationSeletionView.isHidden = false

                self.workPlaceView.isUserInteractionEnabled = !amIRejector
                
                if let _ = serviceUnit.target as? ServiceUser {
                    
                    //작업자 우선으로 대상이 나인 경우
                    print("서비스 요청 대기 중인 경우/", "내 작업/", "작업자 우선으로 대상이 나인 경우")
                    self.workPlaceView.isHidden = true
                    self.workTargetView.isHidden = true
                    self.targetSeletionView.isHidden = true

                }else if let group = serviceUnit.target as? ServiceUserGroup {

                    //작업자 우선으로 대상이 내가 속한 그룹인 경우
                    print("서비스 요청 대기 중인 경우/", "내 작업/", "작업자 우선으로 대상이 내가 속한 그룹인 경우")
                    self.workPlaceView.isHidden = true
                    self.workTargetView.isHidden = true
                    self.targetSeletionView.isHidden = false

                    self.targetSeletionView.bind(content: group.name)

                }else if let _ = serviceUnit.target as? ServicePlace {

                    //작업위치 우선으로 담당 정차지에 내가 포함된 경우
                    print("서비스 요청 대기 중인 경/우", "내 작업/", "작업위치 우선으로 담당 정차지에 내가 포함된 경우")
                    self.workPlaceView.isHidden = false
                    self.workTargetView.isHidden = true
                    self.targetSeletionView.isHidden = false

                    var receivers = ""
                    let receiverCount = serviceUnit.receiverList.count
                    if receiverCount > 1 {
                        receivers = "\(serviceUnit.receiverList[0].name) 외 \(receiverCount-1)"
                    }else if receiverCount == 1 {
                        receivers = serviceUnit.receiverList[0].name
                    }
                    self.targetSeletionView.bind(content: receivers)
                }

                let creator = service.creator
                self.profileTopView.bind(
                    content: "\(creator.name)님의 요청",
                    subContent: service.requestAt?.overDescription,
                    profileImageUrl: creator.profileImageURL,
                    number: nil
                )
                
            }else{

                self.robotInfoView.isHidden = false
                self.targetSeletionView.isHidden = true
                self.destinationSeletionView.isHidden = true
                
                if let _ = serviceUnit.target as? ServiceUser {

                    //작업자 우선으로 대상이 다른 사람인 경우
                    print("서비스 요청 대기 중인 경우/", "다른 이의 작업/", "작업자 우선으로 대상이 다른 사람인 경우")
                    self.workPlaceView.isHidden = false
                    self.workTargetView.isHidden = true

                }else if let _ = serviceUnit.target as? ServiceUserGroup {
                    
                    //작업자 우선으로 대상이 다른 팀인 경우
                    print("서비스 요청 대기 중인 경우/", "다른 이의 작업/", "작업자 우선으로 대상이 다른 팀인 경우")
                    self.workPlaceView.isHidden = false
                    self.workTargetView.isHidden = true
                    
                }else if let _ = serviceUnit.target as? ServicePlace {
                    
                    //작업위치 우선으로 담당 정차지에 내가 포함되지 않은 경우
                    print("서비스 요청 대기 중인 경우/", "다른 이의 작업/", "작업위치 우선으로 담당 정차지에 내가 포함되지 않은 경우")
                    self.workPlaceView.isHidden = true
                    self.workTargetView.isHidden = false
                    
                    self.workTargetView.bind(
                        content: "답변 대기 중",
                        profileImageUrl: nil,
                        usingSelection: true
                    )
                }

                self.workPlaceView.isUserInteractionEnabled = false

                let offset = service.serviceUnitList.enumerated().first{$0.element.serviceUnitIdx == serviceUnit.serviceUnitIdx}?.offset ?? -1
                let number = offset + 1

                self.profileTopView.bind(
                    content: serviceUnit.target.name,
                    subContent: nil,
                    profileImageUrl: serviceUnit.target.profileImageURL,
                    number: number
                )
            }
        }else{
            //진행중 또는 완료된 작업

            self.robotInfoView.isHidden = false
            self.targetSeletionView.isHidden = true
            self.destinationSeletionView.isHidden = true
            
            if amIRecipient {
                
                //내 작업
                if let _ = serviceUnit.target as? ServiceUser {
                    
                    //작업자 우선으로 대상이 나인 경우
                    print("진행중 또는 완료된 작업/", "내 작업/", "작업자 우선으로 대상이 나인 경우")
                    self.workPlaceView.isHidden = false
                    self.workTargetView.isHidden = true
                    
                }else if let _ = serviceUnit.target as? ServiceUserGroup {
                    
                    //작업자 우선으로 대상이 내가 속한 그룹인 경우
                    print("진행중 또는 완료된 작업/", "내 작업/", "작업자 우선으로 대상이 내가 속한 그룹인 경우")
                    self.workPlaceView.isHidden = false
                    self.workTargetView.isHidden = true
                    
                }else if let _ = serviceUnit.target as? ServicePlace {
                    
                    //작업위치 우선으로 담당 정차지에 내가 포함된 경우
                    print("진행중 또는 완료된 작업/", "내 작업/", "작업위치 우선으로 담당 정차지에 내가 포함된 경우")
                    self.workPlaceView.isHidden = true
                    self.workTargetView.isHidden = false
                }
            }else{
                
                //다른 이의 작업
                if let _ = serviceUnit.target as? ServiceUser {
                    
                    //작업자 우선으로 대상이 다른 사람인 경우
                    print("진행중 또는 완료된 작업/", "다른 이의 작업/", "작업자 우선으로 대상이 다른 사람인 경우")
                    self.workPlaceView.isHidden = false
                    self.workTargetView.isHidden = true
                    
                }else if let _ = serviceUnit.target as? ServiceUserGroup {
                    
                    //작업자 우선으로 대상이 다른 팀인 경우
                    print("진행중 또는 완료된 작업/", "다른 이의 작업/", "작업자 우선으로 대상이 다른 팀인 경우")
                    self.workPlaceView.isHidden = false
                    self.workTargetView.isHidden = true
                    
                }else if let _ = serviceUnit.target as? ServicePlace {
                    
                    //작업위치 우선으로 담당 정차지에 내가 포함되지 않은 경우
                    print("진행중 또는 완료된 작업/", "다른 이의 작업/", "작업위치 우선으로 담당 정차지에 내가 포함되지 않은 경우")
                    self.workPlaceView.isHidden = true
                    self.workTargetView.isHidden = false
                }
            }

            let acceptor = serviceUnit.acceptors.first
            self.workTargetView.bind(
                content: acceptor?.name,
                profileImageUrl: acceptor?.profileImageURL,
                usingSelection: false
            )

            self.workPlaceView.isUserInteractionEnabled = false

            let offset = service.serviceUnitList.enumerated().first{$0.element.serviceUnitIdx == serviceUnit.serviceUnitIdx}?.offset ?? -1
            let number = offset + 1

            self.profileTopView.bind(
                content: serviceUnit.target.name,
                subContent: nil,
                profileImageUrl: serviceUnit.target.profileImageURL,
                number: number
            )
        }
        
        
        //공통
        if let detail = serviceUnit.requestDetails {
            self.detailLabel.text = detail
        }else{
            self.detailLabelContainer.isHidden = true
        }

        self.workPlaceView.bind(serviceUnit.place)

        let load = serviceUnit.taskList.filter({$0.isLoading})
        if load.isEmpty {
            self.loadingSectionView.isHidden = true
        }else{
            self.loadingSectionView.bind(tasks: load)
        }

        let unload = serviceUnit.taskList.filter({!$0.isLoading})
        if unload.isEmpty {
            self.unloadingSectionView.isHidden = true
        }else{
            self.unloadingSectionView.bind(tasks: unload)
        }

        self.robotInfoView.bind(robotName: service.robotName ?? "없음")

        let offset = service.serviceUnitList.enumerated()
            .first{$0.element.serviceUnitIdx == serviceUnit.serviceUnitIdx}?.offset ?? -1
        let destinationDesc = "\(service.serviceUnitList.count)개 목적지 중 \(offset+1)번째"
        self.destinationSeletionView.bind(content: destinationDesc)
        
        
        /* 버튼 가시 여부 new
         1. 버튼 표시 여부 결정
         2. 거절 버튼 표시 여부 결정
         3. 수락 버튼 활성화 및 문구
        */
        
        // 1.
        switch serviceUnit.status {
        case .waitingResponse:
            //답변 대기 중은 내가 수신자일 경우 표시
            self.buttonContainer.isHidden = !(serviceUnit.amIRecipient)
        case .waiting:
            //작업 차례 대기일 때 서비스 상태가 '답변 대기 중' 상태이고, 내가 수신자일 경우 표시
            self.buttonContainer.isHidden = !(service.status == .waitingResponse && serviceUnit.amIRecipient)
        case .moving:
            //작업 위치로 이동은  표시하지 않음
            self.buttonContainer.isHidden = true
        case .stop:
            if serviceUnit.responseType == .some(.group) {
                //그룹으로 수락된 경우, 내가 거절하지 않았으면 표시
                self.buttonContainer.isHidden = serviceUnit.amIRejector
            }else if serviceUnit.responseType == .some(.user) {
                //개인은로 수락된 경우, 내가 수락했으면 표시
                self.buttonContainer.isHidden = !serviceUnit.amIAcceptor
            }
        case .working:
            //작업 중은 내가 작업자 인 경우 표시
            self.buttonContainer.isHidden = !serviceUnit.workerIsMe
        case .completed:
        //1단계 기능 제외
//            //작업 완료는 1.다른 단위 서비스 상태가 ['작업 위치 도착', '작업 중'] 이 아니고, 2.서비스 진행 중이 아니고, 3.내가 작업자인 경우일 때 표시 4.시간제한이 초과된 경우
//            let reworkable = !(state.service?.serviceUnitList.contains(where: {$0.isProcessingWithoutMoving}) ?? true)
//            let isProcessing = state.service?.isProcessing ?? false
//            let isExpired = (reactor?.currentState.retryTimeout ?? 0 <= 0)
//            self.buttonContainer.isHidden = !(reworkable && isProcessing && serviceUnit.workerIsMe && !isExpired)
            //1단계 임시
            self.buttonContainer.isHidden = true
        case .rejected, .canceled:
            //수락 거절, 서비스 취소됨은 표시
            self.buttonContainer.isHidden = false
        default:
            break
        }
        
        //서비스 취소됨
        switch service.status {
        case .pause, .canceledOnWorking, .canceledOnWaiting, .canceledOnReady, .error:
            //['서비스 요청 취소', '서비스 취소', '서비스 중단', '일시정지', '기기 오류']이면 버튼 표시
            self.buttonContainer.isHidden = false
        default:
            break
        }
        
        
        // 2.
        //서비스가 일시정지 상태가 아니면서, 답변 대기 중이면서, 내가 답변하지 않으면 '거절' 버튼 표시
        self.rejectButton.isHidden = !(service.status != .pause && serviceUnit.status == .waitingResponse && !serviceUnit.amIAnswered)
        
        
        // 3.
        func allowTitle(_ title: String, isEnabled: Bool = true) {
            if state.isProcessing ?? false {
                self.rejectButton.isEnabled = false
                self.allowButton.isEnabled = false
            }else{
                if isEnabled {
                    if self.allowButton.isEnabled != isEnabled {
                        let enabled = (self.allowButton.title(for: .normal) != title)
                        self.rejectButton.isEnabled = enabled
                        self.allowButton.isEnabled = enabled
                    }
                }else{
                    self.rejectButton.isEnabled = false
                    self.allowButton.isEnabled = false
                }
            }
            self.allowButton.setTitle(title, for: .normal)
        }
        
        switch serviceUnit.status {
        case .waitingResponse:
            //답변 대기 중
            if serviceUnit.amIRejector {
                //내가 거절함
                allowTitle("내가 거절한 서비스입니다.", isEnabled: false)
            }else{
                //그 외
                allowTitle("수락하기")
            }
        case .waiting:
            //답변 후 작업 대기 중
            if serviceUnit.amIAcceptor {
                //내가 수락함
                allowTitle("내가 수락한 서비스입니다.", isEnabled: false)
            }else if serviceUnit.amIRejector {
                //내가 거절함
                allowTitle("내가 거절한 서비스입니다.", isEnabled: false)
            }else if serviceUnit.isAnotherAccepted {
                //다른 이가 개인수락함
                allowTitle("이미 답변이 완료된 서비스입니다.", isEnabled: false)
            }else if serviceUnit.isGroupAccepted {
                //다른 이가 그룹수락함
                allowTitle("이미 그룹으로 수락된 서비스입니다.", isEnabled: false)
            }else if serviceUnit.isGroupRejected {
                //다른 이가 그룹거절함
                allowTitle("이미 답변이 완료된 서비스입니다.", isEnabled: false)
            }
        case .stop:
            //작업 위치 도착
            allowTitle("작업 시작하기")
        case .working:
            //작업 중
            allowTitle("작업 완료하기")
            //1단계 기능 제외
//        case .completed:
//            //작업 완료
//            var title = "작업 완료 철회하기"
//            if let retryTimeout = state.retryTimeout, retryTimeout > 0 {
//                title += " " + TimeInterval(retryTimeout).toTimeString
//            }
//            allowTitle(title)
        case .canceled:
            break
        case .rejected:
            //수락 거절
            if serviceUnit.amIRejector {
                //내가 거절함
                allowTitle("내가 거절한 서비스입니다.", isEnabled: false)
            }else{
                allowTitle("이미 답변이 완료된 서비스입니다.", isEnabled: false)
            }
        default:
            //그 외에 버튼 활성
            self.allowButton.isEnabled = true
        }
        
        //서비스 취소됨
        switch service.status {
        case .pause:
            //서비스 일시정지
            allowTitle("서비스가 일시정지 되었습니다.", isEnabled: false)
        case .canceledOnWorking, .error:
            //서비스 중단
            allowTitle("서비스가 중단되었습니다.", isEnabled: false)
        case .canceledOnWaiting, .canceledOnReady:
            //서비스 요청 취소
            allowTitle("요청이 취소된 서비스입니다.", isEnabled: false)
        default:
            break
        }
        
        //하단 버튼 영역을 모두 감추면 높이도 0으로 조절한다 (스크롤 영역 확장을 위함)
        self.buttonContainer.snp.updateConstraints {
            $0.height.equalTo(self.buttonContainer.isHidden ? 0: 90)
        }
    }
}

//MARK: Pan Modal Delegate

extension WorkRequestViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
//        return self.scrollView
        return nil
    }
}

extension WorkRequestViewController: ChangeWorkPlaceViewControllerDelegate {
    
    func didAccept() {
        guard let reactor = self.reactor else { return }
        reactor.action.onNext(.refresh)
    }
}
