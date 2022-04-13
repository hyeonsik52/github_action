//
//  TRSRecentSearchTermsView.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/22.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TRSRecentSearchTermsView: UIView {
    
    static let uniqueKey = "TRSRecentSearchTermsViewUniqueKey"
    
    enum Text {
        static let title = "최근 검색어"
        static let delete = "전체삭제"
    }
    
    enum Image {
        static let delete = UIImage(named: "delete")
    }
    
    let deleteAllButton = UIButton().then {
        $0.setTitle(Text.delete, for: .normal)
        $0.setTitleColor(.gray787579, for: .normal)
        $0.titleLabel?.font = .regular[14]
        $0.contentEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: -5)
    }
    
    let tagListView = TRSTagListView().then {
        $0.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    private let disposeBag = DisposeBag()
    
    init(unique: String) {
        super.init(frame: .zero)
        
        self.tagListView.userInfo[Self.uniqueKey] = unique
        
        self.setupConstraints()
        self.bind(with: unique)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        let topContainer = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
        }
        self.addSubview(topContainer)
        topContainer.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(28)
        }
        
        let titleLabel = UILabel().then {
            $0.font = .regular[16]
            $0.textColor = .black
            $0.text = Text.title
        }
        topContainer.addArrangedSubview(titleLabel)
        
        topContainer.addArrangedSubview(self.deleteAllButton)
        self.deleteAllButton.snp.makeConstraints {
            $0.width.equalTo(48)
        }
        
        self.addSubview(self.tagListView)
        self.tagListView.snp.makeConstraints {
            $0.top.equalTo(topContainer.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
            $0.height.equalTo(28)
        }
    }
    
    private func bind(with unique: String) {
        
        self.update(with: unique)
    }
    
    func update(with unique: String) {
        
        let terms = SimpleDefualts.shared.loadRecentSearchTerms(with: unique)
        self.tagListView.setTags(terms)
    }
}
