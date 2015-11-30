//
//  AuthDetailes.swift
//  inMac.Chat
//
//  Created by Gleb Karpushkin on 28/11/15.
//  Copyright © 2015 Gleb Karpushkin. All rights reserved.
//

import Foundation

import Foundation


struct KeyChain{
    
    func save() {
        NSUserDefaults.standardUserDefaults().setObject(userid!, forKey: "inchatUserId")
        NSUserDefaults.standardUserDefaults().setObject(token!, forKey: "inchatToken")
        NSUserDefaults.standardUserDefaults().setObject(password!, forKey: "password")
        NSUserDefaults.standardUserDefaults().setObject(username!, forKey: "username")
    }
    
    func delete() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("inchatUserId")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("inchatToken")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
    }
    
    func load() {
        userid = NSUserDefaults.standardUserDefaults().objectForKey("inchatUserId") as? Int
        token = NSUserDefaults.standardUserDefaults().objectForKey("inchatToken") as? String
        username = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String
        password = NSUserDefaults.standardUserDefaults().objectForKey("password") as? String
    }
}
