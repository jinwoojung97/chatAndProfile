//
//  LoginModel.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/28.
//

import Foundation

//MARK: - 이메일체크

struct emailCHK: Codable {
    var mem_info: Mem_info?
    var is_member : Bool
    var code : Int
    var msg: String
    var redirect_url : String?
}

struct Mem_info : Codable{
    var name: String
    var email: String
    var profile_image : String?
    var contents: String?
    var gender : String
    var age : String
}
