//
//  ManProfile.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/01.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class MaleProfile : UIViewController{
    
    
    @IBOutlet weak var profileCollectionView: UICollectionView! //컬렉션뷰
    
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var boundaryView: UIView!
    @IBOutlet weak var profileTopView: UIView!
    @IBOutlet weak var profileBottonView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var receiveMessageBtn: UIButton!
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var allViewButton: UIButton!
    @IBOutlet weak var totalLike: UILabel!
    @IBOutlet weak var memberSex: UIImageView!
    @IBOutlet weak var memberAge: UILabel!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var imgDistance: UIImageView!
    @IBOutlet weak var memberLocation: UILabel!
    @IBOutlet weak var bulletArrow: UIImageView!
    @IBOutlet weak var memberLocationCode: UILabel!
    @IBOutlet weak var memberContents: UILabel!
    @IBOutlet weak var viewSexAge: UIView!
    @IBOutlet weak var profileImageBack: UIImageView!
    @IBOutlet weak var countImage: UILabel!
    
    let messageSB = UIStoryboard(name: "Message", bundle: nil) //메시지스토리보드
    
    //받아온 프로필정보
    var profileResult : Result?
    var newProfileResult : Mem_info?
    var profileImgArr = [URL]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        layoutFunc() //레이아웃 함수 적용
        
        jsonDataApply() //json 데이터 적용
        
        profileApply()
        //상단 투명부분 클릭 시 dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.screenDidTap))
        dismissView.addGestureRecognizer(tap)

    }
    
    
    //사연보내기 버튼
    @IBAction func sendMessage(_ sender: Any) {
        
        self.view.isUserInteractionEnabled = false //중복동작 실행방지
        
        guard let sendMessageVC = messageSB.instantiateViewController(withIdentifier: "SendMessageViewController") as? SendMessageViewController else {return}
        sendMessageVC.modalPresentationStyle = .overFullScreen
        sendMessageVC.receiveID = newProfileResult?.email
        self.present(sendMessageVC, animated: true,completion: nil)
        
        self.view.isUserInteractionEnabled = true //중복동작 실행방지
    }
    
    //사연리스트 버튼
    @IBAction func receiveMessage(_ sender: Any) {
    
        self.view.isUserInteractionEnabled = false //중복동작 실행방지
        storyListAPI()
    }
    
    
    //프로필사진 전체보기
    @IBAction func allViewBtn(_ sender: Any) {
        
        self.view.isUserInteractionEnabled = false //중복동작 실행방지
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CustomViewController") as? CustomViewController else {return}
        vc.imageResources = profileImgArr
        vc.indexEndNum = profileImgArr.count
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
        self.view.isUserInteractionEnabled = true //중복동작 실행방지
        
    }
    
    
    //상단 투명부분 클릭 > dismiss
    @objc func screenDidTap(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func profileApply(){
        
        if let info = newProfileResult{
            memberName.text = info.name
            memberAge.text = info.age
            
            if info.gender == "F" || info.gender == "f"{
                memberSex.image = UIImage(named: "icoSexFm")//아이콘 적용
                profileImageBack.image = UIImage(named: "imgProfileLineFm") //프로필사진 배경사진 변경
                memberAge.textColor = UIColor(red: 255/255, green: 84/255, blue: 119/255, alpha: 1.0) //나이 컬러 변경
                viewSexAge.borderColor = UIColor(red: 251/255, green: 194/255, blue: 206/255, alpha: 1.0)  //성별나이 테두리 색
            }
            
            if let contents = info.contents{
                memberContents.text = contents
            }else{
                memberContents.text = ""
            }
            
            if let image = info.profile_image{
                if let url = URL(string: image){
                   
                    profileImage.kf.setImage(with: url)
                }
            }//프로필사진
            
            if info.email == Email.shared.email{
                sendMessageBtn.isHidden = true
            }else{
                receiveMessageBtn.isHidden = true
            }// 나 / 상대방 구별 사연버튼 hidden
        }
        
    }
    //json 데이터 화면 출력
    func jsonDataApply(){
        //회원정보
        if let profileMember = profileResult?.member{
            
            memberName.text = profileMember.chat_name //닉네임
            memberAge.text = profileMember.mem_age //나이
            memberLocation.text = profileMember.loc //지역
            memberLocationCode.text = profileMember.l_code //상세지역
            memberContents.text = profileMember.chat_conts  //소개글
            totalLike.text = profileMember.totLikeCnt //좋아요
            
            //남,여 구분 데이터적용
            if profileMember.mem_sex != "m" {
                memberSex.image = UIImage(named: "icoSexFm")//아이콘 적용
                profileImageBack.image = UIImage(named: "imgProfileLineFm") //프로필사진 배경사진 변경
                memberAge.textColor = UIColor(red: 255/255, green: 84/255, blue: 119/255, alpha: 1.0) //나이 컬러 변경
                viewSexAge.borderColor = UIColor(red: 251/255, green: 194/255, blue: 206/255, alpha: 1.0)  //성별나이 테두리 색
                receiveMessageBtn.isHidden = true
            }else{
                
                sendMessageBtn.isHidden = true
            }
            if let distance = profileMember.distance{
                //나와의 거리 0이상이면 화면 출력
        
                if distance > 0{
                    memberLocation.text = "|"
                    bulletArrow.isHidden = true
                    memberLocationCode.text = "\(distance)km"
                }else{
                    imgDistance.isHidden = true
                }
            }
            
            
        }
        
        //회원 사진정보
        if let profilePhoto = profileResult?.photo{
            
            if let url = URL(string: profilePhoto.defPhoto){
                //let data = try? Data(contentsOf: url)
                //profileImage.image = UIImage(data: data!)
                profileImage.kf.setImage(with: url)
            } //프로필사진

            let photoList = profilePhoto.photoList
            
            for i in 0..<photoList.count{

                let imgUrl = URL(string:photoList[i].url )
               
                profileImgArr.append(imgUrl!)
//                // url -> data
//                if let data = try? Data(contentsOf: imgUrl!){
//                    profileImgArr.append(data)
//                }
            }
            
            countImage.text = "총 \(photoList.count)개" //이미지 갯수 출력
            
            //라벨 색상 부분 적용
            guard let text = self.countImage.text else { return }
            let attributeString = NSMutableAttributedString(string: text)
            attributeString.addAttribute(.foregroundColor, value: UIColor.black, range: (text as NSString).range(of: "총"))
            attributeString.addAttribute(.foregroundColor, value: UIColor.black, range: (text as NSString).range(of: "개"))
            self.countImage.attributedText = attributeString
        }else{
            boundaryView.isHidden = true
            profileBottonView.isHidden = true
        }
        
    }
    
    
    func layoutFunc(){
        //탑 뷰 테두리 둥글게
        profileTopView.layer.cornerRadius = 30
        //왼쪽 위, 오른쪽 위
        profileTopView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //탑 뷰 테두리 둥글게
        bgView.layer.cornerRadius = 30
        //왼쪽 위, 오른쪽 위
        bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //전체보기 버튼 둥글게
        allViewButton.layer.cornerRadius = 10
        
        
        //프로필이미지 동그라미
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.layer.masksToBounds = true
    }
    
//MARK: -api
    

    //사연리스트 불러오기
    func storyListAPI(){
        let url = URL(string: "http://pida83.gabia.io/api/story/page/1")!
        
        let param : Parameters = ["bj_id" : Email.shared.email!]

        AF.request(url, method: .get, parameters: param, encoding: URLEncoding.queryString ,headers: nil).responseData{ response in
            switch response.result{
            case .success(let data):
                
                do {
                    let storyListData = try JSONDecoder().decode(StoryList.self, from: data)
                    
                    //사연보내기 뷰 present
                    guard let receiveMessageVC = self.messageSB.instantiateViewController(withIdentifier: "ReceiveMessageViewController") as? ReceiveMessageViewController else {return}
                    receiveMessageVC.totalPage = storyListData.total_page
                    receiveMessageVC.storyList = storyListData.list
                    receiveMessageVC.modalPresentationStyle = .overFullScreen
                    self.present(receiveMessageVC, animated: true,completion: nil)
                    
                    self.view.isUserInteractionEnabled = true //중복동작 실행방지
                    
                } catch let error {
                    print(String(describing: error))
                    
                    self.view.isUserInteractionEnabled = true //중복동작 실행방지
                }
      
            case .failure(let error):
                print(error)
                
                self.view.isUserInteractionEnabled = true //중복동작 실행방지
            }
            
        }
    }
//MARK: -
    
}

