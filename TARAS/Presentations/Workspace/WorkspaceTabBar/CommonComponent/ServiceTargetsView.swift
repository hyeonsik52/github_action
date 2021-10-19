//
//  ServiceTargetsView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/16.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class ServiceTargetsView: UIView {

    private let overlap: CGFloat = 6
    private let width: CGFloat = 34
    private lazy var distance = self.width - self.overlap
    
    private var imageViews = [UIImageView]()
    private var maxCount: Int!
    
    convenience init(_ maxWidth: CGFloat = UIScreen.main.bounds.width) {
        self.init(frame: .zero)
        
        self.setupConstraints(maxWidth)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(_ maxWidth: CGFloat) {
        
        self.maxCount = Int((maxWidth+2-self.overlap)/self.distance)
        
        for i in 0..<self.maxCount {
            
            let imageView = UIImageView().then {
                $0.isHidden = true
                $0.clipsToBounds = true
                $0.contentMode = .scaleAspectFill
                $0.layer.cornerRadius = 17
                $0.layer.borderWidth = 2
                $0.layer.borderColor = UIColor.white.cgColor
                $0.backgroundColor = .white
            }
            
            self.addSubview(imageView)
            imageView.snp.makeConstraints{
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().offset(distance*CGFloat(i)-1)
                $0.width.height.equalTo(width)
            }
            
            self.imageViews.append(imageView)
        }
    }
    
    func bind(_ targets: [ServiceNode]) {
        
        for i in 0..<self.imageViews.count {
            self.imageViews[i].setImage(strUrl: nil)
            if i < min(self.maxCount,targets.count) {
                self.imageViews[i].isHidden = false
                self.imageViews[i].setImage(strUrl: targets[i].profileImageURL)
            }else{
                self.imageViews[i].isHidden = true
            }
        }
    }
}
