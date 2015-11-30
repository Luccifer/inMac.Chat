////
////  CollectionViewCell.swift
////  inMac.Chat
////
////  Created by Gleb Karpushkin on 28/11/15.
////  Copyright © 2015 Gleb Karpushkin. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class SLKMessageViewCell: UICollectionViewCell {
//    
//    @IBOutlet weak var titleLabel: UILabel?
//    @IBOutlet weak var imageView: UIImageView?
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//        
//        self.titleLabel!.text! = "hello"
//        self.imageView = UIImageView()
//        
//        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
//        self.imageView?.backgroundColor = UIColor.lightGrayColor()
//        self.imageView?.layer.cornerRadius = 15.0
//        self.imageView?.layer.masksToBounds = true
//        self.imageView?.layer.shouldRasterize = true
//        self.imageView?.layer.rasterizationScale = UIScreen.mainScreen().scale
//        
//        self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
//        self.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        self.titleLabel?.numberOfLines = 0
//        
//        self.configureSubviews()
//        
//        
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        // Initialization code
//        self.backgroundColor = UIColor.clearColor()
//    }
//    
//    func configureSubviews() {
////        self.contentView.addSubview(self.imageView!)
//        self.contentView.addSubview(self.titleLabel!)
//        
////        let views: NSDictionary = ["imageView":self.imageView!, "titleLabel": self.titleLabel!]
////        let metrics: NSDictionary = ["imageSize":30.0]
//    }
//    
//    override func prepareForReuse() {
//        self.titleLabel?.text = nil
//    }
//    
//}