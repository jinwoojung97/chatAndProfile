//
//  ChatViewController+Text.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/10.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension ChatViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeholderHidden(textView)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderHidden(textView)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderHidden(textView)
    }
    
    
    //placeholder
    func placeholderHidden(_ textView : UITextView){
        if inputMessageView.text.isEmpty{
            placeholderLabel.isHidden = false
        }else {
            placeholderLabel.isHidden = true
        }
    }
    

    
    //글자수 100자 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
     
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        //텍스트 100자 이상 제한
        if  changedText.count >= 101{
            //Toast.show(message: "100자 이상 입력할 수 없습니다.")
            return false
        }
        
        //백스페이스는 입력 허용
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 { return true }
        }
        
        //텍스트 입력 5줄 이상 제한
        let numLines = textView.contentSize.height / textView.font!.lineHeight
        if numLines >= 6{
            Toast.show(message: "5줄 이상 입력할 수 없습니다.")
            return false
        }

        
        return true
    }
    
    func bindText(){
        
//        let inputOb : Observable<String> = inputMessageView.rx.text.orEmpty.asObservable()
//        let inputValidOb = inputOb.map{$0.trimmingCharacters(in: .whitespaces)}.map(textCount)
//
//        inputValidOb.subscribe(onNext: { s in
//            if s{
//                Toast.show(message: "100자 이상 입력할 수 없습니다")
//            }
//            })
//        .disposed(by: disposeBag)
        // 아래랑 같은 코드
        

        inputMessageView.rx.text
            .filter { $0 != nil}
            .map { $0! }
            .map{$0.trimmingCharacters(in: .whitespaces)}
            .map(textCount)
            .subscribe(onNext: { s in
                if s{
                    Toast.show(message: "100자 이상 입력할 수 없습니다")
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func textCount(_ text: String) -> Bool {
        return text.count > 99
    }                                                                                                           
    

    
    

}
