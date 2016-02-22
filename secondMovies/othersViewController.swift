//
//  othersViewController.swift
//  secondMovies
//
//  Created by 高城晃一 on 2016/02/22.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit

class othersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var menu:[NSDictionary] = [
        ["name":"アプリバージョン","detail":"ご使用中のアプリはバージョン1.0です"],
        ["name":"利用規約","detail":"特に規約は定めておりません。お客様自身でモラルについてしっかり考えた上でご使用お願い致します。"]
    ]
    
    var slectedIndex = -1
    var selectedDetail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    //表示するセルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "myCell")
        cell.textLabel?.text = menu[indexPath.row]["name"] as! String
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    //選択された時に行う処理
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        slectedIndex = indexPath.row
        selectedDetail = menu[indexPath.row]["detail"] as! String
        performSegueWithIdentifier("showDetailView", sender: nil)
    }
    
    //何行目が選択されたかの情報を受け渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailVC = segue.destinationViewController as! detailViewController
        detailVC.recievedSelectedIndex = slectedIndex
        detailVC.recievedSerectedDetail = selectedDetail
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
