//
//  ChatViewController+CollectionVIew.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/10.
//

import Foundation
import UIKit
import Kingfisher

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messagess.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //시스템메시지
        if messagess[indexPath.row].cmd == "rcvSystemMsg"{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SystemMessageCell", for: indexPath) as? SystemMessageCell{
                
                cell.messageLabel.text = messagess[indexPath.row].msg
                cell.clipsToBounds = true
                cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1) //셀 뒤집기
                return cell
            }
        //사용자메시지
        }else if messagess[indexPath.row].cmd == "rcvChatMsg"{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatMessageCell", for: indexPath) as? ChatMessageCell{
                
                cell.messageLabel.text = messagess[indexPath.row].msg
                cell.nicknameLabel.text = messagess[indexPath.row].from?["chat_name"]
                if let photo = messagess[indexPath.row].from?["mem_photo"]{
                    let urlPhoto = URL(string: photo)
                    cell.profileImage.kf.setImage(with: urlPhoto)
                    
                    
                }
                
                let tapGesture = CustomTapGesture(target: self, action: #selector(self.tapAction(gesture:)))
                tapGesture.num = indexPath.row
                cell.profileImage.addGestureRecognizer(tapGesture)
                cell.clipsToBounds = true
                cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1) //셀 뒤집기
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    
    
    //프로필 터치할 때 프로필 불러오기
    @objc func tapAction(gesture: CustomTapGesture){

        print("프로필 불러오기")
        if loading{return}
        //ProfileAPI.loadProfile(messagess[gesture.num!].from!["mem_id"]!)
        loadProfile(messagess[gesture.num!].from!["mem_id"]!)
    }

    //커스텀 탭
    class CustomTapGesture: UITapGestureRecognizer {
        var num: Int?
    }

    
    
}


