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
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
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
