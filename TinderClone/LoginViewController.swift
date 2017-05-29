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


class LoginViewController: UIViewController {
    
    var myGender : String? = "female"
    var uid : String? = ""

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
        {
        didSet{
            button.addTarget(self, action: #selector(loginOrSignup), for: .touchUpInside)
        }
    }
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emailLogin: UITextField!{
        didSet{
            emailLogin.layer.borderColor = UIColor.lightGray.cgColor
            emailLogin.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var passwordLogin: UITextField!{
        didSet{
            passwordLogin.layer.borderColor = UIColor.lightGray.cgColor
            passwordLogin.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var lookingForLabel: UILabel!{
        didSet{
            lookingForLabel.alpha = 0
        }
    }
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.alpha = 0
            nameTextField.isUserInteractionEnabled = false
            nameTextField.layer.borderColor = UIColor.lightGray.cgColor
            nameTextField.layer.borderWidth = 2
        }
    }
    
    @IBOutlet weak var genderSwitch: UISwitch!{
        didSet{
            genderSwitch.alpha = 0
            genderSwitch.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var ageTextField: UITextField!{
        didSet{
            ageTextField.alpha = 0
            ageTextField.isUserInteractionEnabled = false
            ageTextField.layer.borderColor = UIColor.lightGray.cgColor
            ageTextField.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var genderLabel: UILabel!{
        didSet{
            genderLabel.alpha = 0
            if myGender == "female" {
                genderLabel.text = "male"
            } else {
                genderLabel.text = "female"
            }
        }
    }
    @IBAction func segmentedControlTapped(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            genderLabel.alpha = 0
            genderSwitch.alpha = 0
            lookingForLabel.alpha = 0
            genderSwitch.isUserInteractionEnabled = false
            nameTextField.alpha = 0
            nameTextField.isUserInteractionEnabled = false
            ageTextField.alpha = 0
            ageTextField.isUserInteractionEnabled = false
     
            button.setTitle("LOGIN", for: .normal)
            button.addTarget(self, action: #selector(loginOrSignup), for: .touchUpInside)
            break
        case 1:
            genderLabel.alpha = 1
            genderSwitch.alpha = 1
            lookingForLabel.alpha = 1
            genderSwitch.isUserInteractionEnabled = true
            nameTextField.alpha = 1
            nameTextField.isUserInteractionEnabled = true
            ageTextField.alpha = 1
            ageTextField.isUserInteractionEnabled = true
          
            button.setTitle("SIGNUP", for: .normal)
            button.addTarget(self, action: #selector(loginOrSignup), for: .touchUpInside)
            break
        default:
            break
        }
        
    }
    
    @IBAction func genderSwitchAction(_ sender: UISwitch) {
        if (sender.isOn == true) {
            genderLabel.text = "female"
            myGender = "male"
        } else {
            genderLabel.text = "male"
            myGender = "female"
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func loginOrSignup() {
        if button.title(for: .normal) == "LOGIN" {
            button.removeTarget(self, action: #selector(signup), for: .touchUpOutside)
            login()
        } else {
            button.removeTarget(self, action: #selector(login), for: .touchUpOutside)
            signup()
        }
    }
    
    
    func login() {
        
        if emailLogin.text != "" && passwordLogin.text != "" {
            Auth.auth().signIn(withEmail: emailLogin.text!, password: passwordLogin.text!, completion: { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error logging in", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let viewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    viewController.userGender = self.genderLabel.text
                    viewController.myGender = self.myGender
                    self.present(viewController, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    func signup() {
        if emailLogin.text != "" || passwordLogin.text != "" || nameTextField.text != "" || ageTextField.text != "" {
            
            Auth.auth().createUser(withEmail: emailLogin.text!, password: passwordLogin.text!, completion: { (user: User?, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: "Error signing up in", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                let imageName = self.emailLogin.text
                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
                if let profileImage = self.imageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                            let values = ["name": self.nameTextField.text!, "email": self.emailLogin.text!, "profileImageUrl": profileImageUrl, "uid" : (user?.uid)!, "lookingFor" : self.genderLabel.text!, "age": self.ageTextField.text!, "desc" : "Hi there!", "gender" : self.myGender]
                            
                            self.uid = user?.uid
                            self.registerUserIntoDatabaseWithUID((user?.uid)!, values: values as [String : AnyObject])
                            self.handleImage()
                        }
                    })
                }
                
            })
        }
    }
    
        private func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(self.myGender!).child(uid)
            
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err!)
                    return
                }
                
                let viewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                viewController.userGender = self.genderLabel.text
                viewController.myGender = self.myGender
                self.present(viewController, animated: true, completion: nil)
                
            })
        }
    
    
    func uploadImage(_ image: UIImage) {
        let userEmail = Auth.auth().currentUser?.email
        let ref = Storage.storage().reference().child("profile_images").child("\(userEmail).jpg")
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        ref.putData(imageData, metadata: nil, completion: { (meta, error) in
            
            if let downloadPath = meta?.downloadURL()?.absoluteString {
                
                self.saveImagePath(downloadPath)
            }
            
        })
        
        
    }
    
    func saveImagePath(_ path: String) {
        
        let profilePictureValue : [String: Any] = ["profileImageUrl": path]
        
        Database.database().reference().child("users").child(myGender!).child(uid!).updateChildValues(profilePictureValue)
    }
    
    func handleImage(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseProfileImage))
        imageView.addGestureRecognizer(tap)
        
    }
    
    func chooseProfileImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    

 
}



extension LoginViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("User canceled out of picker")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker
        {
            imageView.image = selectedImage
            uploadImage(selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

