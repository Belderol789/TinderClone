//
//  SwipeGesture.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 27/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import Foundation
import UIKit

class SwipeGestureHelper {
    
    static func handleSwipe(_ sender: UIPanGestureRecognizer, superView: UIView!, likeImageView: UIImageView, nopeImageView: UIImageView, profileView: UIImageView, imageArray: [UIImage]) -> [UIImage]? {
        
        let divider = (superView.frame.width / 2) / 0.61 //0.61 is radian value of 35 degree
        let card = sender.view!
        let point = sender.translation(in: superView)
        let xFromCenter = card.center.x - superView.center.x
        let scale = min(abs(100 / xFromCenter) , 1) //  min  will return the smallest number after compairing , abs will take the positive value only
        
        card.center = CGPoint(x: superView.center.x + point.x , y: superView.center.y + point.y)
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divider).scaledBy(x: scale, y: scale) // for scaling anything less than 1 will make the object smaller
        
        if xFromCenter > 0 {
            likeImageView.image = #imageLiteral(resourceName: "like")
            likeImageView.alpha = abs(xFromCenter) / superView.center.x
        }else{
            nopeImageView.image = #imageLiteral(resourceName: "nope")
            nopeImageView.alpha = abs(xFromCenter) / superView.center.x
        }
        //thumbImageView.alpha = abs(xFromCenter) / view.center.x
        if sender.state == .ended{
            // setting a mergins to 75 to animate
            if card.center.x < 75 {
                // the view should move to the left
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                    //profileView.alpha = 0
                })
                
                
                return hiddenResetCard(cardView: card, likeView: likeImageView, nopeView: nopeImageView, superView: superView, profileView: profileView, imageArray: imageArray)
                
                
            }else if card.center.x > (superView.frame.width - 75){
                // the view should move to the right
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                    //profileView.alpha = 0
                })
                
                return hiddenResetCard(cardView: card, likeView: likeImageView, nopeView: nopeImageView, superView: superView, profileView: profileView, imageArray: imageArray)
                
            }
            resetCard(cardView: card, superView: superView, likeImageView: likeImageView, nopeImageView: nopeImageView)
            
        }
        
        return imageArray
    }
    
    static func resetCard(cardView: UIView, superView: UIView!, likeImageView: UIImageView, nopeImageView: UIImageView){
        UIView.animate(withDuration: 0.2) {
            cardView.center = superView.center
            likeImageView.alpha = 0
            nopeImageView.alpha = 0
            cardView.alpha = 1
            cardView.transform = .identity
        }
    }
    
    static func hiddenResetCard(cardView: UIView, likeView: UIImageView, nopeView: UIImageView, superView: UIView!, profileView: UIImageView, imageArray: [UIImage]) -> [UIImage] {
        
        var picArray = imageArray
        
        cardView.center = superView.center
        likeView.alpha = 0
        nopeView.alpha = 0
        profileView.alpha = 0
        cardView.transform = .identity
        
        let when = DispatchTime.now() 
        superView.sendSubview(toBack: cardView)
        
        if picArray.count != 1 {
            picArray.remove(at: 0)
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            cardView.alpha = 1
            profileView.alpha = 1
            //profileView.image = picArray[0]
            
            if picArray.count > 1 {
                profileView.image = picArray[1]
            } else {
                cardView.removeFromSuperview()
                cardView.isHidden = true
            }
            
        }
        
        
        return picArray
    }
    
}
