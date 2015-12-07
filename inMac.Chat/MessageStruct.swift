//
//  MessageStruct.swift
//  inMac.Chat
//
//  Created by Gleb Karpushkin on 01/12/15.
//  Copyright © 2015 Gleb Karpushkin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MessageNew {

    
    let id: String
    let username: String
    var text: NSMutableString
    let isPrivate: Bool
    let userlevel: Int
    let userAvatar: String
    
    var separator: String {
        return ": "
    }
    
    static func parseFromJson(item: JSON) -> MessageNew? {
        
        if let id = item["id"].string,
            username = item["username"].string,
            msg = item["msg"].string,
            isPrivate = item["private"].int,
            Avatar = item["useravatar"].string,
            userlevel = item["userlevel"].int {
                return MessageNew(id: id, username: username, text: NSMutableString(string: msg), isPrivate: isPrivate > 0, userlevel: userlevel, userAvatar: Avatar)
        }
        
        return nil
    }
}