//
//  recordViewController.swift
//  secondMovies
//
//  Created by 高城晃一 on 2016/02/22.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit
import AVFoundation

class recordViewController: UIViewController {

    var startButton, stopButton, pauseResumeButton, mergeButton: UIButton!
    var isRecording = false
    let cameraEngine = CameraEngine()
    @IBOutlet weak var timerLabel: UILabel!
    //時間計測用の変数.
    var cnt : Float = 0
    
    var cameraBtn, finishBtn: UIButton!
    var cameraStatus = "readyToStart"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraEngine.startup()
        
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session:self.cameraEngine.captureSession)
        
        //videoLayer.frame = CGRectMake(100, 100, 300, 300)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        //self.view.sendSubviewToBack(videoLayer)
        
        self.setupButton()
        
        //タイマーを作る.
        //var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    func update() {
        //timerLabel.text = "撮影時間→"+String(cnt)
        //cnt++
    }
    
//    @IBAction func cameraBtnTap(sender: UIButton) {
//        
//    }
    
    func setupButton(){
//        self.startButton = UIButton(frame: CGRectMake(0,0,60,50))
//        self.startButton.backgroundColor = UIColor.redColor()
//        self.startButton.layer.masksToBounds = true
//        self.startButton.setTitle("start", forState: .Normal)
//        self.startButton.layer.cornerRadius = 20.0
//        self.startButton.layer.position = CGPoint(x: self.view.bounds.width/5, y:self.view.bounds.height-50)
//        self.startButton.addTarget(self, action: "onClickStartButton:", forControlEvents: .TouchUpInside)
//        
//        self.stopButton = UIButton(frame: CGRectMake(0,0,60,50))
//        self.stopButton.backgroundColor = UIColor.grayColor()
//        self.stopButton.layer.masksToBounds = true
//        self.stopButton.setTitle("stop", forState: .Normal)
//        self.stopButton.layer.cornerRadius = 20.0
//        self.stopButton.layer.position = CGPoint(x: self.view.bounds.width/5 * 2, y:self.view.bounds.height-50)
//        self.stopButton.addTarget(self, action: "onClickStopButton:", forControlEvents: .TouchUpInside)
//        
//        self.pauseResumeButton = UIButton(frame: CGRectMake(0,0,60,50))
//        self.pauseResumeButton.backgroundColor = UIColor.grayColor()
//        self.pauseResumeButton.layer.masksToBounds = true
//        self.pauseResumeButton.setTitle("pause", forState: .Normal)
//        self.pauseResumeButton.layer.cornerRadius = 20.0
//        self.pauseResumeButton.layer.position = CGPoint(x: self.view.bounds.width/5 * 3, y:self.view.bounds.height-50)
//        self.pauseResumeButton.addTarget(self, action: "onClickPauseButton:", forControlEvents: .TouchUpInside)
        
        
        //カメラ撮影ボタン
        self.cameraBtn = UIButton(frame: CGRectMake(0,0,70,70))
        self.cameraBtn.backgroundColor = UIColor.greenColor()
        self.cameraBtn.layer.masksToBounds = true
        self.cameraBtn.setTitle("Go", forState: .Normal)
        self.cameraBtn.layer.cornerRadius = 15.0
        self.cameraBtn.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-30)
        self.cameraBtn.addTarget(self, action: "cameraBtnTap:", forControlEvents: .TouchUpInside)
        
        //録画をストップして次に進むボタン
        self.finishBtn = UIButton(frame: CGRectMake(0,0,70,70))
        self.finishBtn.backgroundColor = UIColor.blueColor()
        self.finishBtn.layer.masksToBounds = true
        self.finishBtn.setTitle("Finish", forState: .Normal)
        self.finishBtn.layer.cornerRadius = 0.0
        self.finishBtn.layer.position = CGPoint(x: self.view.bounds.width/5, y:self.view.bounds.height-30)
        self.finishBtn.addTarget(self, action: "finishBtnTap:", forControlEvents: .TouchUpInside)
        
        
        
//        self.view.addSubview(self.startButton)
//        self.view.addSubview(self.stopButton)
//        self.view.addSubview(self.pauseResumeButton)
//        self.view.addSubview(self.mergeButton)
        self.view.addSubview(self.cameraBtn)
        self.view.addSubview(self.finishBtn)
       
        
    }
    
    //カメラの撮影ボタンの挙動
    func cameraBtnTap(sender:UIButton){
        if cameraStatus == "readyToStart"{
            if !self.cameraEngine.isCapturing {
                self.cameraEngine.start()
                self.cameraBtn.setTitle("Stop", forState: .Normal)
                self.changeButtonColor(self.cameraBtn, color: UIColor.redColor())
                cameraStatus = "recording"
            }
        }else if cameraStatus == "recording"{
            print("if一個目")
            if self.cameraEngine.isCapturing {
                print("if2こめ")
                if self.cameraEngine.isPaused {
                    print("if3こめ")
                    self.cameraEngine.resume()
                    self.cameraBtn.setTitle("一時停止中", forState: .Normal)
                    self.cameraBtn.backgroundColor = UIColor.greenColor()
                }else{
                    print("if3こめのelse")
                    self.cameraEngine.pause()
                    self.cameraBtn.setTitle("resume", forState: .Normal)
                    self.cameraBtn.backgroundColor = UIColor.greenColor()
                }
            }
        }
    }
    
    //finishボタンタップ
    func finishBtnTap(sender:UIButton){
        if self.cameraEngine.isCapturing {
            self.cameraEngine.stop()
        }
        
    }
    
    
    
    
    
//    func onClickStartButton(sender: UIButton){
//        if !self.cameraEngine.isCapturing {
//            self.cameraEngine.start()
//            self.changeButtonColor(self.startButton, color: UIColor.grayColor())
//            self.changeButtonColor(self.stopButton, color: UIColor.redColor())
//        }
//    }
//    
//    func onClickPauseButton(sender: UIButton){
//        if self.cameraEngine.isCapturing {
//            if self.cameraEngine.isPaused {
//                self.cameraEngine.resume()
//                self.pauseResumeButton.setTitle("pause", forState: .Normal)
//                self.pauseResumeButton.backgroundColor = UIColor.grayColor()
//            }else{
//                self.cameraEngine.pause()
//                self.pauseResumeButton.setTitle("resume", forState: .Normal)
//                self.pauseResumeButton.backgroundColor = UIColor.blueColor()
//            }
//        }
//    }
//    
//    func onClickStopButton(sender: UIButton){
//        if self.cameraEngine.isCapturing {
//            self.cameraEngine.stop()
//            self.changeButtonColor(self.startButton, color: UIColor.redColor())
//            self.changeButtonColor(self.stopButton, color: UIColor.grayColor())
//        }
//    }
    
    func changeButtonColor(target: UIButton, color: UIColor){
        target.backgroundColor = color
    }
}
