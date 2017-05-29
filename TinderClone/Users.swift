//
//  File.swift
//  TinderClone
//
//  Created by Kemuel Clyde Belderol on 28/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import Foundation

class Users {
    
    var name : String? = ""
    var age : String? = ""
    var imageUrl : String? = ""
    var uid : String? = ""
    var desc : String? = ""
    
    
    init(dictionary: [String : Any]) {
        self.name = dictionary["name"] as? String
        self.uid = dictionary["uid"] as? String
        self.imageUrl = dictionary["profileImageUrl"] as? String
        self.age = dictionary["age"] as? String
        self.desc = dictionary["desc"] as? String
        
    }
}
