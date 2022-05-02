//
//  ViewController.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/01.
//
import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import Toast_Swift
import WebKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import XHQWebViewJavascriptBridge
import NaverThirdPartyLogin

class ViewController: UIViewController {
    
    
    @IBOutlet weak var webContainerView: UIView!
    
    var loading = false
    
    var wkWebView : WKWebView!
    lazy var bridge = WKWebViewJavascriptBridge.bridge(forWebView: wkWebView!)
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()//네이버로그인

    var loginEmail : String?
    
    let chatSB = UIStoryboard(name: "ChatStoryboard", bundle: nil) //메시지스토리보드

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string:"https://pida83.gabia.io/login")
        
        let req = URLRequest(url: url!)
        wkWebView!.load(req)

        registerBridge()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        print("뷰 나타나유")
    }
//MARK: - 로드 뷰
    override func loadView() {
        super.loadView()
        
        wkWebView = WKWebView()
        
        wkWebView?.frame = UIScreen.main.bounds//CGRect(x: webContainerView.frame.origin.x, y: webContainerView.frame.origin.y, width: webContainerView.frame.width, height: webContainerView.frame.height )
        
        //webContainerView = self.wkWebView!
        
        self.view.addSubview(wkWebView!)
        
    }
    
    //MARK: -브릿지
    func registerBridge(){
        bridge.registerHandler(handlerName: "$.callFromWeb", handler: { (data, responseCallback) in
            let jsondata = data as! [String:String]

            print(jsondata)
            switch jsondata["cmd"]! {
            case "loginKakao" :
                self.loginKakao()
            case "loginNaver" :
                self.loginNaver()
            case "open_profile" :
                print("클릭한 프로필 이메일 >> \(jsondata["userInfo"]!)")
                
                //self.loadProfile(jsondata["userInfo"]!)
                if self.loading {return}
                self.loadProfile(jsondata["userInfo"]!)
                
            default:
                print("디폴트")
            }
            
        })
    }
    

//MARK: - 프로필
    
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

