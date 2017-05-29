//
//  Chat.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 29/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import Foundation

class Chat {
    
    var chat: String? = ""
    var myID : String? = ""
    var userUID : String? = ""
    var userImage : String? = ""
    var username : String? = ""

    init(dictionary: [String : Any]) {
        self.chat = dictionary["chat"] as? String
        self.myID = dictionary["myID"] as? String
        self.userUID = dictionary["userUID"] as? String
        self.userImage = dictionary["userImage"] as? String
        self.username = dictionary["username"] as? String
    }
}
