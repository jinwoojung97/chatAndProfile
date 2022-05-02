//
//  email.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/02.
//

import Foundation

class Email{
    
    static let shared  = Email()
    
    var email: String?
    var nick: String?
    var gender: String?
    var profileImage: String?
    
    private init(){
        
    }
    
    deinit {
        print("Email 메모리 해제")
    }
}

