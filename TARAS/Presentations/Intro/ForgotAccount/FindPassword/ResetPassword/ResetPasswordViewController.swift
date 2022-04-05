//
//  ResetPasswordViewController.swift
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

class ResetPasswordViewController: BaseNavigationViewController {
    
    enum Text {
        static let SUVC_1 = "다음"
    }
    
    lazy var resetPasswordView = ResetPasswordView()
    
    let toCompleteResetPasswordButton = SRPButton(Text.SUVC_1)
    
    
    // MARK: - Life Cycles
    
    // ui 확인용 push navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toCompleteResetPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let viewController = CompleteResetPasswordViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        self.resetPasswordView.passwordTextFieldBecomeFirstResponse()
    }
    
    override func setupConstraints() {

        self.view.addSubview(self.resetPasswordView)
        self.resetPasswordView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(self.toCompleteResetPasswordButton)
        self.toCompleteResetPasswordButton.snp.makeConstraints {
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
        self.toCompleteResetPasswordButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-margin)
        }
    }
}


