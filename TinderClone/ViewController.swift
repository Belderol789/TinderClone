//
//  ViewController.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 16/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var nopeImageView: UIImageView!{
        didSet{
            nopeImageView.alpha = 0
        }
    }
    @IBOutlet weak var likeImageView: UIImageView!{
        didSet{
            likeImageView.alpha = 0
        }
    }
    @IBOutlet weak var tinderView: UIView!{
        didSet{
            tinderView.isUserInteractionEnabled = true
            tinderView.layer.cornerRadius = 10
            tinderView.layer.masksToBounds = true
        }
    }
    
    var tinderViewArray : [UIView] = []
    
    var dividor : CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        dividor = (view.frame.width/2)/0.61
        addCard()
 
        
    }
    
    
    @IBAction func swipeAction(_ sender: UIPanGestureRecognizer) {
        for each in tinderViewArray {
            each.addGestureRecognizer(sender)
        }
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        let scale = min(abs(100/xFromCenter), 1)
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/dividor).scaledBy(x: scale, y: scale)
        
        if xFromCenter > 0 {
            likeImageView.image = #imageLiteral(resourceName: "like")
            likeImageView.alpha = abs(xFromCenter)/view.center.x
            
        } else {
            nopeImageView.image = #imageLiteral(resourceName: "nope")
            nopeImageView.alpha = abs(xFromCenter)/view.center.x
        }
        
        if sender.state == .ended {
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                    self.addCard()
                  
                })
                
                return
            } else if card.center.x > (view.frame.width - 75) {
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                    self.addCard()
                    
                })
                return
                
            }
            
            centerCard()
        }
        
    }
    
   
    func centerCard() {
        UIView.animate(withDuration: 0.2) {
            self.tinderView.center = self.view.center
            self.nopeImageView.alpha = 0
            self.likeImageView.alpha = 0
            self.tinderView.alpha = 1
            self.tinderView.transform = .identity
        }
    }
    
    func addCard() {
        
        self.tinderView.center = self.view.center
        self.tinderView.transform = .identity
        for _ in 0...3 {
            self.tinderViewArray.append(self.tinderView)
            self.view.addSubview(self.tinderView)
        }
    }


}

