//
//  WorkspaceTabBarController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/05/12.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import ReactorKit

class WorkspaceTabBarController: UITabBarController, View {
    
    var disposeBag = DisposeBag()
    
    enum Text {
        static let tab1 = "서비스 요청"
        static let tab2 = "내 서비스"
        static let tab3 = "더보기"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func bind(reactor: WorkspaceTabBarControllerReactor) {
        
        self.setupAppearance()
        
        //서비스 요청
        let workspaceHomeViewController = WorkspaceHomeViewController()
        workspaceHomeViewController.reactor = reactor.reactorForWorkspaceHome()
        
        let workspaceHomeNavigationController = UINavigationController(rootViewController: workspaceHomeViewController)
        workspaceHomeNavigationController.tabBarItem = UITabBarItem(
            title: Text.tab1,
            image: UIImage(named: "tab-service-off"),
            selectedImage: UIImage(named: "tab-service-on")
        )
        
        
        //내 서비스
        let serviceManagementViewController = ServiceManagementViewController()
        serviceManagementViewController.reactor = reactor.reactorForMyServices()
        
        let serviceManagementNavigationController = UINavigationController(rootViewController: serviceManagementViewController)
        serviceManagementNavigationController.tabBarItem = UITabBarItem(
            title: Text.tab2,
            image: UIImage(named: "tab-myService-off"),
            selectedImage: UIImage(named: "tab-myService-on")
        )
        
        //더보기
        let workspaceMoreViewController = WorkspaceMoreViewController()
        workspaceMoreViewController.reactor = reactor.reactorForMore()
        
        let receivedServicesNavigationController = UINavigationController(rootViewController: workspaceMoreViewController)
        receivedServicesNavigationController.tabBarItem = UITabBarItem(
            title: Text.tab3,
            image: UIImage(named: "tab-more-off"),
            selectedImage: UIImage(named: "tab-more-on")
        )
        
        self.viewControllers = [
            workspaceHomeNavigationController,
            serviceManagementNavigationController,
            receivedServicesNavigationController
        ]
        
    }
    
    fileprivate func setupAppearance() {
        self.tabBar.tintColor = .black0F0F0F
    }
}
