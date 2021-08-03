//
//  UITextField.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/27.
//

import UIKit

extension UITextField {
    
    func shouldChangeCharactersIn(in range: NSRange, replacementString string: String, policy: InputPolicy) -> Bool {
        guard let text = self.text else {
            return true
        }
        if string == "" {
            return true
        }
        
        let nsString = text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string) ?? ""
        
        let isTyped = (range.length == 0)
        let aleadyFull = (text.count >= policy.max)
        let newFull = policy.moreThanMax(newString)
        
        if newFull {
            // 최종 텍스트가 제한을 벗어남
            if aleadyFull {
                // 텍스트 입력 전에 제한을 벗어남
                if isTyped {
                    // 입력 시 더 이상 입력되지 않음
                    return false
                }else{
                    // 텍스트 범위가 선택됨
                    // 추가되는 문자열에서 선택된 범위의 길이만큼만 교체
                    let to = range.length
                    let validText = string.substring(toIndex: to)
                    self.text = nsString?.replacingCharacters(in: range, with: validText)
                    
                    if let position = self.position(from: self.beginningOfDocument, offset: range.location+to) {
                        weak var weak = self
                        DispatchQueue.main.async {
                            weak?.selectedTextRange = self.textRange(from: position, to: position)
                        }
                    }
                    self.sendActions(for: .valueChanged)
                }
            }else{
                // 텍스트 입력 후에 제한을 벗어남
                // 추가되는 문자열에서 제한을 넘지 않는 길이만큼만 추가
                let to = policy.max-text.count
                let validText = string.substring(toIndex: to)
                self.text = nsString?.replacingCharacters(in: range, with: validText)
                
                if let position = self.position(from: self.beginningOfDocument, offset: range.location+to) {
                    weak var weak = self
                    DispatchQueue.main.async {
                        weak?.selectedTextRange = self.textRange(from: position, to: position)
                    }
                }
                self.sendActions(for: .valueChanged)
            }
            return false
        }else{
            return true
        }
    }
}
