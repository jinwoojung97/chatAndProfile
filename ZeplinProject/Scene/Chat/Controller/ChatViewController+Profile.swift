//
//  ChatViewController+Profile.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/19.
//

import Foundation
import Alamofire
import UIKit

extension ChatViewController{
    //프로필 불러오기
    func loadProfile(_ email:String){
        loading = true
        let profileSB = UIStoryboard(name: "Main", bundle: nil)
        
        let url = "https://pida83.gabia.io/api/member/\(email)"
        
        AF.request(url, method: .get,  encoding: URLEncoding.queryString ,headers: nil).responseData{ response in
            switch response.result{
            case .success(let data):
                
                do {
                    print("클릭한 프로필 정보가져오기 성공")
                    let chkemail = try JSONDecoder().decode(emailCHK.self, from: data)
                    print(chkemail)
                    
                    //뷰 present
                    
                    guard let vc = profileSB.instantiateViewController(withIdentifier: "MaleProfile") as? MaleProfile else {return}
                    vc.newProfileResult = chkemail.mem_info
                    vc.modalPresentationStyle = .overFullScreen
                    App.visibleViewController()?.present(vc, animated: true, completion: nil)
                    self.loading = false
                    
                } catch let error {
                    print("클릭한 프로필 정보 디코딩 실패")
                    print(String(describing: error))
                    self.loading = false
                }
      
            case .failure(let error):
                print("클릭한 프로필 정보가져오기 실패")
                print(error)
                self.loading = false

            }
            
        }
    }
}
