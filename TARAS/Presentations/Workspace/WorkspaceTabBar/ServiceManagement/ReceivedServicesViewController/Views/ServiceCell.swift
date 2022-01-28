//
//  ServiceCell.swift
//  TARAS
//
//  Created by nexmond on 2022/01/28.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift

class ServiceCell: UICollectionViewCell, View {
    
    enum Text {
        static let titleFormatForNormal = "%@님의 요청"
        static let passStopCountFormat = "+ 경유지 %d개"
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .medium[18]
        $0.textColor = .darkGray303030
        $0.numberOfLines = 0
    }
    
    private let requestTimeLabel = UILabel().then {
        $0.font = .medium[16]
        $0.textColor = .grayA0A0A0
    }
    
    //단일 목적지일 때 감추기 (여기부터)
    private let beginStopContainer = UIView()
    private let beginStopLabel = UILabel().then {
        $0.font = .regular[14]
        $0.textColor = .gray535353
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private let processLine = UIView().then {
        $0.backgroundColor = .lightGrayDDDDDD
    }
    
    private let passStopCountLabel = UILabel().then {
        $0.font = .regular[12]
        $0.textColor = .gray8C8C8C
    }
    //단일 목적지일 때 감추기 (여기까지)
    
    private let endStopLabel = UILabel().then {
        $0.font = .medium[14]
        $0.textColor = .darkGray303030
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.size = self.contentView.systemLayoutSizeFitting(UICollectionViewCell.layoutFittingExpandedSize)
        attributes.size.width = UIScreen.main.bounds.width - 16*2
        return attributes
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        self.backgroundView?.layer.shadowPath = UIBezierPath(
            roundedRect: .init(
                origin: .zero,
                size: self.contentView.bounds.size
            ),
            cornerRadius: 12
        ).cgPath
    }
    
    private func setupConstraints() {
        
        //그림자 뷰
        self.clipsToBounds = false
        self.backgroundView = UIView().then {
            $0.layer.shadowColor = UIColor(hex: "#33646C").cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowOffset = .init(width: 0, height: 3)
            $0.isHidden = true
        }
        
        self.contentView.do {

            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            
            let topContainer = UIView()
            $0.addSubview(topContainer)
            topContainer.snp.makeConstraints {
                $0.top.equalToSuperview().offset(12)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20).priority(.high)
                $0.height.equalTo(28)
            }

            //서비스 진행 상태
            topContainer.addSubview(self.titleLabel)
            self.titleLabel.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            
            //수평 분리자
            let separator = UIView().then {
                $0.backgroundColor = .lightGrayF1F1F1
            }
            $0.addSubview(separator)
            separator.snp.makeConstraints {
                $0.top.equalTo(topContainer.snp.bottom).offset(10)
                $0.leading.equalToSuperview().offset(24)
                $0.trailing.equalToSuperview().offset(-24)
                $0.height.equalTo(1)
            }

            let bottomContainer = UIView()
            $0.addSubview(bottomContainer)
            bottomContainer.snp.makeConstraints {
                $0.top.equalTo(separator.snp.bottom).offset(10)
                $0.leading.equalToSuperview().offset(24)
                $0.trailing.equalToSuperview().offset(-24).priority(.high)
                $0.height.equalTo(76)
            }

            let bottomContainerInnerView = UIStackView().then {
                $0.axis = .vertical
                $0.distribution = .fill
                $0.spacing = 36
            }
            bottomContainer.addSubview(bottomContainerInnerView)
            bottomContainerInnerView.snp.makeConstraints {
                $0.centerY.leading.trailing.equalToSuperview()
            }

            //출발지
            bottomContainerInnerView.addArrangedSubview(self.beginStopContainer)
            self.beginStopContainer.snp.makeConstraints {
                $0.height.equalTo(20)
            }

            let beginDot = UIView().then {
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 4
                $0.layer.borderWidth = 2
                $0.layer.borderColor = UIColor.darkGray303030.cgColor
            }
            self.beginStopContainer.addSubview(beginDot)
            beginDot.snp.makeConstraints {
                $0.centerY.leading.equalToSuperview()
                $0.size.equalTo(8)
            }

            self.beginStopContainer.addSubview(self.beginStopLabel)
            self.beginStopLabel.snp.makeConstraints {
                $0.top.trailing.bottom.equalToSuperview()
                $0.leading.equalTo(beginDot.snp.trailing).offset(12)
            }

            //도착지
            let endStopContainer = UIView()
            bottomContainerInnerView.addArrangedSubview(endStopContainer)
            endStopContainer.snp.makeConstraints {
                $0.height.equalTo(20)
            }

            let endDot = UIView().then {
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 4
                $0.layer.borderWidth = 2
                $0.layer.borderColor = UIColor.darkGray303030.cgColor
            }
            endStopContainer.addSubview(endDot)
            endDot.snp.makeConstraints {
                $0.centerY.leading.equalToSuperview()
                $0.size.equalTo(8)
            }

            endStopContainer.addSubview(self.endStopLabel)
            self.endStopLabel.snp.makeConstraints {
                $0.top.trailing.bottom.equalToSuperview()
                $0.leading.equalTo(endDot.snp.trailing).offset(12)
            }

            //수직 진행 바
            $0.addSubview(self.processLine)
            self.processLine.snp.makeConstraints {
                $0.top.equalTo(bottomContainer.snp.top).offset(18)
                $0.bottom.equalTo(bottomContainer.snp.bottom).offset(-18)
                $0.leading.equalTo(bottomContainer.snp.leading).offset(3.5)
                $0.width.equalTo(1)
            }

            //경유지 개수
            bottomContainer.addSubview(self.passStopCountLabel)
            self.passStopCountLabel.snp.makeConstraints {
                $0.centerY.trailing.equalToSuperview()
                $0.leading.equalToSuperview().offset(24)
                $0.bottom.equalToSuperview().offset(-12).priority(.high)
            }
        }
    }
    
