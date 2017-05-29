//
//  EditViewController.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 27/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController {
    
    var userName : String? = ""
    var userEmail : String? = ""
    var currentUserID = Auth.auth().currentUser?.uid
    var gender : String? = ""
    
    var profileImage1 : String? = ""
    @IBOutlet weak var imageView1: UIImageView!
    var profileImage2 : String? = ""
    @IBOutlet weak var imageView2: UIImageView!
    var profileImage3 : String? = ""
    @IBOutlet weak var imageView3: UIImageView!
    var profileImage4 : String? = ""
    @IBOutlet weak var imageView4: UIImageView!
    var profileImage5 : String? = ""
    
    
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            emailLabel.text = userEmail
        }
    }
    @IBOutlet weak var aboutAndNameLabel: UILabel!{
        didSet{
            aboutAndNameLabel.text = "About \(userName!)"
        }
    }
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var lookingForLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        listenToFirebase()
        handleImage()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        guard let updatedAbout = aboutTextView.text,
            let updatedLookingFor = lookingForLabel.text else {return}
        
        let updatedValues : [String : Any] = ["desc" : updatedAbout, "lookingFor" : updatedLookingFor]
        Database.database().reference().child("users").child(gender!).child(currentUserID!).updateChildValues(updatedValues)
        
        dismiss(animated: true, completion: nil)
       
        
    }
    
    @IBAction func genderSwitchAction(_ sender: UISwitch) {
        if (sender.isOn == true) || self.lookingForLabel.text == "Male" {
            self.lookingForLabel.text = "Female"
        } else if sender.isOn == false || self.lookingForLabel.text == "Female" {
            self.lookingForLabel.text = "Male"
        }
    }
    
    func listenToFirebase() {
        Database.database().reference().child("users").child(gender!).child(currentUserID!).observe(.value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? [String : Any]
            
            self.aboutTextView.text = dictionary?["desc"] as? String
            self.profileImage1 = dictionary?["profileImageUrl"] as? String
            self.genderLabel.text = dictionary?["gender"] as? String
            self.lookingForLabel.text = dictionary?["lookingFor"] as? String

            if let profileURL = self.profileImage1 {
                self.imageView1.loadImageUsingCacheWithUrlString(profileURL)

            }

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
        
        Database.database().reference().child("users").child(gender!).child(currentUserID!).updateChildValues(profilePictureValue)
    }
    
    func handleImage(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseProfileImage))
        imageView1.addGestureRecognizer(tap)
        
    }
    
    func chooseProfileImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }


}

extension EditViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            imageView1.image = selectedImage
            uploadImage(selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

