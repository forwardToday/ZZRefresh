//
//  ZZRefreshHeaderView.swift
//  EasyLife
//
//  Created by jerry on 15/12/22.
//  Copyright © 2015年 zz. All rights reserved.
//

import UIKit

enum ZZRefreshState {
    case Pulling
    case Normal
    case Refreshing
    case WillRefreshing
}

typealias ZZRefreshChangeClosure = (toState: ZZRefreshState)->Void
let ZZRecveryAnimationTime: NSTimeInterval = 0.3

class ZZRefreshHeaderView: UIView {

    //MARK:kit property
    private let ZZRefreshContentOffset =  "contentOffset"
    var scrollView:UIScrollView!
    var scrollViewOriginalInset:UIEdgeInsets!
    var scrollViewOriginOffset:CGPoint!
    
    var didChangeClosure: ZZRefreshChangeClosure?
    var willChangeClosure: ZZRefreshChangeClosure?
    var normalView = ZZNormalView()
    var state = ZZRefreshState.Normal {
        willSet {
            self.willChangeClosure?(toState: newValue)
        }
        
        didSet{
            switch state {
            case .Pulling:
                normalView.setTitle("下拉进行刷新")
//                print("Pulling Pulling Pulling Pulling!!!!")
                self.scrollViewOriginalInset = self.scrollView.contentInset
                
            case .Refreshing:
                normalView.setTitle("正在刷新...")
                normalView.startAnimating()
                UIView.animateWithDuration(ZZRecveryAnimationTime, animations: {
                    let top = self.scrollView.contentInset.top + self.frame.size.height
                    var inset:UIEdgeInsets = self.scrollView.contentInset
                    inset.top = top
                    self.scrollView.contentInset = inset
                    var offset:CGPoint = self.scrollView.contentOffset
                    offset.y = -top
                    self.scrollView.contentOffset = offset
                })
            case .Normal:
//                print("Normal!!!!!!!!!!")
                normalView.stopAnimating()
//                normalView.setTitle("正在刷新")
                UIView.animateWithDuration(ZZRecveryAnimationTime, animations: { () -> Void in
                    var contentInset = self.scrollView.contentInset
                    contentInset.top = self.scrollViewOriginalInset.top
                    self.scrollView.contentInset = contentInset
                })
            case .WillRefreshing:
                normalView.setTitle("松开进行刷新")
//                print("WillRefreshing !!!!!!!!!!!!")
            }
            
            self.didChangeClosure!(toState: state)
        }
    }
    
    //MARK:init 
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:public APIs
    func setSatate(state: ZZRefreshState) {
        if self.state == state {return}
        else {self.state = state}
    }
    
    func stateDidChange(change: ZZRefreshChangeClosure) {
        didChangeClosure = change
    }
    
    func stateWillChange(change: ZZRefreshChangeClosure) {
        willChangeClosure = change
    }
    
    func isRefreshing()->Bool {
        return state == ZZRefreshState.Refreshing
    }
    
    func beginRefreshing() {
        if self.isRefreshing() {return}
        
        if self.window != nil {
            state = ZZRefreshState.Refreshing
        }else {
            state = ZZRefreshState.WillRefreshing;
            super.setNeedsDisplay()
        }
    }
    
    func endRefreshing() {
        state = ZZRefreshState.Normal
    }
    
    //MARK:private functions
    func updateState() {
        let currentOffsetY = -scrollView.contentOffset.y
        let happenOffsetY  = scrollView.contentInset.top //something may cause scrollViewOriginalInset change,like UINavgationBar
        let refreshHeight = self.frame.size.height
        if self.scrollView.dragging {
            let normalPull = happenOffsetY + refreshHeight
            if state != .Pulling && currentOffsetY <= normalPull && currentOffsetY > happenOffsetY{
                state = .Pulling
            }else if state != .WillRefreshing && currentOffsetY >= normalPull {
                state = .WillRefreshing
            }
        } else{
            if state == .Pulling {
                state = .Normal
            } else if state == .WillRefreshing {
                state = .Refreshing
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        normalView.frame = self.bounds
        self.addSubview(normalView)
    }

    //MARK:KVO
    internal override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !userInteractionEnabled || self.hidden{return}
        if state == ZZRefreshState.Refreshing {return}
        
        if keyPath == ZZRefreshContentOffset {
            updateState()
        }
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
       
        if (self.superview != nil) {
            self.superview?.removeObserver(self, forKeyPath: ZZRefreshContentOffset, context: nil)
        }
        
        if newSuperview == nil  { return }
        
        newSuperview!.addObserver(self, forKeyPath: ZZRefreshContentOffset, options: NSKeyValueObservingOptions.New, context: nil)

        var rect = self.frame
        rect.size.width = newSuperview!.frame.size.width
        rect.origin.x = 0
        rect.origin.y = -self.frame.size.height
        self.frame = rect;
        
        scrollView = newSuperview as! UIScrollView
    }

    
}



