//
//  LargeTitleView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import UIKit
import Then
import SnapKit

/// 시스템 Large Navigation Bar 와 유사한 디자인이지만,
/// 컴포넌트가 적용되는 화면 별 레이아웃이 상이해 커스텀 뷰로 만들었습니다.
class LargeTitleView: UIView {
    
    let titleLabel = UILabel().then {
        $0.font = .medium[20]
        $0.textColor = .darkGray303030
    }


    // MARK: - Init

    init(_ title: String) {
        super.init(frame: .zero)

        self.titleLabel.text = title
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Constraints

    func setupConstraints() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
    }
}
