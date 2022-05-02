//
//  ChatViewController+Animation.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/12.
//

import Foundation
import Lottie
import UIKit


extension ChatViewController{
    
    //좋아요버튼 활성화 애니메이션
    func likeBtnAnimation(){
        let animationView = AnimationView()
        animationView.frame = self.likeBtn.bounds
        animationView.tag = 300
        animationView.animation = Animation.named("ani_live_like_full")
        animationView.contentMode = .scaleAspectFit
        animationView.play(fromProgress: animationView.currentProgress,
                           toProgress: 1,
                           loopMode: .loop,
                           completion: {[weak self](finished) in
                            if finished{
                                self?.view.viewWithTag(300)?.removeFromSuperview()
                            }
                           })
        animationView.isUserInteractionEnabled = false
        
        likeBtn.addSubview(animationView)

    }
    
    //좋아요 애니메이션
    func likeAnimation(){

        let aT : Double = 6 //animation time
        let images = ["an_like_01","an_like_02","an_like_03","an_like_04","an_like_05"]
        
        
        for _ in 0..<7{
            
            var lX = Int.random(in: 0..<61) //last X
            var lY = Int(view.bounds.maxY) - Int.random(in: 0..<81)//last Y
            var lW : Int = 50 //last Width
            var lH : Int = 50 //last Height
            
            let path = Bundle.main.path(forResource: images[Int.random(in: 0..<5)], ofType: "webp")
            let image = UIImage(contentsOfFile: path!)
            let imageView = UIImageView(image: image)
            
            imageView.frame = CGRect(x: lX, y: lY, width: lW, height: lH)
            imageView.alpha = 0
            view.addSubview(imageView)
            
            //애니메이션
            UIView.animateKeyframes(withDuration: aT, delay: drand48(), options: .calculationModePaced, animations: {
                
                //A구간
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: aT*0.15, animations: {
                    lX += Int.random(in: -50..<51)//75
                    lY -= Int.random(in: 100..<151)

                    
                    imageView.frame = CGRect(x: lX, y: lY, width: lW, height: lH)
                    imageView.alpha = 1
                })
                //B구간
                UIView.addKeyframe(withRelativeStartTime: aT*0.15, relativeDuration: aT*0.55, animations: {
                    lX += Int.random(in: -50..<51)//75
                    lY -= Int.random(in: 250..<301)
                    lW += Int.random(in: 20..<31)
                    lH += Int.random(in: 20..<31)
                    
                    
                    imageView.frame = CGRect(x: lX, y: lY, width: lW, height: lH)
                })
                //C구간
                UIView.addKeyframe(withRelativeStartTime: aT*0.7, relativeDuration: aT*0.3, animations: {
                    lX += Int.random(in: -50..<51)//75
                    lY = Int.random(in: 0..<80)
                    lW += 10//20
                    lH += 10//20
                     
                    
                    imageView.frame = CGRect(x: lX, y: lY, width: lW, height: lH)
                    imageView.alpha = 0
                })
            },completion: {_ in
                imageView.removeFromSuperview()
            })
        }
    }
}


