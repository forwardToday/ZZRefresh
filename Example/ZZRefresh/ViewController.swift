//
//  ViewController.swift
//  ZZRefresh
//
//  Created by zz on 12/29/2015.
//  Copyright (c) 2015 zz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView?
    var rows: NSInteger = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ZZRefresh"
        let tableView = UITableView(frame: UIScreen.mainScreen().bounds)
        tableView.delegate    = self
        tableView.dataSource  = self
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
        self.tableView = tableView
        
        pullLoadData()
        loadMore()
    }


    func pullLoadData() {
        if let tableView = tableView {
            tableView.zz_pullToRefresh { [unowned self] () -> Void in
                print("正在刷新。。。。。")
                let delayInSeconds: Double = 1.0
                let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                    print("结束刷新。。。。。")
                    tableView.endRefreshing()
                    self.rows = 20
                    tableView.reloadData()
                })
            }
        }
    }
    
    func loadMore() {
        if let tableView = tableView {
            tableView.zz_loadMoreWhen(0.9, offsetMINButtom: 20) { [unowned self] () -> Void in
                print("加载更多")
                let delayInSeconds: Double = 1.0
                let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                    print("加载完成。。。。。")
                    self.rows = self.rows + 10
                    if self.rows >= 100 {
                        tableView.zz_noMoreData()
                        print("已经全部加载。。。。。")
                    }
                    tableView.reloadData()
                    tableView.zz_endloadMore()
                })
            }
        
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdenfier = "cellIdenfier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdenfier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdenfier)
        }
        
        cell?.textLabel?.text = "indexPath = \(indexPath.row)"
        cell?.backgroundColor = UIColor.brownColor()
        return cell!;
    }
    
}

