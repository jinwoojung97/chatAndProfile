//
//  XibView.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/26.
//

import Foundation
import UIKit

class XibView: UIView {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        let className = String(describing: type(of: self))
//        let nib = UINib(nibName: className, bundle: Bundle.main)
//
//        guard let xibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
//        xibView.frame = self.bounds
//        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.addSubview(xibView)
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    var isInitialized = true
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadXib()
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadXib()
    }
    private func loadXib() {
        let identifier = String(describing: type(of: self))
        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
            
        guard let customView = nibs?.first as? UIView else { return }
        customView.frame = self.bounds
        self.addSubview(customView)
    }
}
