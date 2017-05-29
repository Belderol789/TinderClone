//
//  ChatViewController.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 29/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    var matchedUsers : [String] = []
    var currentUserUid : String? = ""
    var currentUserGender : String? = ""
    var users : [Users] = []
    
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserUid = Auth.auth().currentUser?.uid
        getMatchedUsers()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    
    func getMatchedUsers() {
        Database.database().reference().child("users").child(currentUserGender!).child(currentUserUid!).child("matched").observe(.value, with: { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String : Any] {
                let user = Users(dictionary: dictionary)
                self.users.append(user)
                
                
            }
           
            
            
        })
        
        
        
    }
    
  

}


extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        
        return cell
        
        
    }
}
