//
//  ViewController+Naver.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/03.
//

import Foundation
import NaverThirdPartyLogin
import Alamofire

extension ViewController: NaverThirdPartyLoginConnectionDelegate{
    //MARK: -네이버로그인
    
    func loginNaver(){
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
    }
    
    //로그인한 네이버계정에서 회원정보 가져오기
    private func getNaverUserInfo() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
          return
        }
        
        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
          guard let result = response.value as? [String: Any] else { return }
          guard let object = result["response"] as? [String: Any] else { return }
//          guard let name = object["name"] as? String else { return }
          guard let email = object["email"] as? String else { return }
//          guard let nickname = object["nickname"] as? String else { return }
          
          print("로그인 네이버 계정 >> \(email)")
          self.loginEmail = email
            
        //회원가입 여부 check
          self.checkEmailApi(self.loginEmail!)
        }
    }
    //로그인에 성공했을 경우 호출되는 함수
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("[Success] : Success Naver Login")
        getNaverUserInfo()
    }
    //접근토큰을 갱신할 때 호출되는 함수
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    //토큰삭제를 하면 호출되는함수 //로그아웃에서 사용
    func oauth20ConnectionDidFinishDeleteToken() {
        loginInstance?.requestDeleteToken()
    }
    //네아로의 모든 에러에 호출되는함수
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }
}
