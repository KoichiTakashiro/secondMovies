//
//  soundAddViewController.swift
//  secondMovies
//
//  Created by 高城晃一 on 2016/03/01.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit
import AVFoundation

class soundAddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    let kVideoFPS = 30
//    func addSoundToMovie() {
//    
//        
//        //1
//        //今回は元動画の長さはそのままで、そこにBGMを追加するので開始時間とデュレーションは必要無い。
//        //不要な変数は混乱のもととなるので、削除してある。
//        var path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).objectAtIndex(0)
//        var inputPath = path.stringByAppendingPathComponent("portrait1").stringByAppendingPathExtension("mov")
//        var outputPath = path.stringByAppendingPathComponent("result").stringByAppendingPathExtension("mov")
//        var composition = AVMutableComposition.composition()
//        var compositionVideoTrack = composition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
//        var compositionAudioTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//        var error: NSError
//        var inputURL = NSURL.fileURLWithPath(inputPath)
//        var asset = AVURLAsset(uRL: inputURL, options: nil)
//        
//        //2
//        //出力動画の長さを変えないということは、元動画と出力動画の長さが同じということなので、CMTimeRange変数はrangeという一つに統一しておく。
//        var range = CMTimeRangeMake(kCMTimeZero, asset.duration)
//        var videoTrack = asset.tracksWithMediaType(AVMediaTypeVideo)[0]
//        var audioTrack = asset.tracksWithMediaType(AVMediaTypeAudio)[0]
//        
//        [compositionVideoTrack insertTimeRange:range ofTrack:videoTrack atTime:kCMTimeZero error:&error];
//        [compositionAudioTrack insertTimeRange:range ofTrack:audioTrack atTime:kCMTimeZero error:&error];
//        
//        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//        instruction.timeRange = range;
//        
//        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
//        
//        //3
//        //やっていることは以前の記事と基本的には同じだ。
//        //BGM用のアセットとトラックを準備して、追加しているだけである。
//        var soundPath = NSBundle.mainBundle().pathForResource("sound", ofType: "caf")
//        var soundURL = NSURL.fileURLWithPath(soundPath)
//        var soundAsset = AVURLAsset(uRL: soundURL, options: nil)
//        var soundTrack = soundAsset.tracksWithMediaType(AVMediaTypeAudio)[0]//assetからオーディオトラックを抜き出す。
//        var compositionSoundTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//        
//        [compositionSoundTrack insertTimeRange:range ofTrack:soundTrack atTime:kCMTimeZero error:&error];
//        
//        var videoSize = videoTrack.naturalSize
//        
//        CGAffineTransform transform = videoTrack.preferredTransform;;
//        if (transform.a == 0 && transform.d == 0 && (transform.b == 1.0 || transform.b == -1.0) && (transform.c == 1.0 || transform.c == -1.0))
//        {
//            videoSize = CGSizeMake(videoSize.height, videoSize.width);
//        }
//        
//        [layerInstruction setTransform:transform atTime:kCMTimeZero];
//        instruction.layerInstructions = @[layerInstruction];
//        
//        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
//        videoComposition.renderSize = videoSize;
//        videoComposition.instructions = @[instruction];
//        videoComposition.frameDuration = CMTimeMake(1, kVideoFPS);
//        
//        NSFileManager *fm = [NSFileManager defaultManager];
//        if ([fm fileExistsAtPath:outputPath])
//        {
//            [fm removeItemAtPath:outputPath error:&error];
//        }
//        
//        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
//        session.outputURL = [NSURL fileURLWithPath:outputPath];
//        session.outputFileType = AVFileTypeQuickTimeMovie;
//        session.videoComposition = videoComposition;
//        
//        [session exportAsynchronouslyWithCompletionHandler:^{
//            if (session.status == AVAssetExportSessionStatusCompleted)
//            {
//            NSLog(@"output complete!");
//            }
//            else
//            {
//            NSLog(@"output error! : %@", session.error);
//            }
//            }];
//        
//    }
//
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
