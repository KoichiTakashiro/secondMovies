//
//  shareViewController.swift
//  secondMovies
//
//  Created by 高城晃一 on 2016/02/24.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit
import Social
import AVFoundation
import AssetsLibrary
import GoogleMobileAds

class shareViewController: UIViewController {
    
    let cameraEngine = CameraEngine()
    var myComposeView : SLComposeViewController!
    var topBtn : UIButton!
    var videoWriter : VideoWriter?
    var filePath = ""
    var firstFilePath = ""
    
    @IBOutlet weak var bannerView: GADBannerView!
    

    @IBOutlet weak var toTopBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        toTopBtn.backgroundColor = UIColor.whiteColor()
        toTopBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        toTopBtn.layer.cornerRadius = 5
        
        self.bannerView.adUnitID = "ca-app-pub-3821570843157346/1587258511"
        self.bannerView.rootViewController = self
        self.bannerView.loadRequest(GADRequest())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
}
