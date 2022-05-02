//
//  JoinView+Text.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/27.
//

import Foundation
import UIKit

extension JoinView: UITextFieldDelegate, UITextViewDelegate{
    
    func setTextview(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.nickTextField.delegate = self
        self.introduceTextView.delegate = self
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if  introduceTextView.isFirstResponder && self.frame.origin.y == 0{
                self.frame.origin.y -= (keyboardSize.height - 73)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.frame.origin.y != 0 {
            self.frame.origin.y = 0
        }
    }
    
    //텍스트 변경
    func textViewDidChange(_ textView: UITextView) {
        placeholderHidden(textView)
    
        if let text = introduceTextView.text{
            self.countTextLabel.text = "\(countNewLines(text: text))"
        }
    }
    
    //텍스트 수정 시작
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderHidden(textView)
    }
    
    //텍스트 수정 끝
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderHidden(textView)
    }
    

    
    //글자수 200자 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
     
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
     
        if  countNewLines(text:changedText) >= 201{
            Toast.show(message: "200자 이상 입력할 수 없습니다.")
            return false
        }
        return true
    }

    //개행포함 글자수 반환
    func countNewLines(text:String) -> Int{
        var textCnt = text.count
        let newLinesCnt: Int = text.reduce(0) { $1.isNewline ? $0 + 1 : $0}
        textCnt = textCnt + (19*newLinesCnt) //커서포함 >> 20
        return textCnt
    }
    
    //placeholder
    func placeholderHidden(_ textView : UITextView){
        if introduceTextView.text.isEmpty {
            placeholderLabel.isHidden = false
        }else{
            placeholderLabel.isHidden = true
        }
    }
    
    //화면 터치하면 키보드 내려가게 하는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.endEditing(true)
        viewWithTag(200)?.removeFromSuperview()
        viewWithTag(100)?.removeFromSuperview()
    }
    
}
