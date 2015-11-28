////
////  MessageViewLayout.swift
////  inMac.Chat
////
////  Created by Gleb Karpushkin on 29/11/15.
////  Copyright © 2015 Gleb Karpushkin. All rights reserved.
////
//
//import UIKit
//
//class SLKMessageViewLayout: UICollectionViewFlowLayout {
//    
//    var rects: NSMutableDictionary?
//    var indexPathToAnimate: NSMutableArray?
//    var topPadding: CGFloat?
//    
////    required init?(coder aDecoder: NSCoder) {
////        super.init(coder: aDecoder)
////        
////        self.commontInt()
////        
////    }
//    
//    func commontInt () {
//        self.sectionInset = UIEdgeInsetsMake(10.0,10.0,10.0,10.0)
//        self.minimumLineSpacing = 2.0
//    }
//    
//    func layoutDelegate() -> AnyObject {
//        return (self.collectionView?.delegate)!
//    }
//    
//    func numberOfItemsInAllSections() -> NSInteger {
//        
//        var count: NSInteger = 0
//        var section: NSInteger = 0
//        var row: NSInteger = 0
//        while (section < self.collectionView?.numberOfSections()){
//            section += 1
//            while (row < self.collectionView?.numberOfItemsInSection(section)) {
//                row += 1
//                count += 1
//            }
//        }
//        return count
//    }
//    
//    
//}