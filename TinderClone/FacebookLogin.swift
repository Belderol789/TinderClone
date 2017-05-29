//
//  FacebookLogin.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 27/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Firebase

extension OpeningViewController : FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        
        showEmailAddress()
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else {return}
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Something wrong with error user ", error!)
                return
            }
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email, birthday, age_range, location, gender, work"]).start { (completion, result, err) in
                if err != nil {
                    print("Failed to graph request", err!)
                    return
                }
                
                if let dictionary = result as? [String : Any] {
                    let fbUserPhotoUrl = "\((user!.photoURL)!)"
                    guard let fbUserName = user!.displayName,
                        let fbUserUID = user?.providerID,
                        let fbUserGender = dictionary["gender"] as? String,
                        let fbUserEmail = dictionary["email"] as? String else {return}
                    let FBvalues : [String : Any] = ["name" : fbUserName, "lookingFor" : "female", "profileImageUrl" : fbUserPhotoUrl, "email" : fbUserEmail, "age" : "22", "desc" : "Hey there", "uid": fbUserUID, "gender" : fbUserGender]
                    Database.database().reference().child("users").child(fbUserGender).child((user?.uid)!).updateChildValues(FBvalues)
                    
                    UserDefaults.standard.set(fbUserGender, forKey: "fbGender")
                    
                    self.presentViewController(gender: "female")
                }
                
            }
            
            print("Successfully logged in ", user!)
        })
        
    }
    
    func presentViewController(gender: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.userGender = gender
        viewController.myGender = UserDefaults.standard.value(forKey: "fbGender") as! String?
        self.present(viewController, animated: true, completion: nil)
        
    }
    
}
