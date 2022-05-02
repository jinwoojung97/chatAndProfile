//
//  ChatViewController+Keyboard.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/09.
//

import Foundation
import UIKit

extension ChatViewController{
    
    func setTextview(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(KeyboardWillChangeFrame),name: UIResponder.keyboardWillChangeFrameNotification,object: nil)
        
        self.inputMessageView.delegate = self
    }
    //키보드 형태 변경
    @objc func KeyboardWillChangeFrame(_ notification: Notification){

        if keyboardStatus{
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if let window = UIApplication.shared.keyWindow{
                    let bottomPadding = window.safeAreaInsets.bottom
                    keyboardUpConstraints.constant = 0
                    keyboardUpConstraints.constant = (keyboardSize.height) - bottomPadding
                }else{
                    keyboardUpConstraints.constant = 0
                    keyboardUpConstraints.constant = (keyboardSize.height)
                }
                
            }
        }
        
    }
    
    //키보드 올라올 때
    @objc func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !keyboardStatus{
                if let window = UIApplication.shared.keyWindow{
                    let bottomPadding = window.safeAreaInsets.bottom
                    keyboardUpConstraints.constant = (keyboardSize.height - bottomPadding)
                }else{
                    keyboardUpConstraints.constant = (keyboardSize.height)
                }
                keyboardStatus = true
                
                sendBtn.isHidden = false
                
            }
            
        }
        
    }

    //키보드 내려갈 때
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardUpConstraints.constant = 0
        
        keyboardStatus = false
    }
    
    //컬렉션뷰 터치
    @objc func viewDidTap(){
        if keyboardStatus{
            sendBtn.isHidden = true
            self.view.endEditing(true)
        }
    }
    
    
}
