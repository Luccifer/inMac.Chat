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
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        self.commontInt()
//        
//    }
//    
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
//    func topPagging() -> CGFloat {
//        
////        CGRect lastRect = [self.rects[[self lastIndexPath]] CGRectValue];
//        
//        let viewHeight: CGFloat = CGRectGetHeight((self.collectionView?.bounds)!)
//        let lastRect: CGRect = self.rects![self.lastIndexPath()]!.CGRectValue!
//
//        var padding: CGFloat = viewHeight-CGRectGetHeight(lastRect)
//        
//        padding -= self.contentSizeHeight()
//        
//        padding -= 44.0;
//        padding -= 20.0;
//        
//        print("padding: %f\n\n \(padding)")
//        
//        if (padding < 0) {
//            padding = 0;
//        }
//        
//        return padding;
//    }
//    
//    func contentSizeHeight() -> CGFloat {
//        
//        var height: CGFloat = 0.0
//        let numberOfItems: Int = (self.rects?.allValues)!.count as Int
//        
//        for indexPath in (self.rects?.allKeys)! {
//            let frame: CGRect = (self.rects?[indexPath.row]?.CGRectValue!)!
//            height += CGRectGetHeight(frame)
//        }
//        
//        if numberOfItems > 0 {
//            height += self.sectionInset.top+self.sectionInset.bottom
//            let myIntHeight: Int = Int(self.minimumLineSpacing)
//            height = CGFloat(myIntHeight * numberOfItems-1)
//            
//        }
//        
//        return height
//    }
//    
//    func originForRowAtIndexPath(indexPath:NSIndexPath ) -> CGPoint {
//        var maxHeight: CGFloat = 0.0
//        
//        if indexPath.row >= 0 && indexPath.row < self.collectionView?.numberOfItemsInSection(indexPath.section) {
////
//            let previousIdxPath: NSIndexPath = NSIndexPath(index: (indexPath.row+1))
//            let rect: CGRect = self.rects![previousIdxPath]!.CGRectValue
//            
//            maxHeight += CGRectGetMaxY(rect)
//            maxHeight += self.minimumLineSpacing
//            
//            if indexPath.isEqual(self.lastIndexPath()) {
//                maxHeight += self.sectionInset.top
//                maxHeight += self.topPadding!
//            }
//
//        }
//        
//        return CGPointMake(self.sectionInset.left, maxHeight)
//    }
// 
////    func sizeForRowAtIndexPath(indexPath: NSIndexPath) -> CGSize {
////        
////        if self.layoutDelegate() && [self.layoutDelegate().respondsToSelector(aSelector: Sel) {
////            
////        }
////        
////        return CGSizeZero
////    }
//    
//    func frameForRowAtIndexPath(indexPath: NSIndexPath) -> CGRect {
//        
//        var frame: CGRect = CGRectZero
//        frame.origin = self.originForRowAtIndexPath(indexPath)
////        frame.size = self.sizeForRowAtIndexPath
//        return frame
//    }
//    
//    func firstIndexPath() -> NSIndexPath {
//        
//        return NSIndexPath(forItem: 0, inSection: 0)
//    }
//    
//    func lastIndexPath() -> NSIndexPath {
//        
//        let section: Int = self.collectionView!.numberOfSections()-1
//        let row: Int = self.collectionView!.numberOfItemsInSection(section)-1
//        
//        return NSIndexPath(forItem: row, inSection: section)
//
//    }
//    
//
////    func populateAllRects() {
////        if (rects == nil) {
////         
////            for section = (self.collectionView?.numberOfSections() - 1) {
////                section -= 1
////                for row = self.collectionView?.numberOfItemsInSection(-1) {
////                    row -= 1
////                    self.
////                }
////            }
////        }
////    }
//
//    func populateRectForIndexPath(indexPath: NSIndexPath) {
//        
//        var newFrame: CGRect = self.frameForRowAtIndexPath(indexPath)
//        let oldFrame: CGRect = self.rects[indexPath]!.CGRectValue()
//        // Skips if the new frame isn't different than the old one.
//        if CGSizeEqualToSize(newFrame.size, oldFrame.size) && CGRectGetMinY(newFrame) == CGRectGetMinY(oldFrame) {
//            return
//        }
//        
//        self.rects![indexPath] = NSValue.valueWithCGRect(newFrame)
//    }
//    
//    
//
//    
//}