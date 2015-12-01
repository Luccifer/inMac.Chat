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
    let text: String
    let isPrivate: Bool
    let userlevel: Int
    
    var separator: String {
        return ": "
    }
    
    static func parseFromJson(item: JSON) -> MessageNew? {
        
        if let id = item["id"].string,
            username = item["username"].string,
            msg = item["msg"].string,
            isPrivate = item["private"].int,
            userlevel = item["userlevel"].int {
                return MessageNew(id: id, username: username, text: msg, isPrivate: isPrivate > 0, userlevel: userlevel)
        }
        
        return nil
    }
}