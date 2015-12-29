//
//  UIScrollView+Refresh.swift
//  EasyLife
//
//  Created by jerry on 15/12/22.
//  Copyright © 2015年 zz. All rights reserved.
//

import UIKit

private var ZZRefreshHeaderViewKeys = ZZRefreshHeaderView()
let RefreshViewHeight: CGFloat = 44

extension UIScrollView {
    //MARK:property
    var headerView: ZZRefreshHeaderView! {
        get {
            return objc_getAssociatedObject(self, &ZZRefreshHeaderViewKeys) as? ZZRefreshHeaderView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &ZZRefreshHeaderViewKeys, newValue as ZZRefreshHeaderView?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    //MARK:public APIs
    public func zz_pullToRefresh(callBack: ()->Void) {
        let headerView = ZZRefreshHeaderView(frame: CGRectMake(0, 0, self.bounds.size.width, RefreshViewHeight))
        self.addSubview(headerView)
        headerView.setSatate(ZZRefreshState.Normal)
        self.headerView = headerView
        headerView.stateDidChange { (toState) -> Void in
            if toState == ZZRefreshState.Refreshing {
                callBack()
            }
        }
    }
    
    public func endRefreshing() {
        headerView.endRefreshing()
    }

}