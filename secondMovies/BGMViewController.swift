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

class BGMViewController: UIViewController {
    
    let cameraEngine = CameraEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func soundBtnTap(sender: UIButton) {
        bgmPlay()
        print("サンプル音再生")
    }
    
    @IBAction func addBtnTap(sender: UIButton) {
        var audioURL:NSURL
        var moviePathUrl:NSURL
        var savePathUrl:NSURL
        
        audioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("drumroll", ofType: "mp3")!)
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
    
    //BGMの準備
    var musicPlayer:AVAudioPlayer!
    // 再生するmusicファイルのパスを取得  今回は[music.mp3]
    let music_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("drumroll", ofType: "mp3")!)

    
    func bgmPlay() {
        do {
            //動作部分
            musicPlayer = try AVAudioPlayer(contentsOfURL: music_data)
            musicPlayer.play()
        }catch let error as NSError {
            //エラーをキャッチした場合
            print(error)
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
