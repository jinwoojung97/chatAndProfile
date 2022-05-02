//
//  ReceiveMessage.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/12.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class ReceiveMessageViewController: UIViewController{
    
    
    
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var storyCollectionView: UICollectionView!
    
    var alamoFireManager : Session?
    var storyList : [List]? //받아올 사연리스트
    var totalPage : Int? //사연 총 페이지 개수
    var willCurrentPage = 2 //초기 페이지는 로드돼있고 2페이지부터 페이징
    var isPaging = false //현재 페이징 중인지


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageView.layer.shadowColor = UIColor.black.cgColor
        messageView.layer.shadowOffset = .zero
        messageView.layer.shadowRadius = 10
        messageView.layer.shadowOpacity = 0.9
        
        
        let dismissViewtap = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewDidTap))
        dismissView.addGestureRecognizer(dismissViewtap)
        
        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
        storyCollectionView.register(UINib(nibName: "MessageCell", bundle: nil), forCellWithReuseIdentifier: "MessageCell")
        
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        storyCollectionView.collectionViewLayout = layout
        
        
        //사연비어있을시 화면출력
        if storyList!.isEmpty{
            storyCollectionView.isHidden = true
        }
        
    }

//MARK: -뷰 dismiss
    @IBAction func dismissBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //디스미스뷰 탭
    @objc func dismissViewDidTap(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    

    
    
    //사연 경과시간 계산
    func passTime(indexPath: Int) -> String{
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.locale = Locale.current
        format.timeZone = TimeZone(abbreviation: "UTC")
        
        let sendTime = format.date(from: storyList![indexPath].ins_date)!
        let nowTime = Date()
        
        let calendar = Calendar.current
        let dateGap = calendar.dateComponents([.day, .hour, .minute], from: sendTime, to: nowTime)
        
        if dateGap.day! > 0{
            return "오래전"
        }else if dateGap.hour! > 0 {
            return "\(dateGap.hour!)시간전"
        }else if dateGap.minute! > 0{
            return "\(dateGap.minute!)분전"
        }
        return "방금"
    }
    
//MARK: - api(페이징)
    
    
    func paging(){
        
        print("불러올 페이지 >>\(willCurrentPage) ")
        isPaging = true

        let url = URL(string: "http://pida83.gabia.io/api/story/page/\(willCurrentPage)")!
        
        let param : Parameters = ["bj_id" : Email.shared.email!]
     
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 5
//        configuration.timeoutIntervalForResource = 5  //타임아웃 5초
//        alamoFireManager = AF.session(configuration: configuration)

        AF.request(url, method: .get, parameters: param, encoding: URLEncoding.queryString ,headers: nil).responseData{ response in
            switch response.result{
            case .success(let data):
                
                do {
                    let newStoryListData = try JSONDecoder().decode(StoryList.self, from: data)
                    
                    self.storyList?.append(contentsOf: newStoryListData.list)
                    self.storyCollectionView.reloadData()
                    print("사연개수")
                    print(self.storyList!.count)
                    
                    
                    self.willCurrentPage += 1
                    self.isPaging = false //끝나면 페이징중이 아니라고 지정
                    self.view.isUserInteractionEnabled = true //중복동작 실행방지
                    
                    
                } catch let error {
                    print(String(describing: error))
                    self.isPaging = false //오류가나도 페이징중이 아님
                    self.view.isUserInteractionEnabled = true //중복동작 실행방지
                }
      
            case .failure(let error):
                print(error)
                self.isPaging = false //오류가나도 페이징중이 아님
                self.view.isUserInteractionEnabled = true //중복동작 실행방지
            }
            
        }
        
    }
    
    
    
    
}
//MARK:- 컬렉션뷰


//컬렉션 뷰
extension ReceiveMessageViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storyList!.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as? MessageCell{
            if let storyList = storyList{
                cell.messageLabel.text = storyList[indexPath.row].story_conts // 사연
                cell.profileName.text = storyList[indexPath.row].send_chat_name // 닉네임
                
                if storyList[indexPath.row].send_mem_gender == "F"{
                    cell.profileGender.image = UIImage(named: "badgeSexFm")
                }  // 성별
                
                if storyList[indexPath.row].read_yn == "n" {
                    cell.messageBgView.backgroundColor = UIColor(red: 241/255, green: 238/255, blue: 255/255, alpha: 1)
                } //읽음 처리
                
                cell.receiveTime.text = passTime(indexPath: indexPath.row) //사연 경과 시간

                cell.moreBtn.tag = indexPath.row //더보기버튼 이벤트
                cell.moreBtn.addTarget(self, action: #selector(self.moreBtnTap(sender:)), for: .touchUpInside)
                
                //프로필 이미지
                if let memPhoto = storyList[indexPath.row].send_mem_photo{
                    if let urlPhoto = URL(string: memPhoto){
                        
                        cell.profileImage.kf.setImage(with: urlPhoto)
                    }
                }else{
                    cell.profileImage.image = UIImage(named: "imgDefaultS")
                }
                
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    
    
    //더보기 버튼 > 액션시트 > 삭제 or 취소
    @objc func moreBtnTap(sender : UIButton) {

        let alert: UIAlertController
        alert = UIAlertController(title: "더보기", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
        var cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction) in
            print("취소 액션시트 선택함")
        })
                
        var deleteAction: UIAlertAction
        deleteAction = UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: { (action: UIAlertAction) in
            print("삭제 액션시트 선택함")
            
            self.storyList?.remove(at: sender.tag)
            self.storyCollectionView.reloadData()
        })

   
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
                
                
        self.present(alert,animated: true){
            print("액션시트 보여짐")
        }
    }
    
    //페이징 스크롤
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        //스크롤이 테이블 뷰 offset의 끝에 가게 되면 다음페이지 호출
        if offsetY > (contentHeight - height) {
            print("offsety\(offsetY)")
            print("cotentH\(contentHeight)")
            print("hei\(height)")
            //self.storyCollectionView. = infiniteSpinner() //페이지 더보기
            let pageCnt = totalPage!%5 == 0 ? (totalPage!/5) : ((totalPage!/5)+1)
            
            if (isPaging == false) && (willCurrentPage <= pageCnt){
                self.view.isUserInteractionEnabled = false //중복동작 실행방지
                
                paging()

            }else{
                print("페이징중이거나 더 부를 페이지가 없어서 안돼")
            }
        }
    }
    


}