extension UIView {
    //스토리보드상에서 레이아웃 적용
    //지양하는게 좋다 코드로 적용
    //파일로 따로 만들어서 하는게 좋다
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
}
//MARK: -collectionView

    //컬렉션뷰 델리게이트
extension MaleProfile:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCell", for: indexPath) as? ProfileImageCell{
        
            //cell.profileImage.image = UIImage(data: profileImgArr[indexPath.row])
            cell.profileImage.kf.setImage(with: profileImgArr[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    //컬렉션뷰 이미지 클릭시 프로필전체보기 뷰로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.view.isUserInteractionEnabled = false //중복동작 실행방지
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CustomViewController") as? CustomViewController else {return}
        vc.imageResources = profileImgArr
        vc.indexNum = indexPath.row+1 //몇번째 사진인지
        vc.indexEndNum = profileImgArr.count //사진이 몇장있는지
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
        self.view.isUserInteractionEnabled = true //중복동작 실행방지
    }
    
    
    
    
    //컨텍스트 메뉴
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            configureContextMenu(index: indexPath.row)
        }

    @available(iOS 13.0, *)
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in

            let edit = UIAction(title: "자세히", image: UIImage(systemName: "magnifyingglass"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                print("edit button clicked")

                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomViewController") as? CustomViewController else {return}
                vc.imageResources = self.profileImgArr
                vc.indexNum = index+1 //몇번째 사진인지
                vc.indexEndNum = self.profileImgArr.count //사진이 몇장있는지
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
            let delete = UIAction(title: "취소", image: UIImage(systemName: "xmark"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                print("delete button clicked")
                    //add tasks...
            }
            return UIMenu(title: "프로필사진", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
        }
        return context
    }
}
