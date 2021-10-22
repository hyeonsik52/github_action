//
//  SettingCellView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/21.
//

import UIKit
import Then
import SnapKit

class SettingCellView: UIView {
    
    enum Style {
        /// 타이틀 + 강조된 내용
        case header
        /// 타이틀 + 오른쪽 끝 아이콘
        case disclosure(image: UIImage?)
        /// 타이틀 + 내용 + 버튼
        case editable(buttonTitle: String)
    }
    
    let contentLabel = UILabel().then {
        $0.textColor = .black
    }
    
    let cellButton = UIButton()
    
    let button = UIButton().then {
        $0.titleLabel?.font = .bold[14]
        $0.setTitleColor(.black, for: .normal)
        $0.setBackgroundColor(color: .grayF8F8F8, forState: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 17
    }
    
    init(title: String? = nil, _ style: Style) {
        super.init(frame: .zero)
        
        self.setupConstraints(title, style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(_ title: String?, _ style: Style) {
        
        let padding = 20
        
        if case .disclosure(let image) = style {
            
            let titleLabel = UILabel().then {
                $0.font = .medium[16]
                $0.textColor = .black
                $0.text = title
            }
            self.addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(padding)
                $0.centerY.equalToSuperview()
            }
            
            let imageView = UIImageView(image: image)
            self.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.leading.equalTo(titleLabel.snp.trailing).offset(padding)
                $0.trailing.equalToSuperview().offset(-padding)
                $0.centerY.equalToSuperview()
            }
            
            self.addSubview(self.cellButton)
            self.cellButton.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }else{
            
            let titleLabel = UILabel().then {
                $0.font = .medium[14]
                $0.textColor = .gray9A9A9A
                $0.text = title
            }
            self.addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(24)
                $0.leading.equalToSuperview().offset(padding)
                $0.trailing.equalToSuperview().offset(-padding)
            }
            
            if case .header = style {
                
                self.contentLabel.font = .bold[20]
                self.addSubview(self.contentLabel)
                self.contentLabel.snp.makeConstraints {
                    $0.top.equalTo(titleLabel.snp.bottom).offset(16)
                    $0.leading.equalToSuperview().offset(padding)
                    $0.trailing.equalToSuperview().offset(-padding)
                }
                
            }else if case .editable(let buttonTitle) = style {
                
                self.contentLabel.font = .medium[18]
                self.addSubview(self.contentLabel)
                self.contentLabel.snp.makeConstraints {
                    $0.top.equalTo(titleLabel.snp.bottom).offset(10)
                    $0.leading.equalToSuperview().offset(padding)
                }
                
                self.button.setTitle(buttonTitle, for: .normal)
                self.addSubview(self.button)
                self.button.snp.makeConstraints {
                    $0.leading.equalTo(self.contentLabel.snp.trailing).offset(padding)
                    $0.trailing.equalToSuperview().offset(-padding)
                    $0.bottom.equalToSuperview().offset(-18)
                    $0.height.equalTo(34)
                    $0.width.equalTo(12*buttonTitle.count+22*2)
                }
            }
        }
        
        let bottomLine = UIView().then {
            $0.backgroundColor = .grayF8F8F8
        }
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(padding)
            $0.trailing.equalToSuperview().offset(-padding)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
