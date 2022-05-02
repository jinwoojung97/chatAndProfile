//
//  ChatViewController+Scroll.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/13.
//

import Foundation
import UIKit

extension ChatViewController{
    
    //아래로 버튼 클릭 시 컬렉션뷰 리로드하여 최상단으로 스크롤
    @IBAction func moveBottomBtn(_ sender: Any) {
        //self.chatCollectionView.reloadData()
        chatCollectionView.setContentOffset(.zero, animated: true)
    }
    
    //스크롤 시 버튼 히든
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if chatCollectionView.contentOffset.y == 0{
            moveBottomBtn.isHidden = true
        }else if chatCollectionView.contentOffset.y > 0{
            moveBottomBtn.isHidden = false
        }
    }
}
