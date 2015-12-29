//
//  ZZNormalView.swift
//  EasyLife
//
//  Created by qz on 15/12/22.
//  Copyright © 2015年 zz. All rights reserved.
//

import UIKit

class ZZNormalView: UIView {

    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    let titleLabel = UILabel()
    
    //MARK:init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:public APIs
    func setTitle(title: String) {
        titleLabel.text = title
        updateLayoutSubViews()
        
    }
    
    func startAnimating() {
        indicatorView.startAnimating()
    }
    
    func stopAnimating() {
        indicatorView.stopAnimating()
    }
    
    //MARK:private functions
    func setupViews() {
        titleLabel.frame = CGRectMake(0, 0, 80, 21)
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textColor = UIColor.blackColor()
        self.addSubview(titleLabel)
        indicatorView.hidesWhenStopped = false
        indicatorView.frame = CGRectMake(0, 0, 15, 15)
        self.addSubview(indicatorView)
    }
    
    func updateLayoutSubViews() {
        if titleLabel.text == nil {return}
        let attributes: [String: AnyObject] = [NSFontAttributeName : titleLabel.font]
        let bounds = titleLabel.text!.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), self.frame.size.height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
        titleLabel.bounds = bounds
        titleLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
        
        let indicatorViewX = titleLabel.frame.origin.x - 25
        let indicatorViewY = self.bounds.size.height / 2
        indicatorView.center = CGPointMake(indicatorViewX, indicatorViewY)
    }

}
