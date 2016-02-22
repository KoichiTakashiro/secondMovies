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
    
    @IBOutlet weak var cameraBtn: UIButton!
    //var cameraStatus =
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraEngine.startup()
        
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session:self.cameraEngine.captureSession)
        
        //videoLayer.frame = CGRectMake(100, 100, 300, 300)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        
        self.setupButton()
        
        //タイマーを作る.
        //var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    func update() {
        //timerLabel.text = "撮影時間→"+String(cnt)
        //cnt++
    }
    
    @IBAction func cameraBtnTap(sender: UIButton) {
        
    }
    
    func setupButton(){
        self.startButton = UIButton(frame: CGRectMake(0,0,60,50))
        self.startButton.backgroundColor = UIColor.redColor()
        self.startButton.layer.masksToBounds = true
        self.startButton.setTitle("start", forState: .Normal)
        self.startButton.layer.cornerRadius = 20.0
        self.startButton.layer.position = CGPoint(x: self.view.bounds.width/5, y:self.view.bounds.height-50)
        self.startButton.addTarget(self, action: "onClickStartButton:", forControlEvents: .TouchUpInside)
        
        self.stopButton = UIButton(frame: CGRectMake(0,0,60,50))
        self.stopButton.backgroundColor = UIColor.grayColor()
        self.stopButton.layer.masksToBounds = true
        self.stopButton.setTitle("stop", forState: .Normal)
        self.stopButton.layer.cornerRadius = 20.0
        self.stopButton.layer.position = CGPoint(x: self.view.bounds.width/5 * 2, y:self.view.bounds.height-50)
        self.stopButton.addTarget(self, action: "onClickStopButton:", forControlEvents: .TouchUpInside)
        
        self.pauseResumeButton = UIButton(frame: CGRectMake(0,0,60,50))
        self.pauseResumeButton.backgroundColor = UIColor.grayColor()
        self.pauseResumeButton.layer.masksToBounds = true
        self.pauseResumeButton.setTitle("pause", forState: .Normal)
        self.pauseResumeButton.layer.cornerRadius = 20.0
        self.pauseResumeButton.layer.position = CGPoint(x: self.view.bounds.width/5 * 3, y:self.view.bounds.height-50)
        self.pauseResumeButton.addTarget(self, action: "onClickPauseButton:", forControlEvents: .TouchUpInside)
        
        
        //結合用
        self.mergeButton = UIButton(frame: CGRectMake(0,0,60,50))
        self.mergeButton.backgroundColor = UIColor.grayColor()
        self.mergeButton.layer.masksToBounds = true
        self.mergeButton.setTitle("merge", forState: .Normal)
        self.mergeButton.layer.cornerRadius = 20.0
        self.mergeButton.layer.position = CGPoint(x: self.view.bounds.width/5 * 4, y:self.view.bounds.height-50)
        self.mergeButton.addTarget(self, action: "onClickPauseButton:", forControlEvents: .TouchUpInside)
        
        
        self.view.addSubview(self.startButton)
        self.view.addSubview(self.stopButton)
        self.view.addSubview(self.pauseResumeButton)
        self.view.addSubview(self.mergeButton)
        
    }
    
    func onClickStartButton(sender: UIButton){
        if !self.cameraEngine.isCapturing {
            self.cameraEngine.start()
            self.changeButtonColor(self.startButton, color: UIColor.grayColor())
            self.changeButtonColor(self.stopButton, color: UIColor.redColor())
        }
    }
    
    func onClickPauseButton(sender: UIButton){
        if self.cameraEngine.isCapturing {
            if self.cameraEngine.isPaused {
                self.cameraEngine.resume()
                self.pauseResumeButton.setTitle("pause", forState: .Normal)
                self.pauseResumeButton.backgroundColor = UIColor.grayColor()
            }else{
                self.cameraEngine.pause()
                self.pauseResumeButton.setTitle("resume", forState: .Normal)
                self.pauseResumeButton.backgroundColor = UIColor.blueColor()
            }
        }
    }
    
    func onClickStopButton(sender: UIButton){
        if self.cameraEngine.isCapturing {
            self.cameraEngine.stop()
            self.changeButtonColor(self.startButton, color: UIColor.redColor())
            self.changeButtonColor(self.stopButton, color: UIColor.grayColor())
        }
    }
    
    func changeButtonColor(target: UIButton, color: UIColor){
        target.backgroundColor = color
    }
}
