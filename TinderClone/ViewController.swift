//
//  ViewController.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 16/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var userGender : String? = ""
    var users : [Users] = []
    var myGender : String? = ""
    var matchedUsers : [String] = []
    
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
    @IBOutlet weak var tinderView: TinderCard!{
        didSet{
            tinderView.isUserInteractionEnabled = true
            tinderView.layer.cornerRadius = 10
            tinderView.layer.masksToBounds = true
            tinderView.layer.borderColor = UIColor.lightGray.cgColor
            tinderView.layer.borderWidth = 1
            tinderView.userGender = userGender
            tinderView.currentUserUID = Auth.auth().currentUser?.uid
            tinderView.myGender = myGender
        }
    }
    
    var userImages : [UIImage] = []
    
    var dividor : CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tinderView.getDataFromFirebase()
        saveUserImages()

        
    }

    @IBAction func profileButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileController.currentGender = myGender
        present(profileController, animated: true, completion: nil)
    }
    
    
    @IBAction func cardWasTapped(_ sender: UITapGestureRecognizer) {
        tinderView.wasTapped(gestureRecognizer: sender, superView: view, tinderCard: tinderView)
    }
 
    
    @IBAction func swipeAction(_ sender: UIPanGestureRecognizer) {
        tinderView.wasDragged(gestureRecognizer: sender, superView: view, tinderCard: tinderView)
        if tinderView.presentedAll == true {
            self.matchedUsers = tinderView.usersUID
            
            let alert = UIAlertController(title: "End of the Game", message: "Sorry, no more users :(", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func saveUserImages() {
        guard let userImage = self.tinderView.imageView.image else {return}
        self.userImages.append(userImage)
    }
    
}

