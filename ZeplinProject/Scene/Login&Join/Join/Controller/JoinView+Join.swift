//
//  JoinView+Join.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/28.
//

import Foundation
import UIKit
import Alamofire

extension JoinView{
    
    //입력데이터 검증 -> registApi
    func clickJoin(){
        print("가입완료 버튼 누름")
        guard let cntText = nickTextField.text?.trimmingCharacters(in: .whitespaces).count else {return}
        
        if cntText == 0{
            Toast.show(message: "닉네임을 입력하세요")
        }else if cntText > 10 || cntText < 2 {
            Toast.show(message: "닉네임은 2자 이상 10자 이하여야 합니다")
        }else if indexOfOneAndOnly == nil {
            Toast.show(message: "성별을 선택하세요")
        }else if selectYear == nil || selectMonth == nil || selectDay == nil{
            Toast.show(message: "생년월일을 입력하세요")
        }else{
            let user = JoinInfo(email: loginEmail! ,
                                name: (nickTextField.text?.trimmingCharacters(in: .whitespaces))!,
                                profile_img: selectImage,
                                age: age(),
                                costs: introduceTextView.text,
                                gender: indexOfOneAndOnly == 0 ? "M" : "F")
        

            registApi(user)
        }
    }
    
    //회원가입 api 통신
    func registApi(_ user:JoinInfo){

        let url = "https://pida83.gabia.io/api/member"
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(Data(user.email.utf8), withName: "email")
            multipartFormData.append(Data(user.name.utf8), withName: "name")
            multipartFormData.append(Data(String(user.age).utf8), withName: "age")
            multipartFormData.append(Data(user.gender.utf8), withName: "gender")
            
            if let costs = user.costs{
                multipartFormData.append(Data(costs.utf8), withName: "costs")
            }
            
            if let img = user.profile_img{
                //프로필사진 o
                if let imgData = img.pngData(){
                    multipartFormData.append(imgData,
                                             withName: "profile_img",
                                             fileName: "name.png",
                                             mimeType: "image/jpeg")
                }
            }else{
                //프로필사진 x
                multipartFormData.append(.empty,
                                         withName: "profile_img",
                                         fileName: "name.png",
                                         mimeType: "image/jpeg")
            }
        }, to: url, headers: nil).responseString { (response) in
            switch response.result{
            case .success(let data):
                do{
                    print("회원등록 api통신 성공!!")
                    
                    let registReturn = try JSONDecoder().decode(RegistReturn.self, from: Data(data.utf8))
                    print("registReturn\(registReturn)")
                    
                    if registReturn.inserted_id != nil {
                        print("회원가입 성공~!")
                        Toast.show(message: "회원가입을 축하합니다.")
                        
                        let userInfo = Email.shared
                        userInfo.email = registReturn.email
                        userInfo.nick = registReturn.name
                        userInfo.gender = registReturn.gender
                        userInfo.profileImage = registReturn.profile_url! + registReturn.hash!
                    
                        guard  let vc = App.visibleViewController() as? ViewController else {return}
                        
                        if let profileListUrl = URL(string:"https://pida83.gabia.io/member/list/\(user.email)"){
                            let req = URLRequest(url: profileListUrl)
                            vc.wkWebView!.load(req)
                            vc.createChatButton()
                        }
                        
                        
                        self.removeFromSuperview()
                    }else{
                        print("회원가입 실패~ㅇㅅㅇa")
                    }
                    
                }catch let error{
                    print("회원등록 return data 디코딩 실패")
                    print(String(describing:error))
                }
            case .failure(let error):
                print("회원등록 api통신 실패ㅠㅠ")
                print(error)
            }
        }
    }
}
