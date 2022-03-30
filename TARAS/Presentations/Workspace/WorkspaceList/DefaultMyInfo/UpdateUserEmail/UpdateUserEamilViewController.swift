//
//  UpdateUserEamilViewController.swift
//  TARAS
//
//  Created by 오현식 on 2022/03/29.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class UpdateUserEmailViewController: BaseNavigationViewController {
    
    override var navigationPopWithBottomBarHidden: Bool {
        return true
    }
    
    enum Text {
        static let completeCertifyEmailButtonTitle = "확인"
        static let retryCertifyEmailButtonTitle = "재인증"
    }
    
    lazy var certifyEmailView = CertifyEmailView()
    
    let confirmButton = SRPButton(Text.completeCertifyEmailButtonTitle).then {
        $0.isEnabled = false
    }
    
    var serialTimer: Disposable?
    
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        self.certifyEmailView.emailTextFieldBecomeFirstResponse()
    }

    override func setupConstraints() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.certifyEmailView)
        self.certifyEmailView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
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
    }
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        
        let margin = height+12
        self.confirmButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-margin)
        }
    }
}
