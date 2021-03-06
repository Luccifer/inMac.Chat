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
import Alamofire

extension UILabel {
    
    func calculateHeight(width: CGFloat) -> CGFloat {
        if #available(iOS 9.0, *) {
            let textSize = CGSizeMake(bounds.width, 10000.0)
            let attrs = [NSFontAttributeName: font]
            if let text = text {
                return text.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attrs, context: nil).height
            } else {
                return 0.0
            }
        } else {
            var f = self.bounds
            f.size = sizeThatFits(CGSizeMake(f.size.width, CGFloat.max))
            return f.size.height
        }
    }
    
    func calculateWidth() -> CGFloat {
        if #available(iOS 9.0, *) {
            let textSize = CGSizeMake(10000.0, bounds.height)
            let attrs = [NSFontAttributeName: font]
            if let text = text {
                return text.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attrs, context: nil).width
            } else {
                return 0.0
            }
        } else {
            var f = self.bounds
            f.size = sizeThatFits(CGSizeMake(CGFloat.max, f.size.height))
            return f.size.width
        }
    }
    
}

class ChatViewController: SLKTextViewController {
    
    let socket = SocketIOClient(socketURL: "https://inmac.org/chat/socket.io/")
    
    var messages: [MessageNew] = []
    
    var users: [String] = []
    var myLastMessageId: String?
    
    override class func collectionViewLayoutForCoder(decoder: NSCoder) -> UICollectionViewLayout {
        let layout = SLKMessageViewLayout()
        return layout
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.login()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
//        let timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "newMessageGet:", userInfo: nil, repeats: true)
        
        self.login()
        
        self.socket.connect()
        
        self.setEditing(true, animated: true)
        
        self.bounces = true
        self.shakeToClearEnabled = true
        self.keyboardPanningEnabled = true
        self.inverted = false
        
        self.textView.placeholder = "Это чат! Поиск выше :)"
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
        
//        self.tableView.registerClass(SLKMessageViewCell.self, forCellWithReuseIdentifier: "MessageTableViewCell")
        
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
                            for item in list {
                                if let message = MessageNew.parseFromJson(item){
                                    self.messages.insert(message, atIndex: 0)

                                   
                                    self.collectionView.reloadData()
                                }
                                                            }
                            let useravatar = json["useravatar"].stringValue
                            let avatar = useravatar.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                            print("avatar is \(avatar)")
                            
                        }
                    case "message_writes":
                        
                        self.typingIndicatorView.insertUsername("Somebody")
                        
                    case "message_new":
                        if let message = MessageNew.parseFromJson(json) {
                            
                            self.messages.insert(message, atIndex: 0)
                            self.collectionView.reloadData()
                            
                        }
                        
//                    case "message_delete":
//                        if let id = json["id"].string {
//                            self.messages = self.messages.filter { $0.id != id }
//                            self.messages = self.messages.f
////                            self.messages.remove
//                            self.collectionView.reloadData()
//                        }
                    default: print(" [\(method)] method received ")
                    }
                }
            }
        }
        
        self.collectionView.reloadData()
    }
    
    func disconnect() {
        socket.disconnect()
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
        
        let message = self.textView.text.copy()
        
        self.sendMessage(message as! String)
        
        
//        let idxPath : NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
//        
//        self.collectionView.insertItemsAtIndexPaths([idxPath])
        
        
        super.didPressRightButton(sender)
        
        self.collectionView.reloadData()
        
        self.collectionView.slk_scrollToBottomAnimated(true)

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
        
        (cell as SLKMessageViewCell).titleLabel?.text = ("\(message.username): \(message.text)")
        
        let userAvatar = message.userAvatar
        let imageURL = "st.inmac.org/images/avatars/\(userAvatar)"
        
        (cell as SLKMessageViewCell).imageView.image = UIImage.imageFromURL(imageURL, placeholder: UIImage(named: "noavatar")!, shouldCacheImage: true, closure: { (image) -> () in
            
        })
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let minHeight: CGFloat = 120.0
        
        let message = self.messages[(indexPath.row)].text
        let nickname = self.messages[(indexPath.row)].username
        let text:NSString = nickname + (message as String)
        let label = SLKMessageViewCell().titleLabel
        
        label.text = nickname + (message as String)
       
        
        let width: CGFloat = CGRectGetWidth(collectionView.frame)
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = NSTextAlignment.Left
        
        let attributes: NSDictionary = [NSFontAttributeName: UIFont.systemFontOfSize(17.0), NSParagraphStyleAttributeName: paragraphStyle]
        
        let bounds: CGRect = text.boundingRectWithSize(CGSizeMake(width, 0.0), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes as? [String : AnyObject], context: nil)
        
        
        if (text.length == 0) {
            return 0.0;
        }
        
        return max(CGRectGetHeight(bounds), minHeight)
    }

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//    
//            // NOTE: here is where we say we want cells to use the width of the collection view
//            let requiredWidth = collectionView.bounds.size.width
//            
//            // NOTE: here is where we ask our sizing cell to compute what height it needs
//            let targetSize = CGSize(width: requiredWidth, height: 0)
//            /// NOTE: populate the sizing cell's contents so it can compute accurately
////            self.sizingCell.label.text = messages[indexPath.row]
//            SLKMessageViewCell().titleLabel.text = messages[indexPath.row].text
////            let adequateSize = self.sizingCell.preferredLayoutSizeFittingSize(targetSize)
//            let adequateSize = SLKMessageViewCell().systemLayoutSizeFittingSize(targetSize)
//        
//        
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! SLKMessageViewCell
//        
//        let colletcionViewWidth = self.collectionView.bounds.size.width
//        
//        
//        
//            return adequateSize
//    
//    
//    }
    
    func login() {
        
        guard let user = userid else { return }
        guard let tok = token else { return }
        
        socket.emitWithAck("app_verification", ["method": "login", "userid": user, "token": tok, "appid": appid])(timeoutAfter: 0) { data in

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
        }
    }

    func deleteMessage(id: String) {
        guard (!id.isEmpty) else { return }
        
        socket.emitWithAck("api", ["method": "message_delete", "id": id])(timeoutAfter: 0) { data in

        }
    }
    
}