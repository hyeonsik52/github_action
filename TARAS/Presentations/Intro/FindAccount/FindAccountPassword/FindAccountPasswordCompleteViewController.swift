//
//  FindAccountPasswordCompleteViewController.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class FindAccountPasswordCompleteViewController: BaseViewController {
    
    enum Text {
        static let FAPCVC_1 = "비밀번호가 재설정되었습니다."
        static let FAPCVC_2 = "변경된 정보로 로그인해주세요."
        static let FAPCVC_3 = "로그인하기"
    }
    
    private let guideView = SignUpGuideView(Text.FAPCVC_1, guideText: Text.FAPCVC_2)
    private let nextButton = SRPButton(Text.FAPCVC_3)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
    
    override func setupConstraints() {
        
        self.view.addSubview(self.guideView)
        self.guideView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
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
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func bind() {
        
        self.nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: self.disposeBag)
    }
}
