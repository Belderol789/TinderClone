//
//  LoginViewController.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 26/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class OpeningViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.layer.borderColor = UIColor.lightGray.cgColor
            loginButton.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var facebookButton: FBSDKLoginButton! {
        didSet{
            facebookButton.delegate = self
            facebookButton.readPermissions = ["email", "public_profile"]
        }
    }

    @IBOutlet weak var textLabel: UILabel!{
        didSet{
            textLabel.text = "Discover new and interesting people nearby"
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        //checkIfUserExist()
        
        
    }
    
    func checkIfUserExist() {
        
        if(Auth.auth().currentUser) != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
            present(viewController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(loginController, animated: true, completion: nil)
        
    }
    func setupScrollView() {
        self.scrollView.frame = CGRect(x:0, y:100, width:self.view.frame.width, height:self.view.frame.height/2)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        textLabel.textAlignment = .center
        textLabel.text = "Discover new and interesting people nearby"
        textLabel.textColor = .black
        let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "image1")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "image1")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "image1")
        let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgFour.image = UIImage(named: "image1")
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 4, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
        
    }
    
}

extension OpeningViewController :  UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage);
        if Int(currentPage) == 0{
            textLabel.text = "Discover new and interesting people nearby"
        }else if Int(currentPage) == 1{
            textLabel.text = "Swipe Right to anonymously like someone or Swipe left to pass"
        }else if Int(currentPage) == 2{
            textLabel.text = "If they also Swipe Right, it's a Match!"
        }else{
            textLabel.text = "Only people you've matched with can message you"
            
        }
    }
    
    
    
}



