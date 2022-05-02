//
//  MessageCell.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/14.
//

import Foundation
import UIKit

class MessageCell: UICollectionViewCell{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileGender: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var receiveTime: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBgView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var moreBtn: UIButton!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageCircle()
    }
    
    //프로필이미지 둥글게
    func imageCircle(){
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
    }
    
    func configureHeight(with height: Int) {
        messageBgView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        }

    
    
    
}
