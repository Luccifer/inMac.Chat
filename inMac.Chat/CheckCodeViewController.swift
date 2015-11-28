//
//  CheckCodeViewController.swift
//  inMac.Chat
//
//  Created by Gleb Karpushkin on 28/11/15.
//  Copyright © 2015 Gleb Karpushkin. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift
import SwiftyJSON

class CheckCodeViewController: UIViewController {
    
    let socket = SocketIOClient(socketURL: "https://inmac.org/chat/socket.io/")
    
    @IBOutlet weak var codeVerificationField: UITextField!
    
    @IBOutlet weak var verifyButton: UIButton!
    
    @IBAction func verifyButtonAction(sender: AnyObject) {
        
        self.verify_code(codeVerificationField.text!) { () -> Void in
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.socket.connect()
    }
    
    func verify_code(code: String, onComplete: () -> Void) {
        socket.emitWithAck("app_verification", ["method": "requestCode", "username": username, "uid": uuid, "verificationCode": code])(timeoutAfter: 0) { data in
            
            print(data)
            
            guard (data.count > 0) else { print("code_verification empty answer"); return }
            
            if let json = JSON(rawValue: data[0]) {
                if let success = json["success"].int {
                    if success > 0 {
                        token = json["token"].stringValue
                        userid = json["userid"].intValue
                        
                        let keyChain = AuthDetailes()
                        keyChain.save()
                        print("Code Confirm Success")
                        
                        self.performSegueWithIdentifier("toChat", sender: nil)
                        
                    } else {
                        self.performSegueWithIdentifier("toStart", sender: nil)
                        print(" code_verification unsuccessful ")
                        if let reason = json["reason"].string {
                            print("reason is \(reason) ")
                            if reason == "INVALID_TOKEN" {
                                
                            }
                        }
                    }
                }
                
            }
        }
        
        onComplete()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toChat") {
            
            if let ChatViewController: ChatViewController = segue.destinationViewController as? ChatViewController {
            }
        }
        
    }
    
}
