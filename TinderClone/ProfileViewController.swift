//
//  ProfileViewController.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 27/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    
    
    var profileImage : String? = ""
    var profileRating : String? = ""
    var currentGender : String? = ""
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
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToFirebase()
        animateBackground()
        
    }
    
    func listenToFirebase() {
        Database.database().reference().child("users").child(currentGender!).child(currentUserID!).observe(.value, with: { (snapshot) in
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
    
    func animateBackground() {
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    
    func moveToNextPage() {
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 4
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
            self.pageControl.currentPage = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
        let currentPage = self.pageControl.currentPage
        if Int(currentPage) == 0{
            textLabel.text = "Find your match today!"
        }else if Int(currentPage) == 1{
            textLabel.text = "Get Tinder Plus and have Unlimited Matching!"
        }else if Int(currentPage) == 2{
            textLabel.text = "The one is just a swipe away!"
        }else{
            textLabel.text = "Relationships have never been this fun!"
        }
        
        self.pageControl.currentPage += 1
    }
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let editController = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editController.userName = self.nameLabel.text
        editController.userEmail = self.emailLabel.text
        editController.gender = currentGender
        present(editController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            guard let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")else{return}
            dismiss(animated: true, completion: nil)
            present(loginController, animated: true, completion: nil)
            
            func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
                print("User logged out")
            }

        } catch let logoutError {
            print(logoutError)
        }
        
    }
}
