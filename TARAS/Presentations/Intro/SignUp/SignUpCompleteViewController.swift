//
//  SignUpCompleteViewController.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/08/20.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class SignUpCompleteViewController: BaseNavigatableViewController {

    enum Text {
        static let title = "회원가입이 완료되었습니다."
        static let guide = "로그인한 후,\n전화번호 혹은 이메일을 인증하지 않은 계정은 계정 찾기가\n불가능합니다. [내 정보]에서 해당 정보를 인증해주세요."
        static let loginButtonTitle = "로그인하기"
    }
    
    private let guideView = SignUpGuideView(Text.title, guideText: Text.guide)
    
    let nextButton = TRSButton(Text.loginButtonTitle)
    

    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 화면 전환
        self.nextButton.rx.throttleTap(.seconds(3))
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self?.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    override func setupConstraints() {

        self.view.addSubview(self.guideView)
        self.guideView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints {
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
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
