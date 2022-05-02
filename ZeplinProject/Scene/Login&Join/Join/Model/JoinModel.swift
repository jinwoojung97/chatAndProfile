//
//  JoinModel.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/28.
//

import Foundation
import UIKit
//MARK: -회원가입 정보
struct JoinInfo {
    var email : String
    var name : String
    var profile_img : UIImage?
    var age : Int
    var costs : String?
    var gender : String
}
//MARK: -회원가입 리턴
struct RegistReturn : Codable{
    var profile_url : String?
    var redirect_url: String
    var inserted_id : Int?
    var msg : String
    var email : String
    var name : String
    var hash : String?
    var code : Int
    var age : String
    var gender : String
}
