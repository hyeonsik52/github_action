//
//  ServiceCreationRepeatCountViewController.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/13.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

//TODO: 숫자 증감, 수동 입력에 대한 단위테스트 필요
class ServiceCreationRepeatCountViewController: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = .bold[18]
        $0.textColor = .black0F0F0F
        $0.text = "반복 횟수 설정"
    }
    
    private let decreaseButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.setBackgroundColor(color: .purple4A3C9F, forState: .normal)
        $0.adjustsImageWhenHighlighted = true
        $0.setTitle("-", for: .normal)
    }
    
    private lazy var valueTextField = UITextField().then {
        $0.font = .medium[18]
        $0.textColor = .black0F0F0F
        $0.textAlignment = .center
        $0.keyboardType = .asciiCapableNumberPad
        $0.delegate = self
    }
    
    private let increaseButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.setBackgroundColor(color: .purple4A3C9F, forState: .normal)
        $0.adjustsImageWhenHighlighted = true
        $0.setTitle("+", for: .normal)
    }
    
    let confirmButton = SRPButton("서비스 생성하기")
    
    let maxValue: Int
    let minValue: Int
    
    var value: Int
    
    init(value: Int, maxValue: Int = .max, minValue: Int? = nil) {
        self.value = min(maxValue, value)
        self.maxValue = maxValue
        self.minValue = minValue ?? self.value
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.backgroundColor = .clear
        
        let navigationContainer = UIView()
        self.view.addSubview(navigationContainer)
        navigationContainer.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        navigationContainer.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        let componentContainer = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .equalCentering
            $0.spacing = 32
        }
        self.view.addSubview(componentContainer)
        componentContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(navigationContainer.snp.bottom).offset(16)
            $0.leading.greaterThanOrEqualToSuperview().offset(16)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        componentContainer.addArrangedSubview(self.decreaseButton)
        self.decreaseButton.snp.makeConstraints {
            $0.size.equalTo(32)
        }
        componentContainer.addArrangedSubview(self.valueTextField)
        self.valueTextField.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(64)
        }
        componentContainer.addArrangedSubview(self.increaseButton)
        self.increaseButton.snp.makeConstraints {
            $0.size.equalTo(32)
        }
        
        let guideLabel = UILabel().then {
            $0.font = .regular[14]
            $0.textColor = .gray888888
            $0.textAlignment = .center
            $0.text = "서비스를 반복할 횟수를 설정해주세요."
        }
        self.view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(componentContainer.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(60)
        }
    }
    
    override func bind() {
        super.bind()
        
        self.increaseButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.value += 1
                self?.updateUI()
            }).disposed(by: self.disposeBag)
        
        self.decreaseButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.value -= 1
                self?.updateUI()
            }).disposed(by: self.disposeBag)
        
        self.updateUI()
    }
    
    private func updateUI(_ textUpdate: Bool = true) {
        self.decreaseButton.isEnabled = (self.value > self.minValue)
        self.increaseButton.isEnabled = (self.value < self.maxValue)
        if textUpdate {
            self.valueTextField.text = self.value.description
        }
    }
}

extension ServiceCreationRepeatCountViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string) ?? ""
        
        if let parsed = Int(newString) {
            self.value = max(self.minValue, min(self.maxValue, parsed))
        } else {
            let onlyDigits = newString.onlyDigits
            let isOverflow = (newString.digitCompare(self.maxValue.description) == .orderedDescending)
            self.value = Int(onlyDigits) ?? (isOverflow ? self.maxValue: self.minValue)
        }
        
        self.updateUI()
        return false
    }
}

extension String {
    
    func digitCompare(_ target: String) -> ComparisonResult? {
        let onlyDigitsSelf = self.onlyDigits
        let onlyDigitsTarget = target.onlyDigits
        let onlyDigitsSelfCount = onlyDigitsSelf.count
        let onlyDigitsTargetCount = onlyDigitsTarget.count
        guard self.count == onlyDigitsSelfCount,
              target.count == onlyDigitsTargetCount else { return nil }
        guard target != self else { return .orderedSame }
        if onlyDigitsSelfCount < onlyDigitsTargetCount {
            return .orderedAscending
        } else if onlyDigitsSelfCount > onlyDigitsTargetCount {
            return .orderedDescending
        } else {
            for i in 0...onlyDigitsSelfCount {
                let selfItem = Int(onlyDigitsSelf[i])!
                let targetItem = Int(onlyDigitsTarget[i])!
                if selfItem < targetItem {
                    return .orderedAscending
                } else if selfItem > targetItem {
                    return .orderedDescending
                }
            }
            return .orderedSame
        }
    }
    
    var onlyDigits: String {
        self.components(separatedBy: .decimalDigits.inverted).joined()
    }
}
