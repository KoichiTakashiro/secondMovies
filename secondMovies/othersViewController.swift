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
        ["name":"アプリバージョン","detail":"ご使用中のアプリはバージョン 1.0 です"],
        ["name":"アプリの使い方","detail":"アプリの使用方法はたった4ステップ!\n\n１．アプリを立ち上げて動画アイコンをタップ\n\n２．２秒の動画を１５コマ撮影する。\n※アプリを落とすと撮影中の動画が消えてしまうので、動画をカメラロールに保存するまでは、常にバックグラウンドで起動しておいてください。\n\n３．３０秒（１５コマ分）の動画撮影が完了するとBGM選択画面に進みます。BGMを追加したい場合は、BGMを選択してください。\n動画撮影時のリアル音声で動画を作成したい場合は、「リアル音声で作成」ボタンをタップしてください。\n※BGMを選択した場合、動画撮影時の音声は消えてしましまいます。\n\n４．動画の作成が完了しました。カメラロールをチェックしましょう！"],
        ["name":"作者より","detail":"アプリをダンロードしていただきまして誠にありがとうございます。\n本アプリは気に入っていただけましたでしょうか？？\n私自身まだまだ駆け出しエンジニアのため、改善の余地はたくさんありますが、記念すべき1作目のアプリです。\n今後も皆様にご利用いただけるアプリをどんどん生み出していきますのでよろしくお願いします！！\n応援メッセージお待ちしております〜"],
        ["name":"メッセージを送る","detail":"サービス改善のため、ご意見ご要望お待ちしております！\n\nお問い合わせ、メッセージはこちらまで。\n\nsecondmovies2016@gmail.com"]
    ]
    
    var slectedIndex = -1
    var selectedDetail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
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
