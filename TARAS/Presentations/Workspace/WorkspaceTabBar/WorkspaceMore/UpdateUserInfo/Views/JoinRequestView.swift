//
//  JoinRequestView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/19.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

protocol JoinRequestViewDelegate: AnyObject {
    func buttonDidTap(_ workspaceId: String, _ memberStatus: WorkspaceMemberStatus)
}

class JoinRequestView: UIView {
    
    /// 진입 유형
    enum EntryType {
        /// 가입 요청된 워크스페이스 정보
        case joinRequest
        /// 가입된 워크스페이스 정보
        case joined
    }
    
    enum Text {
        static let JRV_1 = "이미 가입된 워크스페이스입니다."
        static let JRV_2 = "가입 신청"
        static let JRV_3 = "가입 신청 취소"
        static let JRV_4 = "입장하기"
        static let JRV_5 = "yyyy.MM.dd 생성"
        static let JRV_6 = "탈퇴하기"
    }
    
    private let thumbnailImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.contentMode = .scaleAspectFill
    }
    
    private let nameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .bold[24]
        $0.textAlignment = .center
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .medium[14]
        $0.textAlignment = .center
    }
    
    private let joinedWorkspaceLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .medium[16]
        $0.textAlignment = .center
        $0.text = Text.JRV_1
        $0.isHidden = true
    }
    
    private let button = SRPButton("", appearance: .init(font: .bold[14]))
    
    weak var delegate: JoinRequestViewDelegate?
    var disposeBag = DisposeBag()
    var entryType: EntryType!
    
    init(entry: EntryType) {
        super.init(frame: .zero)
        self.entryType = entry
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.thumbnailImageView)
        self.thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(110)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.top.equalTo(self.thumbnailImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 26
        }
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        stackView.addArrangedSubview(self.dateLabel)
        stackView.addArrangedSubview(self.joinedWorkspaceLabel)
        
        self.addSubview(self.button)
        self.button.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(164)
            $0.height.equalTo(46)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bind(workspace: Workspace) {
        
        self.isHidden = false
        
        self.thumbnailImageView.setImage(strUrl: nil)
        self.nameLabel.text = workspace.name
        
        self.dateLabel.text = workspace.createdAt.toString(Text.JRV_5)
        self.joinedWorkspaceLabel.isHidden = (self.entryType! == .joined || workspace.myMemberStatus != .member)
        
        let buttonTitle: String = {
            switch workspace.myMemberStatus {
            case .member:
                switch self.entryType! {
                case .joinRequest:
                    return Text.JRV_4
                case .joined:
                    return Text.JRV_6
                }
            case .notMember: return Text.JRV_2
            case .requestingToJoin: return Text.JRV_3
            }
        }()
        
        let isNotMember = (workspace.myMemberStatus == .notMember)
        let grayAppearance = SRPButton.Appearance(
            font: .bold[14],
            titleColors: [.normal(.black)],
            backgroundColors: [.normal(.lightGrayF1F1F1)],
            cornerRadius: 4
        )
        let appearance: SRPButton.Appearance = (isNotMember ? .init(font: .bold[14]): grayAppearance)
        
        self.button.update(buttonTitle, appearance: appearance)
        
        self.disposeBag = DisposeBag()
        self.button.rx.throttleTap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.buttonDidTap(workspace.id, workspace.myMemberStatus)
            }).disposed(by: self.disposeBag)
    }
}

extension Reactive where Base: JoinRequestView {
    
    var workspace: Binder<Workspace> {
        return .init(base) { $0.bind(workspace: $1) }
    }
}
