//
//  File.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/12.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class SendMessageViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var countTextLabel: UILabel!//글자 수 라벨
    @IBOutlet weak var sendMessageBtn: UIButton!
    
    var receiveID : String?

    let gradient : CAGradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //상단 뷰 그림자 효과
        messageView.layer.shadowColor = UIColor.black.cgColor
        messageView.layer.shadowOffset = .zero
        messageView.layer.shadowRadius = 10
        messageView.layer.shadowOpacity = 0.9
        
        let dismissViewtap = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewDidTap))
        let messageViewtap = UITapGestureRecognizer(target: self, action: #selector(self.messageViewDidTap))
        dismissView.addGestureRecognizer(dismissViewtap)
        messageView.addGestureRecognizer(messageViewtap)
        
        messageTextView.delegate = self
        messageTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
        //self.removeKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.addKeyboardNotifications()
        self.removeKeyboardNotifications()
    }
    
//MARK: -키보드 or 뷰 dismiss
    
    //디스미스뷰 탭
    @objc func dismissViewDidTap(){
        if keyboardStatus{
            
            self.view.endEditing(true)
        
        }else{
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //메시지뷰 탭
    @objc func messageViewDidTap(){
        self.view.endEditing(true)
    }
    
    //버튼 클릭 > dismiss
    @IBAction func dismissBtn(_ sender: Any) {
        if keyboardStatus{
            self.view.endEditing(true)
        }else{
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
//MARK: -텍스트뷰
    
    //텍스트뷰 클릭 //입력시작
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "10자 이상 300자 이내로 작성해주세요." {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    //텍스트뷰 편집 종료시 텍스트 비어있으면 문구출력
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text!.isEmpty {
            textView.text = "10자 이상 300자 이내로 작성해주세요."
            textView.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
            sendMessageBtn.isEnabled = false
        }
    }
    
    //개행 포함 텍스트 수 반환 /n >> 20
    func selectNewLines(text:String) -> Int{
        var textCnt = text.count
        //개행찾기
        let newLinesCnt: Int = text.reduce(0) { $1.isNewline ? $0 + 1 : $0}
        textCnt = textCnt + (19*newLinesCnt) //커서포함 >> 20
        return textCnt
    }
    
    //글자수 300자 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
     
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
     
        if  selectNewLines(text:changedText) >= 301{
            
            showToast(message: "👮‍♀️300자 이상 입력할 수 없습니다.")

        }
        return selectNewLines(text:changedText) <= 300
    }
    
    
    //텍스트뷰 변경 감지 > 글자수 or 버튼 색 적용
    func textViewDidChange(_ textView: UITextView) {
        //print(textView.text!)
        if let text = messageTextView.text{
            
            self.countTextLabel.text = "(\(selectNewLines(text: text))/300)"
            sendMessageBtn.isEnabled = true
            //sendMessageBtn.backgroundColor = UIColor.red
            gradient.isHidden = false
            setGradient(color1: UIColor(red: 133/255, green: 129/255, blue: 255/255, alpha: 1), color2: UIColor(red: 152/255, green: 107/255, blue: 255/255, alpha: 1))
            
        }
        if messageTextView.text!.isEmpty{
            //sendMessageBtn.backgroundColor = UIColor.gray
            gradient.isHidden = true
            sendMessageBtn.isEnabled = false
        }
    }
    
//MARK: -보내기버튼

    @IBAction func sendMessageBtn(_ sender: Any) {
        self.view.endEditing(true) //키보드내리기
        self.view.isUserInteractionEnabled = false //중복동작 실행방지

        
        //10자 이상 체크
        if selectNewLines(text: messageTextView.text) < 10{
            showToast(message: "👮‍♀️10자 이상 작성해주세요.")
            self.view.isUserInteractionEnabled = true //중복동작 실행방지
            return
        }

        //앞뒤 공백체크
        if messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            //공백 밖에 없을때
            showToast(message: "👮‍♀️공백으로만 된 내용은 전송할 수 없습니다.")
            self.view.isUserInteractionEnabled = true //중복동작 실행방지
            
        }else{

            //보내는 사람 정보
            let params = ["send_mem_gender" : Email.shared.gender!,
                          "send_mem_no" : 123 ,
                          "send_chat_name" : Email.shared.nick!,
                          "send_mem_photo" : Email.shared.profileImage!,
                          "story_conts" : "\(messageTextView.text!)",
                          "bj_id" : receiveID!] as Dictionary

            postAPI(params as Parameters)
        }
        
    }
//MARK: -api
    func postAPI(_ params:Parameters){

        let url = "https://pida83.gabia.io/api/story"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 5
        
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
            
            self.view.isUserInteractionEnabled = true
        }
        
        AF.request(request).responseString { (response) in
                    switch response.result {
                    case .success:
                        print("POST 성공")
                        
                        self.showToast(message: "사연을 성공적으로 보냈습니다.")
                        //토스트메시지 띄운 후 1.5초 뒤 뷰 내리기
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                            self.view.isUserInteractionEnabled = true
                        }
                        
                    case .failure(let error):
                        print(" Alamofire Request Error\nCode:\(error._code), Message: \(error)")
                        self.view.isUserInteractionEnabled = true
                    }
                }
        
    }

