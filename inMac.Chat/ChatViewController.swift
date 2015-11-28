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
    
    var messages: NSMutableArray = NSMutableArray()
    
    override class func collectionViewLayoutForCoder(decoder: NSCoder) -> UICollectionViewLayout {
        let layout = SLKMessageViewLayout()
        return layout
    }

    
    override func viewDidAppear(animated: Bool) {
        self.login()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.socket.connect()
        
        self.bounces = true
        self.shakeToClearEnabled = true
        self.keyboardPanningEnabled = true
        self.inverted = false
        
        self.textView.placeholder = "Message"
        self.textView.placeholderColor = UIColor.lightGrayColor()
        
        self.leftButton.setImage(UIImage(named: "icn_upload"), forState: UIControlState.Normal)
        self.leftButton.tintColor = UIColor.grayColor()
        self.rightButton.setTitle("Send", forState: UIControlState.Normal)
        
        self.textInputbar.autoHideRightButton = true
        self.textInputbar.maxCharCount = 140
        self.textInputbar.counterStyle = SLKCounterStyle.Split
        
        //self.typingIndicatorView.canResignByTouch = true
        
        self.collectionView!.registerClass(SLKMessageViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        
        for index in 0...20 {
            let message:NSString = "Hello"
            self.messages.addObject(message)
        }
        
        self.login()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func didPressLeftButton(sender: AnyObject!) {
        
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        
        self.textView.refreshFirstResponder()
        
        let message = self.textView.text.copy() as! NSString
        
        self.messages.insertObject(message, atIndex: 0)
        
        let idxPath : NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        self.collectionView.insertItemsAtIndexPaths([idxPath])
        
        self.collectionView.slk_scrollToBottomAnimated(true)
        
        super.didPressRightButton(sender)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> SLKMessageViewCell {
        
        let message = self.messages.objectAtIndex(indexPath.row) as! NSString
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! SLKMessageViewCell
        
        cell.titleLabel!.text = message as String
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let minHeight: CGFloat = 40.0
        
        let message = self.messages.objectAtIndex(indexPath.row) as! NSString
        let width: CGFloat = CGRectGetWidth(collectionView.frame)
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = NSTextAlignment.Left
        
        var attributes: NSDictionary = [NSFontAttributeName: UIFont.systemFontOfSize(17.0), NSParagraphStyleAttributeName: paragraphStyle]
        
        let bounds: CGRect = message.boundingRectWithSize(CGSizeMake(width, 0.0), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes as! [String : AnyObject], context: nil)
        
        if (message.length == 0) {
            return 0.0;
        }
        
        return max(CGRectGetHeight(bounds), minHeight)
    }

    
    func login() {
        
        guard let userId = userid else { return }
        guard let token = token else { return }
        
        socket.emitWithAck("app_verification", ["method": "login", "userid": userId, "token": token, "appid": appid])(timeoutAfter: 0) { data in
            print(data)
            guard (data.count > 0) else { print(" token_verification empty answer "); return }
            
            
            if let json = JSON(rawValue: data[0]) {
                if let success = json["success"].int {
                    if success > 0 {

                    } else {
                        print(" login unsuccessful ")
                        if let reason = json["reason"].string {
                            print(" reason is \(reason) ")
                            if reason == "INVALID_TOKEN" {

                            }
                        }
                    }
                }
            }
            
        }
    }

    
}

