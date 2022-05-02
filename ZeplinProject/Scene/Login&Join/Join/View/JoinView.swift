//
//  JoinView.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/26.
//

import Foundation
import UIKit
import Alamofire

class JoinView : XibView{
    @IBOutlet weak var pickImageView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet var genderBtns: [UIButton]!
    @IBOutlet weak var nickTextField: UITextField!
    @IBOutlet weak var introduceTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var countTextLabel: UILabel!
    @IBOutlet weak var birthdayView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    
    var indexOfOneAndOnly : Int? //성별버튼
    let joinBtnGradient: CAGradientLayer = CAGradientLayer()
    let photo = UIImagePickerController()
    var yearArray = Array<Int>(1900...2021).sorted(by: >)
    var selectYear: String?
    var monthArray = Array<Int>(1...12)
    var selectMonth: String?
    var dayArray = Array<Int>(1...31)
    var selectDay: String?
    var joinInfo : JoinInfo?
    var loginEmail : String?
    var selectImage : UIImage?

    override func layoutSubviews() {
        super.layoutSubviews()
        if isInitialized{
            initialize()
            isInitialized = false
        }
        
    }
    
    func initialize(){
        setjoinBtnLayout()
        pickImage()
        setTextview()
        pickBirth()
    }
    
    //가입버튼 그라데이션
    func setjoinBtnLayout(){
        joinBtnGradient.frame = bounds
        joinBtnGradient.colors = [
            UIColor(red: 132/255, green: 129/255, blue: 255/255, alpha: 1).cgColor,
            UIColor(red: 152/255, green: 107/255, blue: 255/255, alpha: 1).cgColor
        ]
        joinBtnGradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        joinBtnGradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        joinBtnGradient.locations = [0.0, 1.0]
        joinBtn.layer.masksToBounds = true
        joinBtn.layer.insertSublayer(joinBtnGradient, at: 1)
    }
    
    //성별버튼 클릭
    @IBAction func clickgenderBtn(_ sender: UIButton) {
        if indexOfOneAndOnly != nil{
            if sender.isSelected{
                //이미 선택된 버튼을 누른 경우
                sender.isSelected = false
                indexOfOneAndOnly = nil  //선택을 풀어주고 인덱스번호를 지운다
            }else{
                //선택된 버튼말고 다른 버튼을 누른경우
                for index in genderBtns.indices{
                    genderBtns[index].isSelected = false
                } //모든 선택을 풀어주고
                sender.isSelected = true
                indexOfOneAndOnly = genderBtns.firstIndex(of: sender) //새로 선택된 버튼의 인덱스번호를 담는다.
            }
        }else{
            //아무것도 선택되지 않은 상태
            sender.isSelected = true
            indexOfOneAndOnly = genderBtns.firstIndex(of: sender) //선택된 버튼을 선택하고 인덱스 번호를 담는다.
        }

        setGenderBtnLayout()
    }
    
    //성별버튼 클릭 배경
    func setGenderBtnLayout(){
        for button in genderBtns{
            if button.isSelected{
                button.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 240/255, alpha: 1)
                button.borderColor = UIColor(red: 255/255, green: 152/255, blue: 193/255, alpha: 1)
            }else{
                button.backgroundColor = .white
                button.borderColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
            }
        }
    }
    
    //뒤로가기버튼 클릭
    @IBAction func backBtn(_ sender: Any) {
        guard let vc = App.visibleViewController() else{ return }
        let alert = UIAlertController(title: "알림", message: "회원가입을 취소하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
       
        let yesAction = UIAlertAction(title: "예", style: .default) { (action)  in self.removeFromSuperview() }
        let noAction = UIAlertAction(title: "아니오", style: .default) { (action) in vc.dismiss(animated: true, completion: nil)}
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        vc.present(alert, animated: true)
    }
    
    //가입버튼 클릭
    @IBAction func joinBtn(_ sender: Any) {
        clickJoin()
    }
    
    
}