//MARK: -키보드 + 뷰 올리고 내리기

    
    var keyboardStatus = false
    
    //노티피케이션을 추가하는 메소드
    func addKeyboardNotifications(){
        //키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        //키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    //노티피케이션을 제거하는 메소드
    func removeKeyboardNotifications(){
        //키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        //키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    

    //키보드가 나타나면 실행할 메소드
    @objc func keyboardWillShow(_ noti: NSNotification){
        //키보드의 높이만큼 화면 올리기
        if keyboardStatus{
            //키보드 올라가있는 상태에서 텍스트필드를 클릭하면 키보드가 또 올라와서 뷰가 두번 올라가는것을 방지
            print("키보드 올라가 있음")
        }else{
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.keyboardHeightConstraint.constant = keyboardHeight
                
                //self.view.frame.origin.y -= (keyboardHeight  )
                print(view.frame.origin.y)
                
                //키보드height - 탭바height 만큼 뷰를 올려주기
                
                keyboardStatus = true
            }
        }
    }
    
    //키보드가 사라지면 실행할 메소드
    @objc func keyboardWillHide(_ noti: NSNotification){
        //키보드의 높이만큼 화면 내리기
        if keyboardStatus{
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                print(keyboardFrame)
//                let keyboardRectangle = keyboardFrame.cgRectValue
//                let keyboardHeight = keyboardRectangle.height
                //self.view.frame.origin.y += (keyboardHeight )
                //self.view.frame.origin.y = 0
                print(view.frame.origin.y)
                self.keyboardHeightConstraint.constant = 0
                keyboardStatus = false
                
            }
        }
    }

    
//MARK: -토스트메시지
    
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/6, y:self.view.frame.size.height-100, width: self.view.frame.size.width*(2/3), height: 35))
        
        
        toastLabel.backgroundColor = UIColor(red: 133/255, green: 129/255, blue: 255/255, alpha: 0.8).withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        
        UIView.animate(withDuration: 3.0, delay: 0.8, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    func setGradient(color1:UIColor,color2:UIColor){
        gradient.frame = sendMessageBtn.bounds
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        sendMessageBtn.layer.insertSublayer(gradient, at: 0) //스택이라서 특정순서로 배경색 끼워넣기
        sendMessageBtn.layer.masksToBounds = true //바깥에서 그릴수 없게 . 정해진 틀 안에서?
        //layer.shouldRasterize = true // 컨텐츠를 한번만 렌더링 하고 재활용 //이거하면 텍스트 화질 저하..
    }
    
}


//MARK: -버튼 색 변경



extension UIView{

    

    
}
