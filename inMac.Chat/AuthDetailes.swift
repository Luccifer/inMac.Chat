//
//  AuthDetailes.swift
//  inMac.Chat
//
//  Created by Gleb Karpushkin on 28/11/15.
//  Copyright © 2015 Gleb Karpushkin. All rights reserved.
//

import Foundation

import Foundation

struct AuthDetailes {
    
    func save() {
        NSUserDefaults.standardUserDefaults().setObject(userid, forKey: "inchatUserId")
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "inchatToken")
    }
    
    func delete() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("inchatUserId")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("inchatToken")
    }
    
    func load() {
        userid = NSUserDefaults.standardUserDefaults().objectForKey("inchatUserId") as? Int
        token = NSUserDefaults.standardUserDefaults().objectForKey("inchatToken") as? String
    }
}
