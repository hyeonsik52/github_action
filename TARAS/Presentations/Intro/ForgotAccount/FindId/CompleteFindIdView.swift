//
//  CompleteFindIdView.swift
//  TARAS
//
//  Created by 오현식 on 2022/03/31.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class CompleteFindIdView: UIView {
    
    enum Text {
        static let SUVC_1 = "아이디를 찾았습니다."
        static let SUVC_2 = "고객님의 정보와 일치하는 아이디는 아래와 같습니다."
        static let SUVC_3 = "비밀번호 찾기"
    }
    
    
    // MARK: - UI
    
    /// 시스템 라지 네비바 형태의 뷰 + "고객님의 정보와 일치하는 아이디는 아래와 같습니다." 라벨
    private let guideView = ForgotAccountGuideView(Text.SUVC_1, guideText: Text.SUVC_2)
    
    /// 유저 아이디 표시 텍스트 필드
    lazy var idTextFieldView = ForgotAccountTextFieldView(viewType: .deliveryRequest)
    
    /// '비밀번호 찾기' 버튼
    let findPwButton = UIButton().then {
        $0.titleLabel?.font = .bold[16]
        $0.setTitleColor(.purple4A3C9F, for: .normal)
        $0.setTitleWithUnderLine(Text.SUVC_3, for: .normal)
        $0.setBackgroundColor(color: .clear, forState: .normal)
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Constaraints
    
    func setupContraints() {
        self.addSubview(self.guideView)
        self.guideView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(self.idTextFieldView)
        self.idTextFieldView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(self.guideView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.addSubview(self.findPwButton)
        self.findPwButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.top.equalTo(self.idTextFieldView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
    }
}
