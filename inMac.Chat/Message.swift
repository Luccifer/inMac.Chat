//
//  Message.swift
//  inMac.Chat
//
//  Created by Gleb Karpushkin on 30/11/15.
//  Copyright © 2015 Gleb Karpushkin. All rights reserved.
//

import Foundation
import SwiftyJSON

public var textMessage: String = ""

class Message: AnyObject {
    
    required init (id: String, username: String, text: String?, isPrivate: Bool, userlevel: Int) {
        self.id = id
        self.username = username
        self.text = text
        textMessage = self.text!
        self.isPrivate = isPrivate
        self.userlevel = userlevel
    }
    
    let id: String?
    let username: String?
    let text: String?
    let isPrivate: Bool?
    let userlevel: Int?
    
    var separator: String {
        return ": "
    }
    
    static func parseFromJson(item: JSON) -> Message? {
        
        if let id = item["id"].string,
            username = item["username"].string,
            msg = item["msg"].string,
            isPrivate = item["private"].int,
            userlevel = item["userlevel"].int {
                return Message(id: id, username: username, text: msg, isPrivate: isPrivate > 0, userlevel: userlevel)
        }
        
        return nil
    }
}
