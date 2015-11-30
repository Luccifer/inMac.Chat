//
//  ChatViewController.swift
//  inMac.Chat
//
//  Created by Gleb Karpushkin on 28/11/15.
//  Copyright © 2015 Gleb Karpushkin. All rights reserved.
//

import SlackTextViewController
import Socket_IO_Client_Swift
import SwiftyJSON

class ChatViewController: SLKTextViewController {
    
    let socket = SocketIOClient(socketURL: "https://inmac.org/chat/socket.io/")
    
    var messages: [String] = []
    var users: [String] = []
    var myLastMessageId: String?
    
    override class func collectionViewLayoutForCoder(decoder: NSCoder) -> UICollectionViewLayout {
        let layout = SLKMessageViewLayout()
        return layout
    }
    
    

    
    override func viewDidAppear(animated: Bool) {
        self.login()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "newMessageGet:", userInfo: nil, repeats: true)
        
        self.login()
        
        
        self.socket.connect()
        
        self.bounces = true
        self.shakeToClearEnabled = true
        self.keyboardPanningEnabled = true
        self.inverted = false
        
        self.textView.placeholder = "Message"
        self.textView.placeholderColor = UIColor.lightGrayColor()
        
        self.registerPrefixesForAutoCompletion(["#","@",":"])
        
        self.leftButton.setImage(UIImage(named: "icn_upload"), forState: UIControlState.Normal)
        self.leftButton.tintColor = UIColor.grayColor()
        self.rightButton.setTitle("Send", forState: UIControlState.Normal)
        
        self.textInputbar.autoHideRightButton = true
        self.textInputbar.maxCharCount = 150
        self.textInputbar.counterStyle = SLKCounterStyle.Split
        
        self.typingIndicatorView.canResignByTouch = true
        
        
        self.collectionView!.registerClass(SLKMessageViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        
        self.socket.on("api") { data, ack in
            if let json = JSON(rawValue: data[0]) {
                if let method = json["method"].string {
                    switch method {
                    case "auth":
                        print(json)

                    case "loggedin":
                        if let _ = json["client"].string {
                           print(" [\(method)] method received ")
                        }
                    case "history":
                        if let list = json["list"].array {
                            var messages:[Message] = []
                            for item in list {
                                if let message = Message.parseFromJson(item){
                                    self.messages.append("\(textMessage)")
                                    
                                    print("message is: \(textMessage)")
                                    self.collectionView.reloadData()
                                }
                            }
                        }
                    case "message_writes":
                        self.typingIndicatorView.insertUsername("Somebody")
                        print("Somebody writes")
                        
                    case "message_new":
                        let id = json["id"].stringValue
                        let userid = json["userid"].intValue
                        let username = json["username"].stringValue
                        let useravatar = json["useravatar"].stringValue
                        print(useravatar)
                        let userlevel = json["userlevel"].intValue
                        if let message = json["msg"].string {
                            self.messages.append("\(message)")
                            self.collectionView.reloadData()
                        }
                        let prvt = json["private"].boolValue
                        let privatename = json["privatename"].stringValue
                        let time = json["time"].stringValue
//                    case "message_delete":
//                        if let id = json["id"].string {
//                            UI.messages = UI.messages.filter { $0.id != id }
//                        }
                    default: print(" [\(method)] method received ")
                    }
                }
            }
        }
        


        for message in self.messages {
            let newMessage = message 
            self.messages.append("\(newMessage)")
        }
//        for index in 0...10 {
//            let message:NSString = "Hello darling"
//            self.messages.addObject(message)
//        }
        
        self.collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func didPressLeftButton(sender: AnyObject!) {
        
    }
    
//
//    override func didChangeAutoCompletionPrefix(prefix: String!, andWord word: String!) {
//        
//        let searchResult = NSArray(array: self.users)
//        
//        self.showAutoCompletionView(true)
//        
//    }
    
//    override func didCommitTextEditing(sender: AnyObject!) {
//        
//        let message: NSString? = self.textView.text.copy() as? NSString
//        
//        self.messages.removeObjectAtIndex(0)
//        self.messages.insertObject(message!, atIndex: 0)
//        self.collectionView.reloadData()
//        
//        super.didCommitTextEditing(nil)
//        
//    }
//    
//    override func didCancelTextEditing(sender: AnyObject!) {
//        super.didCancelTextEditing(nil)
//    }
    
    
    override func didPressRightButton(sender: AnyObject!) {
        
        
        self.textView.refreshFirstResponder()
        
        let message = self.textView.text.copy() as! NSString
        self.sendMessage(message as String)
        
        self.messages.append("\(message)")
        
        let idxPath : NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        self.collectionView.insertItemsAtIndexPaths([idxPath])
        
        self.collectionView.slk_scrollToBottomAnimated(true)
        
        super.didPressRightButton(sender)
        
        self.collectionView.reloadData()
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> SLKMessageViewCell {
        
        let message = self.messages[(indexPath.row)]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! SLKMessageViewCell
        print(message)
//        cell.titleLabel?.text = message as String
        (cell as SLKMessageViewCell).titleLabel?.text = message as String
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let minHeight: CGFloat = 40.0
        
        let message = self.messages[(indexPath.row)]
        let width: CGFloat = CGRectGetWidth(collectionView.frame)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = NSTextAlignment.Left
        
        let attributes: NSDictionary = [NSFontAttributeName: UIFont.systemFontOfSize(17.0), NSParagraphStyleAttributeName: paragraphStyle]
        
        let bounds: CGRect = message.boundingRectWithSize(CGSizeMake(width, 0.0), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes as? [String : AnyObject], context: nil)
        
//        if (message == 0) {
//            return 0.0;
//        }
        
        return max(CGRectGetHeight(bounds), minHeight)
       
//        return CGFloat()
    }

    
    func login() {
        
        guard let user = userid else { return }
        guard let tok = token else { return }
        
        socket.emitWithAck("app_verification", ["method": "login", "userid": user, "token": tok, "appid": appid])(timeoutAfter: 0) { data in
//            print(data)
            guard (data.count > 0) else { print(" token_verification empty answer "); return }
            
            
            if let json = JSON(rawValue: data[0]) {
                token = json["token"].stringValue
                userid = json["userid"].intValue
                let KC = KeyChain()
                KC.save()
                
                
                if let success = json["success"].int {
                    if success > 0 {
                        
                        
                    } else {
                        print(" login unsuccessful ")
                        if let reason = json["reason"].string {
                            print(" reason is \(reason) ")
                            if reason == "INVALID_TOKEN" {
//
                            }
                        }
                    }
                }
            }
            
        }
        self.collectionView.reloadData()
    }

    func sendMessage(message: String) {
        guard (!message.isEmpty) else { return }
        
        socket.emitWithAck("api", ["method": "message_new", "msg": message])(timeoutAfter: 0) { data in
            
            guard (data.count > 0) else { print(" message_new empty answer "); return }
            
            if let json = JSON(rawValue: data[0]) {
                if let success = json["success"].int {
                    if success > 0 {
                        if let id = json["id"].string {
                            self.myLastMessageId = id
                        }
                    } else {
                        print(" message_new unsuccessful ")
                    }
                }
            }
            
            self.collectionView.reloadData()
        }
    }

    func deleteMessage(id: String) {
        guard (!id.isEmpty) else { return }
        
        socket.emitWithAck("api", ["method": "message_delete", "id": id])(timeoutAfter: 0) { data in
            //log here
        }
    }
    
}