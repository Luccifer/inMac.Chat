////
////  MessageViewLayout1.swift
////  inMac.Chat
////
////  Created by Gleb Karpushkin on 06/12/15.
////  Copyright © 2015 Gleb Karpushkin. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SlackTextViewController
//
//class SLKMessageViewLayout: UICollectionViewFlowLayout {
//    
//    
//    var rects: NSMutableDictionary?
//    var indexPathToAnimate: NSMutableArray?
//    var padding: CGFloat?
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.commonInit()
//    }
//    
//    func commonInit() {
//        self.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
//        self.minimumLineSpacing = 2.0
//    }
//    
//    func layoutDelegate() -> AnyObject {
//        return (self.collectionView?.delegate)!
//    }
//    
//    
//    func numberOfItemsInAllSections() -> Int {
//        var count: Int = 0
//        for var section = 0; section < self.collectionView!.numberOfSections(); section++ {
//            for var row = 0; row < self.collectionView!.numberOfItemsInSection(section); row++ {
//                count++
//            }
//        }
//        return count
//    }
//    
//    func topPadding() -> CGFloat {
//        let viewHeight: CGFloat = CGRectGetHeight(self.collectionView!.bounds)
//        let lastRect: CGRect = self.rects![self.lastIndexPath()]!.CGRectValue!
//        var padding: CGFloat = viewHeight - CGRectGetHeight(lastRect)
//        padding -= self.contentSizeHeight()
//        padding -= 44.0
//        padding -= 20.0
//        NSLog("padding : %f\n\n", padding)
//        if padding < 0 {
//            padding = 0
//        }
//        self.padding = padding
//        return padding
//    }
//    
//    func originForRowAtIndexPath(indexPath:NSIndexPath ) -> CGPoint {
//                var maxHeight: CGFloat = 0.0
//        
//                if indexPath.row >= 0 && indexPath.row < self.collectionView?.numberOfItemsInSection(indexPath.section) {
//        //
//                    let previousIdxPath: NSIndexPath = NSIndexPath(index: (indexPath.row+1))
//                    let rect: CGRect = self.rects![previousIdxPath]!.CGRectValue
//        
//                    maxHeight += CGRectGetMaxY(rect)
//                    maxHeight += self.minimumLineSpacing
//        
//                    if indexPath.isEqual(self.lastIndexPath()) {
//                        maxHeight += self.sectionInset.top
//                        maxHeight = maxHeight + self.padding!
//                    }
//        
//                }
//                
//                return CGPointMake(self.sectionInset.left, maxHeight)
//            }
//    
//    func sizeForRowAtIndexPath(indexPath: NSIndexPath) -> CGSize {
//        if self.layoutDelegate().respondsToSelector("collectionView:heightForRowAtIndexPath:") {
//            
//            var height: CGFloat = self.layoutDelegate().collectionView(self.collectionView, heightForRowAtIndexPath: indexPath)
//            
//            var hMargins: CGFloat = self.sectionInset.left + self.sectionInset.right
//            return CGSizeMake(CGRectGetWidth(self.collectionView!.frame) - hMargins, height)
//        }
//        return CGSizeZero
//    }
//    
//    func frameForRowAtIndexPath(indexPath: NSIndexPath) -> CGRect {
//        var frame: CGRect = CGRectZero
//        frame.origin = self.originForRowAtIndexPath(indexPath)
//        frame.size = self.sizeForRowAtIndexPath(indexPath)
//        return frame
//    }
//    
//    func firstIndexPath() -> NSIndexPath {
//        return NSIndexPath.init(forItem: 0, inSection: 0)
//    }
//    
//    func lastIndexPath() -> NSIndexPath {
//        let section: Int = self.collectionView!.numberOfSections() - 1
//        let row: Int = self.collectionView!.numberOfItemsInSection(section) - 1
//        return NSIndexPath.init(forItem: row, inSection: section)
//    }
//    
//    func populateAllRects() {
//        if (rects == nil) {
//            self.rects = NSMutableDictionary()
//        }
//        for var section = self.collectionView!.numberOfSections() - 1; section >= 0; section-- {
//            for var row = self.collectionView!.numberOfItemsInSection(section) - 1; row >= 0; row-- {
//                self.populateRectForIndexPath(NSIndexPath.init(forRow: row, inSection: section))
//            }
//        }
//    }
//    
//    func populateRectForIndexPath(indexPath: NSIndexPath) {
//        let newFrame: CGRect = self.frameForRowAtIndexPath(indexPath)
//        let oldFrame: CGRect = self.rects![indexPath]!.CGRectValue!
//        // Skips if the new frame isn't different than the old one.
//        if CGSizeEqualToSize(newFrame.size, oldFrame.size) && CGRectGetMinY(newFrame) == CGRectGetMinY(oldFrame) {
//            return
//        }
////        self.rects![indexPath] = NSValue.valueWithCGRect(newFrame)
//        self.rects![indexPath] = NSValue.CGRectValue(newFrame)
//    }
//    
//    override func prepareLayout() {
//        super.prepareLayout()
//        NSLog("%s", __FUNCTION__)
//        self.populateAllRects()
//    }
//    
//    override func invalidateLayout() {
//        super.invalidateLayout()
//    }
//    
//    override func collectionViewContentSize() -> CGSize {
//        self.populateAllRects()
//        let collectionViewSize: CGSize = self.collectionView!.frame.size
//        var contentSizeHeight: CGFloat = self.contentSizeHeight()
//        if contentSizeHeight < collectionViewSize.height {
//            contentSizeHeight = collectionViewSize.height
//            //        contentSizeHeight -= 44.0;
//            //        contentSizeHeight -= 20.0;
//        }
//        NSLog("contentSizeHeight : %f\n\n", contentSizeHeight)
//        return CGSizeMake(collectionViewSize.width, contentSizeHeight)
//    }
//    
//        func contentSizeHeight() -> CGFloat {
//    
//            var height: CGFloat = 0.0
//            let numberOfItems: Int = (self.rects?.allValues)!.count as Int
//    
//            for indexPath in (self.rects?.allKeys)! {
//                let frame: CGRect = (self.rects?[indexPath.row]?.CGRectValue!)!
//                height += CGRectGetHeight(frame)
//            }
//    
//            if numberOfItems > 0 {
//                height += self.sectionInset.top+self.sectionInset.bottom
//                let myIntHeight: Int = Int(self.minimumLineSpacing)
//                height = CGFloat(myIntHeight * numberOfItems-1)
//    
//            }
//            
//            return height
//        }
//    
////    func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject] {
////        var array: [AnyObject] = [].mutableCopy() as! [AnyObject]
////        for indexPath: NSIndexPath in self.rects!.allKeys {
////            var frame: CGRect = self.rects[indexPath].CGRectValue()
////            if CGRectIntersectsRect(frame, rect) {
////                array.addObject(self.layoutAttributesForItemAtIndexPath(indexPath))
////            }
////        }
////        return array
////    }
//    
//    override  func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
//        
//        let attributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
//        
//        attributes.frame = self.frameForRowAtIndexPath(indexPath)
//        return attributes
//    }
//    
//    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
//        let oldBounds: CGRect = self.collectionView!.bounds
//        // Responding to Device Rotation
//        if CGRectGetWidth(oldBounds) != CGRectGetWidth(newBounds) {
//            self.rects = nil
//            return true
//        }
//        return false
//    }
//    /*
//    
//    - (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
//    {
//    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
//    }
//    
//    - (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
//    {
//    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
//    }
//    
//    - (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath
//    {
//    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
//    }
//    
//    - (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds
//    {
//    return [super invalidationContextForBoundsChange:newBounds];
//    }
//    
//    - (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes
//    {
//    return [super shouldInvalidateLayoutForPreferredLayoutAttributes:preferredAttributes withOriginalAttributes:originalAttributes];
//    }
//    
//    - (UICollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes
//    {
//    return [super invalidationContextForPreferredLayoutAttributes:preferredAttributes withOriginalAttributes:originalAttributes];
//    }
//    
//    */
//    
//    //    func prepareForCollectionViewUpdates(updateItems: [AnyObject]) {
//    //        //    [super prepareForCollectionViewUpdates:updateItems];
//    //        //
//    //        //    if (_indexPathsToAnimate) {
//    //        //        _indexPathsToAnimate = nil;
//    //        //    }
//    //        //
//    //        //    _indexPathsToAnimate = [NSMutableArray array];
//    //        //
//    //        //    for (UICollectionViewUpdateItem *updateItem in updateItems) {
//    //        //        switch (updateItem.updateAction) {
//    //        //            case UICollectionUpdateActionInsert:
//    //        //                [self.indexPathsToAnimate addObject:updateItem.indexPathAfterUpdate];
//    //        //                break;
//    //        //            case UICollectionUpdateActionDelete:
//    //        //                [self.indexPathsToAnimate addObject:updateItem.indexPathBeforeUpdate];
//    //        //                break;
//    //        //            case UICollectionUpdateActionMove:
//    //        //                [self.indexPathsToAnimate addObject:updateItem.indexPathBeforeUpdate];
//    //        //                [self.indexPathsToAnimate addObject:updateItem.indexPathAfterUpdate];
//    //        //                break;
//    //        //            default:
//    //        //                NSLog(@"unhandled case: %@", updateItem);
//    //        //                break;
//    //        //        }
//    //        //    }
//    //        //
//    //        //    NSLog(@"_indexPathsToAnimate : %@", _indexPathsToAnimate);
//    //    }
//    
//    override func finalizeCollectionViewUpdates() {
//        // called inside an animation block after the update
//    }
//    
//    override func prepareForAnimatedBoundsChange(oldBounds: CGRect) {
//        // UICollectionView calls this when its bounds have changed inside an animation block before displaying cells in its new bounds
//    }
//    
//    override func finalizeAnimatedBoundsChange() {
//        // also called inside the animation block
//    }
//    
//    override func prepareForTransitionToLayout(newLayout: UICollectionViewLayout) {
//        // UICollectionView calls this when prior the layout transition animation on the incoming and outgoing layout
//    }
//    
//    override func prepareForTransitionFromLayout(oldLayout: UICollectionViewLayout) {
//    }
//    
//    override func finalizeLayoutTransition() {
//    }
//}