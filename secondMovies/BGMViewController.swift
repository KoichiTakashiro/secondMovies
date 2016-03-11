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
import GoogleMobileAds

class BGMViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    let cameraEngine = CameraEngine()
    @IBOutlet weak var addNoMusicBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addNoMusicBtn.layer.cornerRadius = 5
        
        self.bannerView.adUnitID = "ca-app-pub-3821570843157346/8382168516"
        self.bannerView.rootViewController = self
        self.bannerView.loadRequest(GADRequest())
    }
    @IBOutlet weak var playbackBtn: UIButton!
    @IBOutlet weak var addMusicBtn: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    
    
    var playingMusic:Int?

    @IBOutlet weak var bannerView: GADBannerView!
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //BGMを追加せずに動画を保存
    @IBAction func addNoMusicBtnTap(sender: UIButton) {
        if isPlaying == false {
            addNoMusic()
        }else{
            musicPlayer.stop()
            addNoMusic()
        }
    }
    
    func addNoMusic(){
        let assetsLib = ALAssetsLibrary()
        let filePathUrl:NSURL = cameraEngine.filePathUrl()
        print(filePathUrl)
        
        assetsLib.writeVideoAtPathToSavedPhotosAlbum(filePathUrl, completionBlock: {
            (nsurl, error) -> Void in
            Logger.log("Transfer video to library finished.")
            print("ファイルインデックスは\(self.cameraEngine.fileIndex)")
            print("BGMなしでカメラロールに保存")
            //self.deleteFiles()
            let movieFilePath = self.cameraEngine.filePath()
            let manager = NSFileManager()
            if movieFilePath != "" {
                do {
                    try manager.removeItemAtPath(movieFilePath)
                    print("documents内のファイル削除")
                    var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "shareViewController" )
                    self.presentViewController( targetView as! UIViewController, animated: true, completion: nil)
                    
                    
                } catch {
                    print(error)
                }
            }
        })

    }
    
    var musicList:[NSDictionary] =
    [
        ["name":"万能型", "fileName":"goodmorningsky short"],
        ["name":"ボス戦風", "fileName":"pinch"],
        ["name":"Bar風", "fileName":"jazz2"],
        ["name":"アイドル風", "fileName":"idol"],
        ["name":"旅立ち風", "fileName":"positive"],
        ["name":"黄昏時風", "fileName":"natural"],
        //["name":"newspace", "fileName":"newspace"],落ちる
        ["name":"IT企業CM風", "fileName":"hero"],
        //["name":"wild", "fileName":"wild"]落ちる
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
        //playbackBtn.setTitle("再生", forState: .Normal)
        let image = UIImage(named: "musicPlay")! as UIImage
        playbackBtn.setImage(image, forState: .Normal)
        playbackBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playbackBtn.tag = 100 + indexPath.row + 1
        var addMusicBtn = cell.viewWithTag(3) as! UIButton
        addMusicBtn.setTitle("決定", forState: .Normal)
        addMusicBtn.tag = 200 + indexPath.row + 1
        addMusicBtn.backgroundColor = UIColor(red: 245/255, green: 108/255, blue: 102/255, alpha: 1)
        tableView.scrollEnabled = false
        addMusicBtn.layer.cornerRadius = 5
        addMusicBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)

        return cell
    }
    
    //選択された時に行う処理
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath.row)行目を選択")
    }
    
    //segueで遷移するとき
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

    //BGM再生の準備
    var musicPlayer:AVAudioPlayer!
    var isPlaying = false

    @IBAction func soundBtnTap(sender: UIButton) {
        var musicName = musicList[sender.tag-101]["fileName"] as! String
        print("選択した音楽は\(musicList[sender.tag-101]["name"])")
        if isPlaying == false {
            //初回再生時と正常に停止した後
            playingMusic = sender.tag
            let music_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicName, ofType: "mp3")!)
            
            do {
                //動作部分
                musicPlayer = try AVAudioPlayer(contentsOfURL: music_data)
                musicPlayer.play()
                var btn = myTableView.viewWithTag(self.playingMusic!) as! UIButton
                let image = UIImage(named: "stopPlaying")! as UIImage
                btn.setImage(image, forState: .Normal)
                btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
                isPlaying = true
            }catch let error as NSError {
                //エラーをキャッチした場合
                print(error)
            }
            
            //        bgmPlay()
            print("サンプル音再生")
            print("再生ボタンタップ")
        } else {
            if sender.tag == playingMusic {
                musicPlayer.stop()
                var btn = myTableView.viewWithTag(self.playingMusic!) as! UIButton
                let image = UIImage(named: "musicPlay")! as UIImage
                btn.setImage(image, forState: .Normal)
                btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
                isPlaying = false
            } else {
                //再生中に他の曲流すとここ
                var btn = myTableView.viewWithTag(self.playingMusic!) as! UIButton
                let image = UIImage(named: "musicPlay")! as UIImage
                btn.setImage(image, forState: .Normal)
                btn.setTitleColor(UIColor.blackColor(), forState: .Normal)

                //playingMusic = sender.tag
                let music_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicName, ofType: "mp3")!)
                do {
                    //動作部分
                    musicPlayer = try AVAudioPlayer(contentsOfURL: music_data)
                    musicPlayer.play()
                    var btn = myTableView.viewWithTag(sender.tag) as! UIButton
                    let image = UIImage(named: "stopPlaying")! as UIImage
                    btn.setImage(image, forState: .Normal)
                    btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    isPlaying = true
                    playingMusic = sender.tag
                }catch let error as NSError {
                    //エラーをキャッチした場合
                    print(error)
                }

            }
        }
            
    }
    
    @IBAction func addMusicBtnTap(sender: UIButton) {
        var audioURL:NSURL
        var moviePathUrl:NSURL
        var savePathUrl:NSURL
        var musicName = musicList[sender.tag-201]["fileName"] as! String
        print("musicNameは\(musicName)")
        
        audioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicName, ofType: "mp3")!)
        let movieFilePath = cameraEngine.filePath()
        moviePathUrl = cameraEngine.filePathUrl()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String = "\(documentsDirectory)/videoWithBGM\(cameraEngine.fileIndex).mp4"
        savePathUrl = NSURL(fileURLWithPath: filePath)
        
        print(moviePathUrl)
        print(savePathUrl)
        
        if isPlaying == false {
            mergeAudio(audioURL, moviePathUrl: moviePathUrl, savePathUrl: savePathUrl)
        } else {
            musicPlayer.stop()
            mergeAudio(audioURL, moviePathUrl: moviePathUrl, savePathUrl: savePathUrl)
            
        }        
        print("ファイルマージしたつもり")
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        print("タイマー呼び出したはず")
    }
    
    func deleteFiles() {
        let movieFilePath = cameraEngine.filePath()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String = "\(documentsDirectory)/videoWithBGM\(cameraEngine.fileIndex).mp4"

        let manager = NSFileManager()
        
        if movieFilePath != "" && filePath != "" {
            do {
                try manager.removeItemAtPath(movieFilePath)
                try manager.removeItemAtPath(filePath)
                print("documents内のファイル削除")
                
            } catch let error as NSError {
                print("error")
            }
        }

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
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.exportAsynchronouslyWithCompletionHandler({
            switch assetExport.status{
            case  AVAssetExportSessionStatus.Failed:
                print("failed \(assetExport.error)")
            case AVAssetExportSessionStatus.Cancelled:
                print("cancelled \(assetExport.error)")
            default:
                print("complete")
                let assetsLib = ALAssetsLibrary()
                assetsLib.writeVideoAtPathToSavedPhotosAlbum(savePathUrl, completionBlock: {
                    (nsurl, error) -> Void in
                    Logger.log("Transfer video to library finished.")
                    print("BGMありの特定のビデオをカメラロールに保存")
                    self.deleteFiles()
                })
                
            }

        print("ファイルマージ最後までいった")
        print("\(self.cameraEngine.fileIndex)")
        })

        
    }
    
    func moveToShare(){
        var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "shareViewController" )
        self.presentViewController( targetView as! UIViewController, animated: true, completion: nil)
    }
    //タイマーの作成
    var timerLabel: UILabel!
    var timer : NSTimer!
    var cnt : Float = 0.00
    var secCnt : Float = 0.00
    var writingLabel: UILabel!
    var status = "notWriting"
    
    func update() {
        if cnt == 300{
            moveToShare()
            print("時間が来た")
            timer.invalidate()
        }else if status != "writing" {
            self.writingLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.width,200))
            self.writingLabel.text = "書き出し中。少々お待ち下さい！"
            self.writingLabel.textAlignment = NSTextAlignment.Center
            self.writingLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.writingLabel.textColor = UIColor.whiteColor()
            self.writingLabel.font = UIFont.systemFontOfSize(20)
            //self.recordLabel.frame = CGRectMake(0,0,300,100)
            self.writingLabel.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2)
            self.view.addSubview(self.writingLabel)
            print("書き出し中")
            status = "writing"
            cnt++
        }else {
            cnt++
        }
    }

}
