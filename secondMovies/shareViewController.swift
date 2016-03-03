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

class shareViewController: UIViewController {
    
    let cameraEngine = CameraEngine()
    var myComposeView : SLComposeViewController!
    var topBtn : UIButton!
    var videoWriter : VideoWriter?
    var filePath = ""
    var firstFilePath = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveBtnTap(sender: UIButton) {
//        let assetsLib = ALAssetsLibrary()
//        
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let documentsDirectory = paths[0] as String
//        filePath = "\(documentsDirectory)/videoWithBGM\(cameraEngine.fileIndex).mp4"
//        let fileURL : NSURL = NSURL(fileURLWithPath: filePath)
//        let savePathUrl:NSURL = NSURL(fileURLWithPath: filePath)
//        print(savePathUrl)
//        
//        //assetsLib.videoAtPathIsCompatibleWithSavedPhotosAlbum(savePathUrl)
//        //print("videoAtPathIsCompatibleWithSavedPhotosAlbum発動！！")
//        
//        assetsLib.writeVideoAtPathToSavedPhotosAlbum(savePathUrl, completionBlock: {
//            (nsurl, error) -> Void in
//            Logger.log("Transfer video to library finished.")
//            //self.cameraEngine.fileIndex++
//            print("ファイルインデックスは\(self.cameraEngine.fileIndex)")
//            print("カメラロールに保存")
//            //self.deleteFiles()
//        })
//        
        
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
