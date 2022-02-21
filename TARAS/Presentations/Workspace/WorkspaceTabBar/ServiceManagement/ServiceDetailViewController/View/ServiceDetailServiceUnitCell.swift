//
//  ServiceDetailServiceUnitCell.swift
//  TARAS
//
//  Created by nexmond on 2022/02/08.
//

import UIKit

import SnapKit
import Then
import ReactorKit
import RxSwift

class ServiceDetailServiceUnitCell: UITableViewCell, View, ReusableView {
    
    private let upperRobotImageView = UIImageView().then {
        $0.image = .init(named: "robot")
        $0.isHidden = true
    }
    private let upperLineView = ProgressLineView(lineAxis: .vertical)
    
    private let lowerRobotImageView = UIImageView().then {
        $0.image = .init(named: "robot")
        $0.isHidden = true
    }
    private let lowerLineView = ProgressLineView(lineAxis: .vertical)
    
    private let titleLabel = UILabel().then {
        $0.font = .medium[16]
        $0.textColor = .black0F0F0F
    }
    
    private let myWorkFlagView = UILabel().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.orange.cgColor
        $0.layer.borderWidth = 1
        $0.textAlignment = .center
        $0.backgroundColor = .orange.withAlphaComponent(0.1)
        $0.font = .bold[14]
        $0.textColor = .orange
        $0.text = "MY"
        $0.isHidden = true
    }
    
    let separator = UIView().then {
        $0.backgroundColor = .grayEDEDED
    }
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.backgroundColor = .clear
        self.backgroundView = nil
        
        self.selectionStyle = .none
        self.selectedBackgroundView = nil
        
        let progressContainer = UIView()
        self.contentView.addSubview(progressContainer)
        progressContainer.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(20)
        }
        
        progressContainer.addSubview(self.upperLineView)
        self.upperLineView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.contentView.snp.centerY)
        }
        
        progressContainer.addSubview(self.lowerLineView)
        self.lowerLineView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.contentView.snp.centerY)
        }
        
        progressContainer.addSubview(self.upperRobotImageView)
        self.upperRobotImageView.snp.makeConstraints {
            $0.centerX.equalTo(self.upperLineView)
            $0.centerY.equalTo(self.contentView.snp.top)
            $0.size.equalTo(32)
        }
        
        let circle = UIView().then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.grayB4B4B4.cgColor
            $0.layer.borderWidth = 2
            $0.backgroundColor = .white
        }
        progressContainer.addSubview(circle)
        circle.snp.makeConstraints {
            $0.centerX.equalTo(self.upperLineView)
            $0.centerY.equalTo(self.contentView)
            $0.size.equalTo(16)
        }
        
        progressContainer.addSubview(self.lowerRobotImageView)
        self.lowerRobotImageView.snp.makeConstraints {
            $0.centerX.equalTo(self.upperLineView)
            $0.centerY.equalTo(self.contentView)
            $0.size.equalTo(32)
        }
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.contentView)
            $0.leading.equalTo(progressContainer.snp.trailing).offset(20)
        }
        
        self.contentView.addSubview(self.myWorkFlagView)
        self.myWorkFlagView.snp.makeConstraints {
            $0.centerY.equalTo(self.contentView)
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(40)
            $0.height.equalTo(24)
        }
        
        self.contentView.addSubview(self.separator)
        self.separator.snp.makeConstraints {
            $0.leading.equalTo(progressContainer.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func bind(reactor: ServiceDetailServiceUnitCellReactor) {
        let serviceUnit = reactor.initialState.serviceUnit
        let isMyWork = reactor.initialState.isMyWork
        let isServiceInProgress = reactor.initialState.isServiceInProgress
        let isServicePreparing = reactor.initialState.isServicePreparing
        let robotArrivalState = reactor.initialState.robotArrivalState
        let isThisInProgress = serviceUnit.isInProgress
        let isLastCell = reactor.isLastCell
        
        self.myWorkFlagView.isHidden = !isMyWork
        self.titleLabel.text = serviceUnit.stop.name
        self.titleLabel.font = (isServiceInProgress && isThisInProgress ? UIFont.bold: .regular)[14]
        self.titleLabel.textColor = (isServiceInProgress && robotArrivalState != .passed ? .black0F0F0F: .grayC9C9C9)
        
        self.upperRobotImageView.isHidden = !isServiceInProgress || !((robotArrivalState == .waiting && isThisInProgress) || robotArrivalState == .departure)
        self.lowerRobotImageView.isHidden = !isServiceInProgress || (robotArrivalState != .arrival)
        
        self.lowerLineView.isHidden = isLastCell
        self.separator.isHidden = isLastCell
        
        if isServiceInProgress {
            if isServicePreparing {
                self.upperLineView.update(lineWidth: 1, lineColor: .grayB4B4B4, isLineDashed: true)
                self.lowerLineView.update(lineWidth: 1, lineColor: .grayB4B4B4, isLineDashed: true)
            } else {
                switch robotArrivalState {
                case .waiting, .departure:
                    self.upperLineView.update(lineWidth: 3, lineColor: .purple4A3C9F, isLineDashed: false)
                    self.lowerLineView.update(lineWidth: 3, lineColor: .purple4A3C9F, isLineDashed: false)
                case .arrival:
                    self.upperLineView.update(lineWidth: 2, lineColor: .grayB4B4B4, isLineDashed: false)
                    self.lowerLineView.update(lineWidth: 3, lineColor: .purple4A3C9F, isLineDashed: false)
                case .passed:
                    self.upperLineView.update(lineWidth: 2, lineColor: .grayB4B4B4, isLineDashed: false)
                    self.lowerLineView.update(lineWidth: 2, lineColor: .grayB4B4B4, isLineDashed: false)
                }
            }
        } else {
            self.upperLineView.update(lineWidth: 2, lineColor: .grayB4B4B4, isLineDashed: false)
            self.lowerLineView.update(lineWidth: 2, lineColor: .grayB4B4B4, isLineDashed: false)
        }
    }
}
