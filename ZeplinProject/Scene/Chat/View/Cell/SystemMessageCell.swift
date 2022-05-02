//
//  SystemMessageCell.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/10.
//

import Foundation
import UIKit

class SystemMessageCell : UICollectionViewCell{
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var messageBGView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
    }
    
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
