//
//  WorkspaceStopDetailViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class WorkspaceStopDetailViewController: BaseNavigationViewController {

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .lightGrayF5F5F5
    }
    
    private var imageUrl: String?
    
    convenience init(_ workspace: Workspace) {
        self.init()
        
        self.imageUrl = nil
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.setImage(strUrl: self.imageUrl)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.imageView)
        self.imageView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "정차지 정보"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
}
