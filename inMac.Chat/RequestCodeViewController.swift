//
//  ViewController.swift
//  TicTacIOiOS
//
//  Created by Erik Little on 3/7/15.
//

import UIKit
import Socket_IO_Client_Swift
import SwiftyJSON

class RequestCodeViewController: UIViewController {
    
    let socket = SocketIOClient(socketURL: "https://inmac.org/chat/socket.io/")
    
    let KC = KeyChain()
    
    @IBOutlet weak var nickNameField: UITextField?
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var requestCodeButton: UIButton?
    
    @IBAction func requestCode(sender: AnyObject) {
        
        username = self.nickNameField!.text!
        password = self.passwordTextField!.text!
        self.requestCode(username!) { () -> Void in
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if  NSUserDefaults.standardUserDefaults().valueForKey("inchatToken") != nil {
            
            self.performSegueWithIdentifier("passToken", sender: nil)
        }else {
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.socket.connect()
        self.KC.load()
    }
    
    func requestCode(username: String, onComplete: () -> Void) {
        
        self.socket.emitWithAck("app_verification", ["method": "requestCode", "username": username, "uid": uuid, "appid": appid
            ])(timeoutAfter: 0) { data in
                
                print("REQUEST CODE:\(data)")
                
                guard (data.count > 0) else { print("app_verification empty answer"); return }
                
                if let json = JSON(rawValue: data[0]) {
                    if let _ = json["success"].int {
                        onComplete()
                    }
                }
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toVerify") {
            
            if let CheckCodeViewController: CheckCodeViewController = segue.destinationViewController as? CheckCodeViewController {
                
            }
        }
        
    }
}