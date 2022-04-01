//
//  ForgotAccountCertifyEmailViewController.swift
//  TARAS
//
//  Created by 오현식 on 2022/03/31.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class ForgotAccountCertifyEmailViewController: BaseNavigationViewController {
    
    enum Text {
        static let completeCertifyEmailButtonTitle = "확인"
        static let retryCertifyEmailButtonTitle = "재인증"
    }
    
    lazy var forgotAccountCertifyEmailView = ForgotAccountCertifyEmailView()
    
    let confirmButton = SRPButton(Text.completeCertifyEmailButtonTitle)/*.then { // UI 확인하기 위한 주석
        $0.isEnabled = false
    }*/
    
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        self.forgotAccountCertifyEmailView.emailTextFieldBecomeFirstResponse()
        
        // UI 확인하기 위한 tap
        self.confirmButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let viewController = CompleteFindIdViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
    }

    override func setupConstraints() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.forgotAccountCertifyEmailView)
        self.forgotAccountCertifyEmailView.snp.makeConstraints {
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
