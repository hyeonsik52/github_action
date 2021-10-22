//
//  FindAccountIdResultView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class FindAccountIdResultView: UIView {
    
    enum Text {
        static let FAIRV_1 = "아이디를 찾았습니다."
        static let FAIRV_2 = "고객님의 정보와 일치하는 아이디는 아래와 같습니다."
        static let FAIRV_3 = "비밀번호 찾기"
        static let FAIRV_4 = "일치하는 아이디가 없습니다."
    }
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - UI
    
    private let guideView = SignUpGuideView(Text.FAIRV_1, guideText: Text.FAIRV_2).then {
        $0.setContentHuggingPriority(.defaultLow+2, for: .vertical)
    }
    private let contentView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    let findPasswordButton = GostButton(Text.FAIRV_3, color: .purple4A3C9F).then {
        $0.setContentHuggingPriority(.defaultLow+1, for: .vertical)
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
        
        let scrollView = UIScrollView().then {
            $0.verticalScrollIndicatorInsets.right = -20
            $0.contentInset.bottom = 16
        }
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.guideView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        self.addContent(Text.FAIRV_4)
    }
    
    private func getCellView(_ text: String) -> UIView {
        let container = UIView().then {
            $0.backgroundColor = .grayF6F6F6
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
        }
        let label = UILabel().then {
            $0.font = .bold[18]
            $0.textColor = .black0F0F0F
            $0.text = text
        }
        container.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
        }
        return container
    }
    
    private func addContent(_ text: String) {
        let view = self.getCellView(text)
        self.contentView.addArrangedSubview(view)
        view.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
    func bind(ids: [String]) {
        
        self.contentView.subviews.forEach{$0.removeFromSuperview()}
        
        ids.forEach(self.addContent)
        
        let view = UIView()
        self.contentView.addArrangedSubview(view)
        view.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        view.addSubview(self.findPasswordButton)
        self.findPasswordButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.center.equalToSuperview()
        }
    }
}
