//
//  ServiceManagementViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/17.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit

class ServiceManagementViewController: BaseViewController, View {
    
    private var titleView = SRPLargeTitleView(title: "내 서비스")
    private var receivedServiceButton = UIButton(type: .custom).then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.isSelected = true
        $0.setBackgroundColor(color: .white, forState: .normal)
        $0.setBackgroundColor(color: Color.LIGHT_PUPLE_EBEAF4, forState: .selected)
        $0.setTitleColor(Color.GRAY_999999, for: .normal)
        $0.setTitleColor(Color.PURPLE_4A3C9F, for: .selected)
        $0.tintColor = .clear
        $0.setTitle("수신 서비스", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        $0.adjustsImageWhenHighlighted = false
    }
    private var createdServiceButton = UIButton(type: .custom).then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.setBackgroundColor(color: .white, forState: .normal)
        $0.setBackgroundColor(color: Color.LIGHT_PUPLE_EBEAF4, forState: .selected)
        $0.setTitleColor(Color.GRAY_999999, for: .normal)
        $0.setTitleColor(Color.PURPLE_4A3C9F, for: .selected)
        $0.tintColor = .clear
        $0.setTitle("생성 서비스", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        $0.adjustsImageWhenHighlighted = false
    }
    
    private var innerPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                               navigationOrientation: .horizontal)
    private var receivedServiceViewController: ReceivedServicesViewController!
    private var createdServiceViewController: CreatedServicesViewController!
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.addSubview(self.titleView)
        self.titleView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        let stackView = UIStackView().then{
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
        }
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        stackView.addArrangedSubview(self.receivedServiceButton)
        stackView.addArrangedSubview(self.createdServiceButton)
        
        self.view.addSubview(self.innerPageViewController.view)
        self.innerPageViewController.view.snp.makeConstraints{
            $0.top.equalTo(stackView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func bind(reactor: ServiceManagementViewReactor) {

        self.receivedServiceViewController = ReceivedServicesViewController()
        self.receivedServiceViewController.reactor = reactor.reactorForReceivedServices()
        self.receivedServiceViewController.delegate = self
        
        self.createdServiceViewController = CreatedServicesViewController()
        self.createdServiceViewController.reactor = reactor.reactorForCreatedServices()
        self.createdServiceViewController.delegate = self
        
        self.receivedServiceViewController.view.layoutIfNeeded()
        self.createdServiceViewController.view.layoutIfNeeded()
        
        self.receivedServiceButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.receivedServiceButton.isSelected = true
                self.createdServiceButton.isSelected = false
                
                self.innerPageViewController.setViewControllers(
                    [self.receivedServiceViewController],
                    direction: .forward,
                    animated: false
                )
            })
            .disposed(by: self.disposeBag)
        
        self.createdServiceButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.createdServiceButton.isSelected = true
                self.receivedServiceButton.isSelected = false
                
                self.innerPageViewController.setViewControllers(
                    [self.createdServiceViewController],
                    direction: .forward,
                    animated: false
                )
            })
            .disposed(by: self.disposeBag)
        
        self.innerPageViewController.setViewControllers(
            [self.receivedServiceViewController],
            direction: .forward,
            animated: false
        )
    }
}
