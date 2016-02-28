//
//  checkViewController.swift
//  secondMovies
//
//  Created by 高城晃一 on 2016/02/24.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class checkViewController: UIViewController {
    
    // 再生用のアイテム.
    var playerItem : AVPlayerItem!
    
    // AVPlayer.
    var videoPlayer : AVPlayer!
    
    // シークバー.
    var seekBar : UISlider!
    
    let cameraEngine = CameraEngine()
    
    
    @IBOutlet weak var videoPlayerView: AVPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var filePath:NSURL = self.cameraEngine.filePathUrl()
        
        // パスからassetを生成.
        //let path = NSBundle.mainBundle().pathForResource("test", ofType: "mov")
        //print(path)
        //let fileURL = NSURL(fileURLWithPath: path!)
        print(filePath)
        let avAsset = AVURLAsset(URL: filePath, options: nil)
        print(avAsset)
        
        // AVPlayerに再生させるアイテムを生成.
        playerItem = AVPlayerItem(asset: avAsset)
        
        // AVPlayerを生成.
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        // Viewを生成.
        //let videoPlayerView = AVPlayerView(frame: self.view.bounds)
        
        // UIViewのレイヤーをAVPlayerLayerにする.
        let layer = videoPlayerView.layer as! AVPlayerLayer
        layer.videoGravity = AVLayerVideoGravityResizeAspect
        layer.player = videoPlayer
        
        // レイヤーを追加する.
        //self.view.layer.addSublayer(layer)
        
        
        // 動画のシークバーとなるUISliderを生成.
        seekBar = UISlider(frame: CGRectMake(0, 0, self.view.bounds.maxX - 100, 50))
        seekBar.layer.position = CGPointMake(self.view.bounds.midX, self.view.bounds.maxY - 100)
        seekBar.minimumValue = 0
        seekBar.maximumValue = Float(CMTimeGetSeconds(avAsset.duration))
        seekBar.addTarget(self, action: "onSliderValueChange:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(seekBar)
        
        
        /*
        シークバーを動画とシンクロさせる為の処理.
        */
        
        // 0.5分割で動かす事が出来る様にインターバルを指定.
        let interval : Double = Double(0.5 * seekBar.maximumValue) / Double(seekBar.bounds.maxX)
        
        // CMTimeに変換する.
        let time : CMTime = CMTimeMakeWithSeconds(interval, Int32(NSEC_PER_SEC))
        
        //TODO:エラーが出るところ
        // time毎に呼び出される.
        videoPlayer.addPeriodicTimeObserverForInterval(time, queue: nil) { (time) -> Void in
            
            // 総再生時間を取得.
            let duration = CMTimeGetSeconds(self.videoPlayer.currentItem!.duration)
            
            // 現在の時間を取得.
            let time = CMTimeGetSeconds(self.videoPlayer.currentTime())
            
            // シークバーの位置を変更.
            let value = Float(self.seekBar.maximumValue - self.seekBar.minimumValue) * Float(time) / Float(duration) + Float(self.seekBar.minimumValue)
            self.seekBar.value = value
        }
        
        // 動画の再生ボタンを生成.
        let startButton = UIButton(frame: CGRectMake(0, 0, 50, 50))
        startButton.layer.position = CGPointMake(self.view.bounds.midX, self.view.bounds.maxY - 50)
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 20.0
        startButton.backgroundColor = UIColor.orangeColor()
        startButton.setTitle("Start", forState: UIControlState.Normal)
        startButton.addTarget(self, action: "onButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(startButton)
    }
    
    // 再生ボタンが押された時に呼ばれるメソッド.
    func onButtonClick(sender : UIButton){
        
        // 再生時間を最初に戻して再生.
        videoPlayer.seekToTime(CMTimeMakeWithSeconds(0, Int32(NSEC_PER_SEC)))
        videoPlayer.play()
        
    }
    
    // シークバーの値が変わった時に呼ばれるメソッド.
    func onSliderValueChange(sender : UISlider){
        
        // 動画の再生時間をシークバーとシンクロさせる.
        videoPlayer.seekToTime(CMTimeMakeWithSeconds(Float64(seekBar.value), Int32(NSEC_PER_SEC)))
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
