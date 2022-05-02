//
//  Toast.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/27.
//

import Foundation
import UIKit

public class Toast{
    
    class func show(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)){
        guard let vc = App.visibleViewController() else{ return }
        let toastLabel = UILabel(frame: CGRect(x: vc.view.frame.size.width/6, y:vc.view.frame.size.height/2, width: vc.view.frame.size.width*(2/3), height: 35))
        
        
        toastLabel.backgroundColor = .black.withAlphaComponent(0.64)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        
        vc.view.addSubview(toastLabel)
        
        
        UIView.animate(withDuration: 3.0, delay: 0.8, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

