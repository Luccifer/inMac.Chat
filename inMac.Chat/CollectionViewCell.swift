//////
//////  CollectionViewCell.swift
//////  inMac.Chat
//////
//////  Created by Gleb Karpushkin on 28/11/15.
//////  Copyright © 2015 Gleb Karpushkin. All rights reserved.
//////
////
//import UIKit
//
//class MessageTableViewCell: UITableViewCell {
//    
//    static let REUSE_ID = "MessageTableViewCell"
//    
//    let nameLabel : UILabel = UILabel()
//    let bodyLabel: UILabel = UILabel()
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        self.nameLabel.font = UIFont.boldSystemFontOfSize(14.0)
//        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.bodyLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.bodyLabel.numberOfLines = 0
//        
//        self.addSubview(nameLabel)
//        self.addSubview(bodyLabel)
//        
//        let views = ["nameLabel": nameLabel, "bodyLabel": bodyLabel]
//        
//        //Horizontal constraints
//        let nameLabelHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[nameLabel]-10-|", options: nil, metrics: nil, views: views)
//        let bodyLabelHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[bodyLabel]-10-|", options: nil, metrics: nil, views: views)
//        self.addConstraints(nameLabelHorizontalConstraints)
//        self.addConstraints(bodyLabelHorizontalConstraints)
//        
//        //Vertical constraints
//        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[nameLabel]-5-[bodyLabel]-10-|", options: nil, metrics: nil, views: views)
//        self.addConstraints(verticalConstraints)
//        
//        
//        
//        
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}