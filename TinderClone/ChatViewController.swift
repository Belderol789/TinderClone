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
    
    var matchedUsers : [Chat] = []
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
        getChatPartners()
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    
    
    func getChatPartners() {
        Database.database().reference().child("matches").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : Any] {
                let chattableUsers = Chat(dictionary: dictionary)
                
                if chattableUsers.myID == self.currentUserUid {
                    self.matchedUsers.append(chattableUsers)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
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
        
        let newChatUser = matchedUsers[indexPath.row]
        
        cell.textLabel?.text = newChatUser.username
        if let profileImageUrl = newChatUser.userImage {
            cell.imageView?.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
