//
//  TRSListPlaceholderView.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/26.
//

import UIKit
import SnapKit
import Then

class TRSListPlaceholderView: UIView {
    
    private let notFoundPlaceholder = TRSPlaceholderView(.init(
        title: "검색 결과가 없습니다.",
        edges: .init(top: 48, left: 0, bottom: 0, right: 0),
        image: .init(named: "results-not-found")
    )).then {
        $0.isHidden = true
    }
    
    let disconnectedRetryButton = UIButton().then {
        $0.setImage(.init(named: "refresh"), for: .normal)
        $0.setTitle("다시 시도하기", for: .normal)
        $0.setTitleColor(.purple6750A4, for: .normal)
        $0.titleLabel?.font = .medium[14]
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray79747E.cgColor
        $0.imageEdgeInsets = .init(top: 0, left: -8, bottom: 0, right: 8)
    }
    
    private lazy var disconnectedPlaceholder = TRSPlaceholderView(.init(
        title: "연결 상태가 일시적으로 불안정합니다.",
        edges: .init(top: 64, left: 0, bottom: 0, right: 0),
        image: .init(named: "network-disconnected"),
        description: "잠시 후 다시 시도해 주세요.",
        subViews: [{
            let container = UIView()
            container.addSubview(self.disconnectedRetryButton)
            self.disconnectedRetryButton.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.centerX.bottom.equalToSuperview()
                $0.width.equalTo(148)
                $0.height.equalTo(52)
            }
            return container
        }()]
    )).then {
        $0.isHidden = true
    }
    
    init() {
        super.init(frame: .zero)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.notFoundPlaceholder)
        self.notFoundPlaceholder.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(self.disconnectedPlaceholder)
        self.disconnectedPlaceholder.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func update(_ state: PlaceholderStateType?) {
        self.notFoundPlaceholder.isHidden = (state != .resultNotFound)
        self.disconnectedPlaceholder.isHidden = (state != .networkDisconnected)
    }
}

enum PlaceholderStateType {
    case resultNotFound
    case networkDisconnected
}
