//
//  ViewController+login.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/22.
//

import Foundation


import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

import NaverThirdPartyLogin
import Alamofire

extension ViewController{


    //MARK: -카카오로그인
    
    func loginKakao(){
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
        //카카오톡 설치o -> 카카오톡 사용하여 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oauthToken
                    self.getKakaoUserInfo()
                }
            }
        }else{
        //카카오톡 설치x -> 카카오 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")

                    //do something
                    _ = oauthToken
                    self.getKakaoUserInfo()
                }
            }
        }
    }
    
    //로그인한 카카오계정에서 회원정보 받아오기
    func getKakaoUserInfo(){
        
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                
                //do something
                _ = user
                print("로그인 카카오 계정 >> \(String(describing: user?.kakaoAccount?.email!))")
                self.loginEmail = user?.kakaoAccount?.email!
                
                //회원가입 여부 check
                self.checkEmailApi(self.loginEmail!)
            }
        }
    }
    
    
    
    
    
    
    
    
}



