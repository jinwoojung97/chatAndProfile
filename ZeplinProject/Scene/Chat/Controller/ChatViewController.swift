//
//  ChatViewController.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/09.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class ChatViewController:UIViewController{
    @IBOutlet weak var backImageView: UIView!
    @IBOutlet weak var inputTextView: UIView!
    @IBOutlet weak var willUpView: UIView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var colView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var inputMessageView: UITextView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var moveBottomBtn: UIButton!
    @IBOutlet weak var keyboardUpConstraints: NSLayoutConstraint!
    @IBOutlet weak var chatCollectionView: UICollectionView!
    
    var imageView = UIImageView()
    
    var loading = false
    var keyboardStatus = false
    
    var messagess = [Chat]()
    let socketManager = SocketIOManager.shared
    
    var blurViewGradient: CAGradientLayer!
    let blurView = UIView()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiallize()
        
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        chatCollectionView.register(UINib(nibName: "ChatMessageCell", bundle: nil), forCellWithReuseIdentifier: "ChatMessageCell")
        chatCollectionView.register(UINib(nibName: "SystemMessageCell", bundle: nil), forCellWithReuseIdentifier: "SystemMessageCell")

        chatCollectionView.transform = CGAffineTransform(scaleX: 1, y: -1)//컬렉션뷰 뒤집기
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.view.addGestureRecognizer(viewTap)
        
        
        
        
        
//        let flowLayout = UICollectionViewFlowLayout()
//
//        let width = self.view.frame.width
//        let height = self.view.frame.height
//        flowLayout.estimatedItemSize = CGSize(width: width, height: height)
//
//        chatCollectionView.collectionViewLayout = flowLayout
        

    }
    
    func initiallize(){
        layout()
        setTextview()
        bindMsg()
        bindText()
    }


    //소켓 메시지에 따른 처리
    func bindMsg(){
        socketManager.socket.on("message") { (dataArray, socketAck) -> Void in
        
            
            var chat = Chat()
            
            let data = dataArray[0] as! NSDictionary
            
            chat.cmd = data["cmd"] as? String
            chat.msg = data["msg"] as? String
            chat.from = data["from"] as? [String:String]
            
            switch chat.cmd{
            case "rcvChatMsg", "rcvSystemMsg":
                
                self.messagess.insert(chat, at: 0)
                print(chat)
                
                if self.chatCollectionView.contentOffset.y <= 0{
                    self.chatCollectionView.reloadData()
                }
                
            case "rcvPlayLikeAni":
                
                self.likeAnimation()

            case "rcvAlertMsg":
                
                self.alert(chat.msg!)
                
            case "rcvToastMsg":
                
                Toast.show(message: chat.msg!)
                
            case "rcvRoomOut":
                self.socketManager.closeConnection()
                self.dismiss(animated: true){
                    Toast.show(message: "방장에 의해 강퇴되었습니다.")
                }
                self.messagess.removeAll()
                
            default:
                return
            }
        }
        
    }
    
    //레이아웃
    func layout(){
        applyBgImage()
        
        sendBtn.isHidden = true
        
        inputMessageView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        inputMessageView.textContainer.maximumNumberOfLines = 5
        
        blurView.frame = CGRect(x: 0, y: 0, width: colView.frame.width, height: colView.bounds.height)

        blur()
    }
    
    
    //채팅 최상단 블러처리
    func blur(){
        blurViewGradient = CAGradientLayer()
        blurViewGradient.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: view .bounds.height))// colView.bounds
        

        blurViewGradient.colors = [UIColor.clear.cgColor,UIColor.red.cgColor]
        blurViewGradient.locations = [0.0, 0.1]
        colView.layer.mask = blurViewGradient
    }
    
    
    //배경이미지 설정
    func applyBgImage(){
        let image = UIImage(named:"pc004418845")
        imageView = UIImageView(image: image!)
        imageView.frame = UIScreen.main.bounds
        self.backImageView.addSubview(imageView)
    }
    
    //나가기 버튼
    @IBAction func exitBtn(_ sender: Any) {
        //chatCollectionView.reloadData()
        
        socketManager.closeConnection()
        dismiss(animated: true, completion: nil)
        
    }
    

    
    //전송버튼
    @IBAction func sendBtn(_ sender: Any) {
        
        let text = inputMessageView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if text.isEmpty {
            
            Toast.show(message: "공백으로만 이루어진 내용은 전송할 수 없습니다.", font: UIFont.systemFont(ofSize: 12.0) )
        }else{
            SocketIOManager.shared.sendChatMsg(text)
            
            inputMessageView.text = nil
        }
        
    }
    
    //좋아요 버튼
    @IBAction func likeBtn(_ sender: Any) {
        socketManager.sendLike()
        self.view.viewWithTag(300)?.removeFromSuperview()
        
        self.likeBtn.isEnabled = false
        let offLikeBtn = UIImage(named: "btnBtHeartOff")
        self.likeBtn.setImage(offLikeBtn, for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+60) {
            self.likeBtn.isEnabled = true
            let onLikeBtn = UIImage(named: "btnBtHeartOn")
            self.likeBtn.setImage(onLikeBtn, for: .normal)
            self.likeBtnAnimation()
        }
    }
    
    //alert 메시지
    func alert(_ msg:String){
        let alertMsg = UIAlertController(title: "메시지", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            print("ok버튼 누름")
        }
        
        alertMsg.addAction(okAction)
        present(alertMsg, animated: false, completion: nil)
    }
    
    //랜덤 배경화면 변경
    @IBAction func changeBG(_ sender: Any) {
        Observable.just("600/800")
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .map { "https://picsum.photos/\($0)/?random"}
            .map { URL(string: $0)}
            .filter{ $0 != nil}
            .map { $0!}
            .map { try Data(contentsOf: $0) }//Data
            .map { UIImage(data: $0) } // UIImage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { image in
                self.imageView.image = image
                
            })
            .disposed(by: disposeBag)
    }
    

}