    func bind(reactor: ServiceCellReactor) {
        let service = reactor.initialState.service
        
        switch service.phase {
        case .waiting:
            self.contentView.backgroundColor = .white
            self.backgroundView?.isHidden = false
        case .delivering:
            self.contentView.backgroundColor = .white
            self.backgroundView?.isHidden = false
        case .completed:
            self.contentView.backgroundColor = .lightGrayF5F6F7
            self.backgroundView?.isHidden = true
        case .canceled:
            self.contentView.backgroundColor = .lightGrayF5F6F7
            self.backgroundView?.isHidden = true
        case .all:
            break
        }
        
        let title: String = (
            service.type == .general ?
                .init(format: Text.titleFormatForNormal, service.creator.displayName):
                service.serviceUnits.last?.detail ?? ""
        )
        let titleWidth = UIScreen.main.bounds.width - 16*2 - 120
        let paragraph = NSMutableParagraphStyle().then {
            $0.minimumLineHeight = 28
            $0.lineSpacing = 2
        }
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.medium[18], .paragraphStyle: paragraph]
        let titleHeight = (title as NSString).boundingRect(
            with: .init(width: titleWidth, height: .infinity),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        ).height
        self.titleLabel.snp.updateConstraints {
            $0.height.equalTo(titleHeight)
        }
        self.titleLabel.attributedText = .init(string: title, attributes: attributes)
        
        self.requestTimeLabel.text = service.requestedAt.toString("HH:mm")

        let isSingleDestination = (service.serviceUnits.count == 1)
        if isSingleDestination {
            self.processLine.isHidden = true
            self.passStopCountLabel.isHidden = true
            self.beginStopContainer.isHidden = true
        } else {
            self.processLine.isHidden = false
            self.beginStopContainer.isHidden = false
            
            self.beginStopLabel.text = service.serviceUnits.first?.stop.name
            
            let passStopCount = service.serviceUnits.count - 2
            self.passStopCountLabel.isHidden = (passStopCount <= 0)
            self.passStopCountLabel.text = .init(format: Text.passStopCountFormat, passStopCount)
        }
        
        self.endStopLabel.text = service.serviceUnits.last?.stop.name
    }
}
