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
    var recordLabel: UILabel!
    var isRecording = false
    let cameraEngine = CameraEngine()

    //カメラボタンの作成
    var cameraBtn, finishBtn: UIButton!
    var cameraStatus = "readyToStart"
    
    //タイマーの作成
    var timerLabel: UILabel!
    var timer : NSTimer!
    var cnt : Float = 0.00
    var secCnt : Float = 0.00
    
    //スライダーの設置
    let myGreenSlider = UISlider(frame: CGRectMake(0, 0, 300, 10))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションの再表示
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.cameraEngine.startup()
        
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session:self.cameraEngine.captureSession)
        //videoLayer.frame = CGRectMake(100, 100, 300, 300)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        //self.view.sendSubviewToBack(videoLayer)
        
        //ボタンの配置
        self.setupButton()
        
        //タイマー配置
        self.setupTimerLabel()
        
        //プログレス設置
        self.setupSlider()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        var myDefault = NSUserDefaults.standardUserDefaults()
        cnt = myDefault.floatForKey("defaultCnt")
        timerLabel.text = timerLabel.text
    }
    
    func setupButton(){
        
        //カメラ撮影ボタン
        self.cameraBtn = UIButton(frame: CGRectMake(0,0,70,70))
        //self.cameraBtn.backgroundColor = UIColor.greenColor()
        self.cameraBtn.layer.masksToBounds = true
        //self.cameraBtn.setTitle("Go", forState: .Normal)
        //self.cameraBtn.layer.cornerRadius = 15.0
        self.cameraBtn.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-40)
        self.cameraBtn.addTarget(self, action: "cameraBtnTap:", forControlEvents: .TouchUpInside)
        let image = UIImage(named: "record")! as UIImage
        self.cameraBtn.setImage(image, forState: .Normal)
        
        //録画をストップして次に進むボタン
        self.finishBtn = UIButton(frame: CGRectMake(0,0,70,70))
        self.finishBtn.backgroundColor = UIColor.blueColor()
        self.finishBtn.layer.masksToBounds = true
        self.finishBtn.setTitle("Finish", forState: .Normal)
        //self.finishBtn.layer.cornerRadius = 0.0
        self.finishBtn.layer.position = CGPoint(x: self.view.bounds.width/4, y:self.view.bounds.height-30)
        self.finishBtn.addTarget(self, action: "finishBtnTap:", forControlEvents: .TouchUpInside)
        
        
        //Viewにボタンを追加
        self.view.addSubview(self.cameraBtn)
        self.view.addSubview(self.finishBtn)
    }
    
    func setupRecordLabel() {
        //録画中ラベルの表示
        self.recordLabel = UILabel(frame: CGRectMake(0,0,170,80))
        self.recordLabel.text = "● 録画中"
        self.recordLabel.backgroundColor = UIColor.blackColor()
        self.recordLabel.textColor = UIColor.redColor()
        self.recordLabel.font = UIFont.systemFontOfSize(30)
        //self.recordLabel.frame = CGRectMake(0,0,300,100)
        self.recordLabel.layer.position = CGPoint(x: self.view.bounds.width/4, y:100)
        self.view.addSubview(self.recordLabel)

    }
    
    func setupTimerLabel(){
        //timer定義
        self.timerLabel.frame = CGRectMake(0,0,800,500)
        self.timerLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 500)
        self.timerLabel.backgroundColor = UIColor.grayColor()
        self.timerLabel.text = "\(String(cnt))/30秒"
        self.timerLabel.font = UIFont.systemFontOfSize(20)
        self.timerLabel.textColor = UIColor.whiteColor()
        self.timerLabel.shadowColor = UIColor.blueColor()
        self.timerLabel.textAlignment = NSTextAlignment.Center
        self.timerLabel.layer.masksToBounds = true
        self.timerLabel.layer.cornerRadius = 0.0
        
        // Viewにtimerラベルを追加
        self.view.addSubview(timerLabel)
    }
    
    func setupSlider() {
        // Sliderを作成する.
        
        myGreenSlider.layer.position = CGPointMake(self.view.frame.midX, 550)
        //myGreenSlider.backgroundColor = UIColor.whiteColor()
        myGreenSlider.layer.cornerRadius = 0.0
        myGreenSlider.layer.shadowOpacity = 0.5
        myGreenSlider.layer.masksToBounds = false
        
        // 最小値と最大値を設定する.
        myGreenSlider.minimumValue = 0
        myGreenSlider.maximumValue = 3000
        
        //初期値の設定
        myGreenSlider.value = 0
        
        // Sliderの現在位置より右のTintカラーを変える.
        myGreenSlider.maximumTrackTintColor = UIColor.grayColor()
        
        // Sliderの現在位置より左のTintカラーを変える.
        myGreenSlider.minimumTrackTintColor = UIColor.orangeColor()
        
        let image = UIImage(named: "slider")! as UIImage
        myGreenSlider.setThumbImage(image, forState: .Normal)
        
        //myGreenSlider.addTarget(self, action: "onChangeValueMySlider:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(myGreenSlider)
        
        self.view.backgroundColor = UIColor(red: 0, green: CGFloat(myGreenSlider.value), blue: 0, alpha: 1)
    }

    
    //カメラの撮影ボタンの挙動
    func cameraBtnTap(sender:UIButton){
        if cameraStatus == "readyToStart"{
            //撮影スタート時の挙動
            if !self.cameraEngine.isCapturing {
                self.cameraEngine.start()
//                self.cameraBtn.setTitle("Stop", forState: .Normal)
                //self.changeButtonColor(self.cameraBtn, color: UIColor.redColor())
                
                //撮影スタート時にカウント開始
                var myDefault = NSUserDefaults.standardUserDefaults()
                cnt = myDefault.floatForKey("defaultCnt")
                timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
                self.setupRecordLabel()
                cameraStatus = "recording"
                let image = UIImage(named: "stop")! as UIImage
                self.cameraBtn.setImage(image, forState: .Normal)
                print("1")
            }
        }else if cameraStatus == "recording"{
            if self.cameraEngine.isCapturing {
                if self.cameraEngine.isPaused {
                    //一時停止後録画再開中がここの処理
                    self.cameraEngine.resume()
                    //self.cameraBtn.setTitle("一時停止", forState: .Normal)
                    //self.cameraBtn.backgroundColor = UIColor.redColor()
                    //ユーザーデフォルトのカウント数呼び出し
                    var myDefault = NSUserDefaults.standardUserDefaults()
                    cnt = myDefault.floatForKey("defaultCnt")
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
                    let image = UIImage(named: "stop")! as UIImage
                    self.cameraBtn.setImage(image, forState: .Normal)
                    self.recordLabel.backgroundColor = UIColor.blackColor()
                    self.recordLabel.textColor = UIColor.redColor()
                    print("2")
                }else{
                    //一時停止した時にここの処理
                    self.cameraEngine.pause()
//                    self.cameraBtn.setTitle("restart", forState: .Normal)
//                    self.cameraBtn.backgroundColor = UIColor.greenColor()
                    cnt = cnt + 1
                    //ユーザーデフォルトにカウント数書き込み
                    var myDefault = NSUserDefaults.standardUserDefaults()
                    myDefault.setFloat(cnt, forKey: "defaultCnt")
                    myDefault.synchronize()
                    timer.invalidate()
                    let image = UIImage(named: "record")! as UIImage
                    self.cameraBtn.setImage(image, forState: .Normal)
                    self.recordLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                    self.recordLabel.textColor = UIColor.blackColor()
                    
                    
                    print("3")
                }
            }
        }
    }
    
    //finishボタンタップ
    func finishBtnTap(sender:UIButton){
        if self.cameraEngine.isCapturing {
            self.cameraEngine.stop()
            //ユーザーデフォルトにカウント数書き込み
            cnt = 0.00
            var myDefault = NSUserDefaults.standardUserDefaults()
            myDefault.setFloat(cnt, forKey: "defaultCnt")
            myDefault.synchronize()
            timer.invalidate()
            var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "shareViewController" )
            self.presentViewController( targetView as! UIViewController, animated: true, completion: nil)

        }
        
        // 遷移するViewを定義する.
        //let checkViewController: UIViewController = checkViewController()
        
        // アニメーションを設定する.
        //mySecondViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        
        // Viewの移動する.
        //self.presentViewController(mySecondViewController, animated: true, completion: nil)
    }
    
    
    //timerカウント関数
    func update() {
        if cnt == 3001 {
            //３０秒到達時に自動的に次へ飛ばす
            if self.cameraEngine.isCapturing {
                self.cameraEngine.stop()
                //ユーザーデフォルトにカウント数書き込み
                cnt = 0.00
                var myDefault = NSUserDefaults.standardUserDefaults()
                myDefault.setFloat(cnt, forKey: "defaultCnt")
                myDefault.synchronize()
                timer.invalidate()
                var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "shareViewController" )
                self.presentViewController( targetView as! UIViewController, animated: true, completion: nil)
                print("３０秒撮影済み自動停止")
            }
            
            
        } else {
            if cnt % 200 == 1 && cnt > 1 {
                self.cameraEngine.pause()
//                self.cameraBtn.setTitle("restart", forState: .Normal)
//                self.cameraBtn.backgroundColor = UIColor.greenColor()
                cnt = cnt + 1
                //ユーザーデフォルトにカウント数書き込み
                var myDefault = NSUserDefaults.standardUserDefaults()
                myDefault.setFloat(cnt, forKey: "defaultCnt")
                myDefault.synchronize()
                timer.invalidate()
                let image = UIImage(named: "record")! as UIImage
                self.cameraBtn.setImage(image, forState: .Normal)
                self.recordLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                self.recordLabel.textColor = UIColor.blackColor()
                print("自動停止")
                
            } else {
                //秒数に変換チェック必要
                self.secCnt = cnt / 100
                timerLabel.text = "\(String(secCnt))/30秒"
                // Sliderの位置を設定する.
                self.myGreenSlider.value = self.cnt
                cnt++
            }
        }
    }
    
    func changeButtonColor(target: UIButton, color: UIColor){
        target.backgroundColor = color
    }
}
