//
//  ViewController+IDcheck.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/02.
//

import Foundation
import Alamofire


extension ViewController{
    //MARK: -이메일 체크 -> 회원가입 or 로그인
        

        func checkEmailApi(_ email:String){
            let url = "https://pida83.gabia.io/api/member/\(email)"
            
            AF.request(url, method: .get,  encoding: URLEncoding.queryString ,headers: nil).responseData{ response in
                switch response.result{
                case .success(let data):
                    
                    do {
                        print("회원가입여부 확인 api통신 성공")
                        let chkemail = try JSONDecoder().decode(emailCHK.self, from: data)
                        print(chkemail)
                        
                        if chkemail.is_member{
                            //로그인
                        
                            //내 정보 저장
                            let userInfo = Email.shared
                            userInfo.email = email
                            userInfo.nick = chkemail.mem_info?.name
                            userInfo.gender = chkemail.mem_info?.gender
                            userInfo.profileImage = chkemail.mem_info?.profile_image
                            
                            let profileListUrl = URL(string:"https://pida83.gabia.io/member/list/\(email)")
                            let req = URLRequest(url: profileListUrl!)
                            self.wkWebView!.load(req)
                            self.createChatButton()
                            
                        }else{
                            //회원가입으로 이동
                            let joinView = JoinView()
                            joinView.loginEmail = email
                            joinView.frame = self.view.bounds
                            joinView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
                            self.view.addSubview(joinView)
                        }

                        
                    } catch let error {
                        print("회원가입여부 디코딩 실패")
                        print(String(describing: error))
                    
                    }
          
                case .failure(let error):
                    print("회원가입여부 확인 api통신 실패")
                    print(error)
                    
                }
                
            }
        }
        
}
