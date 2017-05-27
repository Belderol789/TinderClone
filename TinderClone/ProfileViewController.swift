//
//  ProfileViewController.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 27/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var profileImage : String? = ""
    var profileRating : String? = ""
    var currentUserID = Auth.auth().currentUser?.uid
    var currentUser : User? = Auth.auth().currentUser

    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.layer.cornerRadius = imageView.frame.height/2
            imageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToFirebase()

    }
    
    func listenToFirebase() {
        Database.database().reference().child("users").child(currentUserID!).observe(.value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String : Any]
            self.nameLabel.text = dictionary?["name"] as? String
            self.emailLabel.text = dictionary?["email"] as? String
            self.profileImage = dictionary?["profileImageUrl"] as? String
            
            if let profileURL = self.profileImage {
                self.imageView.loadImageUsingCacheWithUrlString(profileURL)
                self.imageView.circlerImage()
            }
        })
    }

    func goToPage(page: String) {
        let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: page) as UIViewController
        present(gameScene, animated: true, completion: nil)
    }
    

  

}
