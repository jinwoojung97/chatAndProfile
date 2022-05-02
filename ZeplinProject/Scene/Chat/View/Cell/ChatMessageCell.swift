//
//  ChatMessageCell.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/10.
//

import Foundation
import UIKit

class ChatMessageCell : UICollectionViewCell{
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var messageBGView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
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
        messageBGView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
    }
    
    var isHeightCalculated: Bool = false
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()

        let size = self.contentView.systemLayoutSizeFitting(layoutAttributes.size)

        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        frame.size.width = ceil(size.width)


        layoutAttributes.frame = frame
         return layoutAttributes

    }
}
