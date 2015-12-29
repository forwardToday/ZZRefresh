//
//  UIScrollView+LoadMore.swift
//  EasyLife
//
//  Created by qz on 15/12/22.
//  Copyright © 2015年 zz. All rights reserved.
//

import UIKit

typealias ZZEmptyClosure = ()->Void

private var ZZIsLoadingMore = false
private var ZZMINOffsetYRatio: CGFloat = 9.0
private var ZZMINOffsetY: CGFloat = 0
private var ZZLoadMoreClosure: ZZEmptyClosure = {}
private var ZZIsHaveMoreData = false
private let ZZRefreshContentOffset =  "contentOffset"
var AssociatedObjectHandle: UInt8 = 0

extension UIScrollView {
    
    private var isLoadingMore: Bool {
        get {
            return ZZIsLoadingMore
        }
        set {
            ZZIsLoadingMore = newValue
        }
    }
    private var offsetYMINRatio: CGFloat {
        get {
            return ZZMINOffsetYRatio
        }
        set {
            ZZMINOffsetYRatio = newValue
        }
    }
    private var offsetMINButtom: CGFloat {
        get {
            return ZZMINOffsetY
        }
        set {
            ZZMINOffsetY = newValue
        }
    }
    private var loadMoreClosure: ZZEmptyClosure{
        get {
            return ZZLoadMoreClosure
        }
        set {
            ZZLoadMoreClosure = newValue
        }
    }
    private var isHaveMoreData: Bool {
        get {
            return ZZIsHaveMoreData
        }
        set {
            ZZIsHaveMoreData = newValue
        }
    }

    public func zz_loadMoreWhen(OffsetYRatio: CGFloat, loadMore: ()->Void) {
        offsetYMINRatio = OffsetYRatio
        loadMoreClosure = loadMore
        offsetMINButtom = 0
        isLoadingMore = false
        isHaveMoreData = true
        self.addObserver(self, forKeyPath: ZZRefreshContentOffset, options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    public func zz_loadMoreWhen(MinOffsetYRatio: CGFloat ,offsetMINButtom: CGFloat, loadMore: ()->Void) {
        offsetYMINRatio = MinOffsetYRatio
        loadMoreClosure = loadMore
        isLoadingMore = false
        isHaveMoreData = true
        self.offsetMINButtom = offsetMINButtom
        self.addObserver(self, forKeyPath: ZZRefreshContentOffset, options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    //MARK:KVO
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        zzloadMore()
    }

    public func zzloadMore() {
        if isLoadingMore || !isHaveMoreData{ return }
        if self.contentSize.height == 0 { return }
        
        let ratio = (self.contentOffset.y + self.frame.size.height) / (self.contentSize.height)
        let bottomOffset = self.contentSize.height - self.contentOffset.y - self.frame.size.height
//        print("===========")
//        print(self.contentSize.height)
//        print(self.contentInset.top)
//        print(self.contentOffset.y)
//        print(self.frame.size.height)
//        print("===========")
//        print(ratio)
//        print(bottomOffset)
        if ratio > offsetYMINRatio && bottomOffset > offsetMINButtom{
            isLoadingMore = true
            loadMoreClosure()
        }
    }
    
    public func zz_endloadMore() {
        isLoadingMore = false
    }
    
    public func zz_noMoreData() {
        isHaveMoreData = false
    }
}

