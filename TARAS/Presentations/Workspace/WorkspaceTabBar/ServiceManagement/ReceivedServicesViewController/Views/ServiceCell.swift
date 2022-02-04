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
        static let requestorFormat = "%@님의 요청"
        static let passStopCountFormat = "+ 경유지 %d개"
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .medium[18]
        $0.textColor = .darkGray303030
    }
    
    private let requestorLabel = UILabel().then {
        $0.font = .medium[16]
        $0.textColor = .darkGray303030
    }
    
    private let requestTimeLabel = UILabel().then {
        $0.font = .medium[16]
        $0.textColor = .grayA0A0A0
        $0.textAlignment = .right
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
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
                $0.top.equalToSuperview().offset(12).priority(.high)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.height.equalTo(28)
            }

            //서비스 진행 상태
            topContainer.addSubview(self.titleLabel)
            self.titleLabel.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            
            //수평 분리자
            let topSeparator = UIView().then {
                $0.backgroundColor = .lightGrayF1F1F1
            }
            $0.addSubview(topSeparator)
            topSeparator.snp.makeConstraints {
                $0.top.equalTo(topContainer.snp.bottom).offset(10)
                $0.leading.equalToSuperview().offset(24)
                $0.trailing.equalToSuperview().offset(-24)
                $0.height.equalTo(1)
            }

            let middleContainer = UIView()
            $0.addSubview(middleContainer)
            middleContainer.snp.makeConstraints {
                $0.top.equalTo(topSeparator.snp.bottom).offset(10)
                $0.leading.equalToSuperview().offset(24)
                $0.trailing.equalToSuperview().offset(-24)
                $0.height.equalTo(76)
            }

            let middleContainerInnerView = UIStackView().then {
                $0.axis = .vertical
                $0.distribution = .fill
                $0.spacing = 36
            }
            middleContainer.addSubview(middleContainerInnerView)
            middleContainerInnerView.snp.makeConstraints {
                $0.centerY.leading.trailing.equalToSuperview()
            }

            //출발지
            middleContainerInnerView.addArrangedSubview(self.beginStopContainer)
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
            middleContainerInnerView.addArrangedSubview(endStopContainer)
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
                $0.top.equalTo(middleContainer.snp.top).offset(18)
                $0.bottom.equalTo(middleContainer.snp.bottom).offset(-18)
                $0.leading.equalTo(middleContainer.snp.leading).offset(3.5)
                $0.width.equalTo(1)
            }

            //경유지 개수
            middleContainer.addSubview(self.passStopCountLabel)
            self.passStopCountLabel.snp.makeConstraints {
                $0.centerY.trailing.equalToSuperview()
                $0.leading.equalToSuperview().offset(24)
                $0.bottom.equalToSuperview().offset(-12)
            }
            
            //수평 분리자
            let bottomSeparator = UIView().then {
                $0.backgroundColor = .lightGrayF1F1F1
            }
            $0.addSubview(bottomSeparator)
            bottomSeparator.snp.makeConstraints {
                $0.top.equalTo(middleContainer.snp.bottom).offset(10)
                $0.leading.equalToSuperview().offset(24)
                $0.trailing.equalToSuperview().offset(-24)
                $0.height.equalTo(1)
            }
            
            let bottomContainer = UIView()
            $0.addSubview(bottomContainer)
            bottomContainer.snp.makeConstraints {
                $0.top.equalTo(bottomSeparator.snp.bottom).offset(10)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.bottom.equalToSuperview().offset(-12)
                $0.height.equalTo(28)
            }
            
            bottomContainer.addSubview(self.requestorLabel)
            self.requestorLabel.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
            }
            
            bottomContainer.addSubview(self.requestTimeLabel)
            self.requestTimeLabel.snp.makeConstraints {
                $0.leading.equalTo(self.requestorLabel.snp.trailing).offset(8)
                $0.top.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    func bind(reactor: ServiceCellReactor) {
        let service = reactor.initialState.service
        let isMyTurn = reactor.initialState.isMyTurn
        
        self.contentView.backgroundColor = (isMyTurn ? .purpleEEE8F4: .white)
        
        switch service.phase {
        case .waiting, .delivering:
            self.contentView.backgroundColor = .white
            self.backgroundView?.isHidden = false
        case .completed, .canceled:
            self.contentView.backgroundColor = .lightGrayF5F6F7
            self.backgroundView?.isHidden = true
        case .all:
            break
        }
        
        self.titleLabel.text = service.stateDescription
        
        self.endStopLabel.text = service.serviceUnits.last?.stop.name
        
        let isSingleDestination = (service.serviceUnits.count == 1)
        if isSingleDestination {
            self.processLine.isHidden = true
            self.passStopCountLabel.isHidden = true
            self.beginStopContainer.isHidden = true
            
            
            self.endStopLabel.textColor = (service.currentServiceUnitIdx == 1 ? .purple4A3C9F: .darkGray303030)
        } else {
            self.processLine.isHidden = false
            self.beginStopContainer.isHidden = false
            
            self.beginStopLabel.text = service.serviceUnits.first?.stop.name
            
            let passStopCount = service.serviceUnits.count - 2
            self.passStopCountLabel.isHidden = (passStopCount <= 0)
            self.passStopCountLabel.text = .init(format: Text.passStopCountFormat, passStopCount)
            
            
            self.beginStopLabel.textColor = (service.currentServiceUnitIdx == 1 ? .purple4A3C9F: .gray535353)
            self.passStopCountLabel.textColor = (service.currentServiceUnitIdx > 1 && service.currentServiceUnitIdx < service.serviceUnits.count  ? .purple4A3C9F: .gray8C8C8C)
            self.endStopLabel.textColor = (service.currentServiceUnitIdx == service.serviceUnits.count  ? .purple4A3C9F: .darkGray303030)
        }
        
        self.requestorLabel.text = .init(format: Text.requestorFormat, service.creator.displayName)
        self.requestTimeLabel.text = service.requestedAt.toString("yy.MM.dd E HH:mm")
    }
}
