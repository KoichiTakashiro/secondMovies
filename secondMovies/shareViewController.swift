//
//  shareViewController.swift
//  secondMovies
//
//  Created by 高城晃一 on 2016/02/24.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit
import Social

class shareViewController: UIViewController {
    
    let cameraEngine = CameraEngine()
    var myComposeView : SLComposeViewController!
    var topBtn : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveBtnTap(sender: UIButton) {
        cameraEngine.save()
        print("shareページで保存")
    }
    
    
    @IBAction func twitterBtnTap(sender: UIButton) {
        // SLComposeViewControllerのインスタンス化.
        // ServiceTypeをTwitterに指定.
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        // 投稿するテキストを指定.
        myComposeView.setInitialText("ショートムービー作ったよ")
        
        // 投稿する画像を指定.
        myComposeView.addImage(UIImage(named: "oouchi.jpg"))
        
        // myComposeViewの画面遷移.
        self.presentViewController(myComposeView, animated: true, completion: nil)
    }

    @IBAction func FBBtnTap(sender: UIButton) {
        // ServiceTypeをFacebookに指定.
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        
        // 投稿するテキストを指定.
        myComposeView.setInitialText("I Made a Short Movie")
        
        // 投稿する画像を指定.
//        myComposeView.addImage(UIImage(named: "sample1.jpg"))
        //myComposeView.add
        
        // myComposeViewの画面遷移.
        self.presentViewController(myComposeView, animated: true, completion: nil)
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
