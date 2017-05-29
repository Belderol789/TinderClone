//
//  ConvoViewController.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 29/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class ConvoViewController: UIViewController {
    
    var chosenUserID : String? = ""
    var myID : String? = ""
    var messages : [String] = []
    var uniqueChatID : String? = ""
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var chatTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myID = Auth.auth().currentUser?.uid
        getChats()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getChats() {
        
        self.uniqueChatID = chosenUserID! + myID!
        Database.database().reference().child("chat").child(uniqueChatID!).observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                
                let message = dictionary["message"] as? String
                
                self.messages.append(message!)
                
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
    
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        self.uniqueChatID = chosenUserID! + myID!
        
        let message = ["message" : self.chatTextField.text]
        
        guard let newMessage = self.chatTextField.text else {return}
        
        self.messages.append(newMessage)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        Database.database().reference().child("chat").child(uniqueChatID!).childByAutoId().updateChildValues(message)
    }
    
}

extension ConvoViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.textLabel?.text = message
        return cell
        
    }
    
    
}
