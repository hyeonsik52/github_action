//
//  SRPClearTextView.swift
//
//  Created by Suzy Park on 2020/09/18.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift


protocol SRPClearTextViewDelegate: UITextViewDelegate {}

/// Team.iOS Confluence
/// [SRPClearTextView](https://twinny.atlassian.net/wiki/spaces/IOS/pages/1163428049/SRPClearTextView)
/// 문서 참고

final class SRPClearTextView: UITextView {
    
    weak var srpClearTextViewDelegate: SRPClearTextViewDelegate?
    
    let disposeBag = DisposeBag()
    
    let clearButton = UIButton(type: .custom).then {
        $0.isHidden = true
        $0.setImage(UIImage.init(named: "text-delete"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.delegate = self
        self.font = .bold[30]
        self.textColor = .purple4A3C9F
        self.textAlignment = .center
        
        // clearButton 이 textView 에 addSubView 되었으므로
        // textContainerInset 을 설정하여 clearButton 표출 공간을 확보
        // 레이아웃 수정 시 참고!
        self.textContainerInset = UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 36)
        
        self.setupConstraints()
        self.bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        self.addSubview(self.clearButton)
        self.clearButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.width.height.equalTo(36)
        }
    }
    
    func bind() {
        self.clearButton.rx.tap.subscribe(onNext: { _ in
            self.text = nil
            self.clearButton.isHidden = true
        }).disposed(by: self.disposeBag)
    }
}


// MARK: - UITextViewDelegate

extension SRPClearTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.srpClearTextViewDelegate?.textViewDidChange?(textView)
        
        let beforeEndOfDoc = textView.position(from: textView.endOfDocument, offset: -1)
        
        // textView 의 마지막 character 의 range 구하기
        if let lastCharRange = textView.textRange(
            from: textView.endOfDocument,
            to: beforeEndOfDoc ?? textView.beginningOfDocument
        ) {
            let position = textView.caretRect(for: lastCharRange.start).origin
            
            // 'j' 나 'p' 등 너비 차이가 심한 글자들이 있으므로
            // clearButton의 x 좌표를 구할 때
            // 마지막 character 의 range 의 시작 부분 origin.x 에
            // 마지막 character 의 width 를 더하여 구한다.
            let lastString = textView.text[textView.text.count - 1]
            let lastStringWidth = lastString.size(withAttributes: [.font: UIFont.bold[30]]).width
            
            self.clearButton.isHidden = (textView.text.count == 0)

            if !self.clearButton.isHidden {
                self.clearButton.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(position.y)
                    $0.leading.equalToSuperview().offset(position.x + lastStringWidth)
                }
            }
        }
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        return self.srpClearTextViewDelegate?.textView?(
            textView,
            shouldChangeTextIn: range,
            replacementText: text
        ) ?? true
    }
}
