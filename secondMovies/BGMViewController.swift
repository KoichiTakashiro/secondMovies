//
//  BGMViewController.swift
//  secondMovies
//
//  Created by 高城晃一 on 2016/03/01.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

class BGMViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    let cameraEngine = CameraEngine()
    var index:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var playbackBtn: UIButton!
    @IBOutlet weak var addMusicBtn: UIButton!

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var musicList:[NSDictionary] =
    [
        ["name":"battle", "fileName":"battle"],
        ["name":"jazz", "fileName":"jazz"]
        
    ]
    
    //テーブルビュー関連
    //行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    
    // セルの選択を禁止する
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil;
    }
    
    
    //表示するセルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell") as! UITableViewCell!
        var musicLabel = cell.viewWithTag(1) as! UILabel
        musicLabel.text = musicList[indexPath.row]["name"] as! String
        var playbackBtn = cell.viewWithTag(2) as! UIButton
        playbackBtn.setTitle("再生", forState: .Normal)
        playbackBtn.tag = 100 + indexPath.row + 1
        var addMusicBtn = cell.viewWithTag(3) as! UIButton
        addMusicBtn.setTitle("決定", forState: .Normal)
        addMusicBtn.tag = 100 + indexPath.row + 1

        return cell
    }
    
    //選択された時に行う処理
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath.row)行目を選択")
//        selectedIndex = indexPath.row
//        performSegueWithIdentifier("showSecondView", sender: nil)
    }
    
    //segueで遷移するとき
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var secondVC = segue.destinationViewController as! secondViewController
//        secondVC.scSelectedIndex = selectedIndex
    }

    //BGMの準備
    var musicPlayer:AVAudioPlayer!
    // 再生するmusicファイルのパスを取得  今回は[music.mp3]
    
    @IBAction func soundBtnTap(sender: UIButton) {
        print("sender.tagは：\(sender.tag)")
        
        var musicName = musicList[sender.tag-101]["fileName"] as! String
        print("選択した音楽は\(musicList[sender.tag-101]["name"])")
        
        let music_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicName, ofType: "mp3")!)
        do {
            //動作部分
            musicPlayer = try AVAudioPlayer(contentsOfURL: music_data)
            musicPlayer.play()
        }catch let error as NSError {
            //エラーをキャッチした場合
            print(error)
        }
        
//        bgmPlay()
        print("サンプル音再生")
        print("再生ボタンタップ")
    }
//    func bgmPlay(musicName:String) {
//
//    }

    @IBAction func addMusicBtnTap(sender: UIButton) {
        var audioURL:NSURL
        var moviePathUrl:NSURL
        var savePathUrl:NSURL
        
        var musicName = musicList[sender.tag-101]["fileName"] as! String
        print("musicNnamehは\(musicName)")
        audioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicName, ofType: "mp3")!)
        moviePathUrl = cameraEngine.filePathUrl()
        //ここまで戻そう
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String = "\(documentsDirectory)/videoWithBGM\(cameraEngine.fileIndex).mp4"
        savePathUrl = NSURL(fileURLWithPath: filePath)
        
        print("ファイルパスまで取得")
        
        cameraEngine.fileIndex++
        print("ファイルインデックスは\(cameraEngine.fileIndex)")
        
        mergeAudio(audioURL, moviePathUrl: moviePathUrl, savePathUrl: savePathUrl)
        
        print("ファイルマージしたつもり")
        
        //        var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "shareViewController" )
        //        self.presentViewController( targetView as! UIViewController, animated: true, completion: nil)
        

    }
    
    func mergeAudio(audioURL: NSURL, moviePathUrl: NSURL, savePathUrl: NSURL) {
        var composition = AVMutableComposition()
        let trackVideo:AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        let trackAudio:AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        let option = NSDictionary(object: true, forKey: "AVURLAssetPreferPreciseDurationAndTimingKey")
        let sourceAsset = AVURLAsset(URL: moviePathUrl, options: option as! [String : AnyObject])
        let audioAsset = AVURLAsset(URL: audioURL, options: option as! [String : AnyObject])
        
        print(sourceAsset)
        print("playable: \(sourceAsset.playable)")
        print("exportable: \(sourceAsset.exportable)")
        print("readable: \(sourceAsset.readable)")
        print("audioURL:\(audioURL)")
        print("moviePathUrl:\(moviePathUrl)")
        print("savePathUrl:\(savePathUrl)")
        
        let tracks = sourceAsset.tracksWithMediaType(AVMediaTypeVideo)
        let audios = audioAsset.tracksWithMediaType(AVMediaTypeAudio)
        
        if tracks.count > 0 {
            print("trackカウントif文の中")
            let assetTrack:AVAssetTrack = tracks[0] as AVAssetTrack
            let assetTrackAudio:AVAssetTrack = audios[0] as AVAssetTrack
            
            let audioDuration:CMTime = assetTrackAudio.timeRange.duration
            let audioSeconds:Float64 = CMTimeGetSeconds(assetTrackAudio.timeRange.duration)
            print(audioSeconds)
            
            do{
                print("doの中")
                try trackVideo.insertTimeRange(CMTimeRangeMake(kCMTimeZero,audioDuration), ofTrack: assetTrack, atTime: kCMTimeZero)
                try trackAudio.insertTimeRange(CMTimeRangeMake(kCMTimeZero,audioDuration), ofTrack: assetTrackAudio, atTime: kCMTimeZero)

            }catch{
                print("error")
            }
            
        }
        
        var assetExport: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetMediumQuality)!
        assetExport.outputFileType = AVFileTypeQuickTimeMovie
        assetExport.outputURL = savePathUrl
        print(savePathUrl)
        //self.tmpMovieURL = savePathUrl
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.exportAsynchronouslyWithCompletionHandler({
            self.performSegueWithIdentifier("previewSegue", sender: self)
        print("ファイルマージ最後までいった")
        })
        
        
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
