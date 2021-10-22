//
//  SRPSignUpInputView.swift
//
//  Created by Suzy Park on 2020/06/16.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class SRPInputView: UIView {

    enum ViewType {
        // 아이디, 이름... 입력
        case defaultView

        // 이메일 인증 코드, 전화번호 인증 코드 입력 (에러 메시지, 남은 시간, 재전송 버튼)
        case authCodeView

        // 전화번호 입력 (스킵 버튼)
        case phoneNumberView
    }
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - UI
    
    lazy var textView = SRPClearTextView()

    /// 지시사항 라벨 (ex. 가입 시 등록한 이메일 주소를 입력해주세요.)
    let descriptionLabel = UILabel().then {
        $0.font = .medium[16]
        $0.textColor = .black0F0F0F
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }

    /// - 남은 시간을 표출 (ex. "09:52")
    /// - viewType이 .authCodeView 일 때만 표출
    let remainsLabel = UILabel().then {
        $0.font = .bold[14]
        $0.textColor = .redEB4D39
        $0.textAlignment = .center
    }

    let errorMessageLabel = UILabel().then {
        $0.font = .bold[14]
        $0.textColor = .redEB4D39
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }

    /// viewType이 .authCodeView 일 때만 표출
    let authResendButton = GostButton("안증번호 재전송")

    /// viewType이 .phoneNumberView 일 때만 표출
    let skipButton = GostButton("다음에 설정하기")

    let confirmButton = SRPButton("확인")

    init(_ viewType: ViewType = .defaultView, description: String, buttonTitle: String = "확인") {
        super.init(frame: .zero)
        
        self.setupConstraints()
        self.setViewHidden(for: viewType)
        self.descriptionLabel.text = description
        self.confirmButton.setTitle(buttonTitle, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().offset(-12)
        }

        /*
         order...
         - descriptionLabel
         - remainsLabel
         - errorMessageLabel
         - authResendButton
         - skipButton
         */

        let guideItemsStackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 8
        }

        guideItemsStackView.addArrangedSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
        }

        guideItemsStackView.addArrangedSubview(self.remainsLabel)
        self.remainsLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
        }

        guideItemsStackView.addArrangedSubview(self.errorMessageLabel)
        self.errorMessageLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
        }

        guideItemsStackView.addArrangedSubview(self.authResendButton)
        self.authResendButton.snp.makeConstraints {
            $0.width.equalTo(160)
            $0.height.equalTo(20)
        }

        guideItemsStackView.addArrangedSubview(self.skipButton)
        self.skipButton.snp.makeConstraints {
            $0.width.equalTo(160)
            $0.height.equalTo(20)
        }

        self.addSubview(guideItemsStackView)
        guideItemsStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        let textViewContainerView = UIView()

        textViewContainerView.addSubview(self.textView)
        self.textView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview().offset(16)
        }
        
        let contentsStackView = UIStackView().then {
            $0.axis = .vertical
        }
        
        contentsStackView.addArrangedSubview(textViewContainerView)
        contentsStackView.addArrangedSubview(guideItemsStackView)
        
        self.addSubview(contentsStackView)
        contentsStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.confirmButton.snp.top).offset(-32)
        }
    }
    
    private func setViewHidden(for viewType: ViewType) {
        switch viewType {
        case .defaultView:
            self.remainsLabel.isHidden = true
            self.authResendButton.isHidden = true
            self.skipButton.isHidden = true
            
        case .authCodeView:
            self.skipButton.isHidden = true
            
        case .phoneNumberView:
            self.remainsLabel.isHidden = true
            self.authResendButton.isHidden = true
        }
    }
}
