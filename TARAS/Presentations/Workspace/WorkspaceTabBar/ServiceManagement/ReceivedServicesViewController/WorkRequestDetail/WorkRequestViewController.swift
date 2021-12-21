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
    
    private var detailLabelContainer = UIView()
    private var detailLabel = UILabel().then{
        $0.font = .bold[20]
        $0.textColor = .black0F0F0F
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }

    private var workTargetView = WorkRequestTargetView()
    private var robotInfoView = WorkRequestRobotView()
    
    private var buttonContainer = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
    private var closeButton = SRPButton("닫기")
    
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
            $0.trailing.equalToSuperview().offset(-16)
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
        
        contentStackView.addArrangedSubview(self.workTargetView)
        self.workTargetView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        contentStackView.addArrangedSubview(self.robotInfoView)
        self.robotInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
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
        
        buttonStackView.addArrangedSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: WorkRequestViewReactor) {

        //State        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { $0[0] == nil && $0[1] == true }
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.setupDatas(state: state)
                }
            })
            .disposed(by: self.disposeBag)
        
        //수락, 작업 시작, 작업 완료, 작업 완료 철회 시 현재 화면 새로고침
        reactor.state.compactMap { $0.isEnded }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                reactor.action.onNext(.refresh)
            }).disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
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
                
                    if let acceptor = reactor.currentState.serviceUnit?.receiver {
                        
                        let viewController = SWSUserInfoViewController()
                        viewController.reactor = reactor.reactorForSwsUserInfo(userId: acceptor.id)
                        let navigationController = PanModalFullNavigationController(rootViewController: viewController)
                        
                        self?.presentPanModal(navigationController)
                    }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupDatas(state: WorkRequestViewReactor.State) {
        guard let service = state.service,
            let serviceUnit = state.serviceUnit else { return }

        self.profileTopView.bind(content: serviceUnit.stop.name, subContent: nil, profileImageUrl: nil, number: nil)
        
        self.detailLabel.text = serviceUnit.detail
        
        let receivers = serviceUnit.receiver.displayName//.map { $0.displayName }.joined(separator: ", ")
        self.workTargetView.bind(content: receivers, profileImageUrl: nil)
    }
}

//MARK: Pan Modal Delegate

extension WorkRequestViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
//        return self.scrollView
        return nil
    }
}
