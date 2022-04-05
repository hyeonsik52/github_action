//
//  CompleteResetPasswordViewController.swift
//  TARAS
//
//  Created by 오현식 on 2022/04/05.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class CompleteResetPasswordViewController: BaseNavigationViewController {
    
    enum Text {
        static let SUVC_1 = "비밀번호가 재설정되었습니다."
        static let SUVC_2 = "변경된 정보로 로그인해주세요."
        static let SUVC_3 = "로그인하기"
    }
    
    let guideView = ForgotAccountGuideView(Text.SUVC_1, guideText: Text.SUVC_2)
    
    let toWorkspaceButton = SRPButton(Text.SUVC_3)
    
    
    // MARK: - Life Cycles
    
    override func setupConstraints() {

        self.view.addSubview(self.guideView)
        self.guideView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(self.toWorkspaceButton)
        self.toWorkspaceButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationItem.setLeftBarButton(nil, animated: false)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        
        let margin = height+12
        self.toWorkspaceButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-margin)
        }
    }
}



