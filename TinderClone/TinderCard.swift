//
//  TinderCard.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 28/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class TinderCard: UIView {
    
    var imageUrl : String? = ""
    var userGender : String? = ""
    var currentUserUID : String? = ""
    var usersUID : [String] = []
    var myGender : String? = ""
    var tinderUsers : [Users] = []
    var index : Int = 0
    var presentedAll : Bool = false
    
    @IBOutlet var cardView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!{
        didSet{
            aboutLabel.alpha = 0
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("TinderCard", owner: self, options: nil)
        self.addSubview(self.cardView)
    }
    
    func wasTapped(gestureRecognizer: UITapGestureRecognizer, superView: UIView, tinderCard: TinderCard) {
        aboutLabel.alpha = 1
    }
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer, superView:UIView, tinderCard: TinderCard) {
        let translation = gestureRecognizer.translation(in: superView)
        
        let tinderCard = gestureRecognizer.view!
        
        tinderCard.center = CGPoint(x: (self.superview?.bounds.width)!/2 + translation.x, y: (self.superview?.bounds.height)!/2 + translation.y)
        
        let xFromCenter = tinderCard.center.x - (self.superview?.bounds.width)!/2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter/200)
        
        let scale = min(abs(100/xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        tinderCard.transform = stretchAndRotation
        
        if gestureRecognizer.state == .ended {
            if tinderCard.center.x < 100 {
                checkNumberOfCards()
                
                
            } else if tinderCard.center.x > (self.superview?.bounds.width)! - 100 {
                
                if index < tinderUsers.count {
                    self.usersUID.append(tinderUsers[index].uid!)
                    self.updateFirebase()
                }
                checkNumberOfCards()
 
            }
            rotation = CGAffineTransform(rotationAngle: 0)
            stretchAndRotation
                = rotation.scaledBy(x: 1, y: 1)
            tinderCard.center = CGPoint(x: (self.superview?.bounds.width)!/2, y: (self.superview?.bounds.height)!/2)
            
        }
        
    }

    func checkNumberOfCards() {
        if index < tinderUsers.count {
            updateData(index: index)
            index += 1
        } else {
            presentedAll = true
            
        }
    }
    
    func getDataFromFirebase() {
        Database.database().reference().child("users").child(userGender!).observe(.childAdded, with: { (snapshot) in
            
            print(snapshot)
            
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let user = Users(dictionary: dictionary)
            
            self.tinderUsers.append(user)
            
            self.updateData(index: self.tinderUsers.startIndex)
            
        })
        
        
    }
    
    func updateData(index : Int) {
        self.ageLabel.text = tinderUsers[index].age
        self.nameLabel.text = tinderUsers[index].name
        self.aboutLabel.text = tinderUsers[index].desc
        
        if let profileURL = tinderUsers[index].imageUrl {
            self.imageView.loadImageUsingCacheWithUrlString(profileURL)
        }
        
    }
    
    func updateFirebase() {
        
        let matchValues = ["matched": self.usersUID]
        
        Database.database().reference().child("users").child(myGender!).child(currentUserUID!).updateChildValues(matchValues)
    }
    
    
}
