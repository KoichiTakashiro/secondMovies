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
    
    //何回目のカメラ起動か記録する変数
    var recordingNum:Int = 1
    var preparingLabel :UILabel!
    
    
    
    //効果音の準備
    var musicPlayer:AVAudioPlayer!
    // 再生するmusicファイルのパスを取得  今回は[music.mp3]
    let music_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cameraSound", ofType: "mp3")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func waitAtleast(time : NSTimeInterval, @noescape _ block: () -> Void) {
        let start = NSDate()
        block()
        let elapsedTime = NSDate().timeIntervalSinceDate(start)
        var waitTime = max(0.0, time - elapsedTime)
        if waitTime > 0.0 {
            NSThread.sleepForTimeInterval(waitTime)
        }
    }
    
    //var secondSetup = false
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
         var myDefault = NSUserDefaults.standardUserDefaults()
        cnt = myDefault.floatForKey("defaultCnt")
        
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session:self.cameraEngine.captureSession)
        //videoLayer.frame = CGRectMake(100, 100, 300, 300)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        //self.view.sendSubviewToBack(videoLayer)
        videoLayer.zPosition = -50
        
        var myAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        
        if myAppDelegate.recordingNum == 1 {
            SVProgressHUD.showWithStatus("カメラ準備中")
            dispatch_async_global {
                //バックグラウンドスレッド
                //時間のかかる処理
                self.waitAtleast(5.0) {
                    self.cameraEngine.startup()
                    print("DidLoadのバックでカメラ起動中")
                }
                //メインスレッド
                self.dispatch_async_main {
                    
                    if (self.cameraEngine.isSuccess == true) { // 呼び出し結果の確認
                        //SVProgressHUD.popActivity()
                        SVProgressHUD.showSuccessWithStatus("(`･ω･´)ｼｬｷｰﾝ!")
                        // 成功時の処理を行う(APIのレスポンスを利用して描画処理など)
                        //ボタンの配置
                        self.setupButton()
                        //var myAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        myAppDelegate.recordingNum++
                        print("レコーディングナンバーは\(myAppDelegate.recordingNum)")
                        //self.preparingLabel.hidden = true
                        
                    } else {
                        SVProgressHUD.showErrorWithStatus("失敗!")
                        // エラーハンドリング
                    }
                }
                
            }
        }else{
            //SVProgressHUD.showWithStatus("カメラ準備中")
            self.setupPreparingLabel()
            print("準備中ラベル作成")

            dispatch_async_global {
                //バックグラウンドスレッド
                //時間のかかる処理
                self.waitAtleast(6.0) {
                    self.cameraEngine.startup()
                    print("DidLoadのバックでカメラ起動中")
                }
                //メインスレッド
                self.dispatch_async_main {
                    
                    if (self.cameraEngine.isSuccess == true) { // 呼び出し結果の確認
                        //SVProgressHUD.popActivity()
                        //SVProgressHUD.showSuccessWithStatus("(`･ω･´)ｼｬｷｰﾝ!")
                        // 成功時の処理を行う(APIのレスポンスを利用して描画処理など)
                        //ボタンの配置
                        self.setupButton()
                        self.preparingLabel.hidden = true
                        
                    } else {
                        SVProgressHUD.showErrorWithStatus("失敗!")
                        // エラーハンドリング
                    }
                }
                
            }

        }
        //タイマー配置
        self.setupTimerLabel()
        
        //プログレス設置
        self.setupSlider()
    }
    
    //ローディング用便利関数
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
    
    func soundPlay() {
        do {
        //動作部分
        musicPlayer = try AVAudioPlayer(contentsOfURL: music_data)
        musicPlayer.play()
        }catch let error as NSError {
            //エラーをキャッチした場合
            print(error)
        }
    }
    
    func setupPreparingLabel(){
        //self.preparingLabel.frame = CGRectMake(0,0,500,200)←これはダメ！！
        self.preparingLabel = UILabel(frame: CGRectMake(0,0,500,200))
        self.preparingLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: self.view.bounds.height/2)
        self.preparingLabel.backgroundColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.5)
        self.preparingLabel.textColor = UIColor(red: 245/255, green: 108/255, blue: 102/255, alpha: 1)
        self.preparingLabel.text = "カメラ起動中..."
        self.preparingLabel.font = UIFont.systemFontOfSize(25)
        self.preparingLabel.textAlignment = NSTextAlignment.Center
        self.preparingLabel.layer.masksToBounds = true
        self.preparingLabel.layer.cornerRadius = 5
        
        // Viewにラベルを追加
        self.view.addSubview(preparingLabel)
    }
    
    func setupButton(){
        
        //カメラ撮影ボタン
        self.cameraBtn = UIButton(frame: CGRectMake(0,0,70,70))
        self.cameraBtn.layer.masksToBounds = true
        self.cameraBtn.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        self.cameraBtn.addTarget(self, action: "cameraBtnTap:", forControlEvents: .TouchUpInside)
        let image = UIImage(named: "record")! as UIImage
        self.cameraBtn.setImage(image, forState: .Normal)
        
        //録画をストップして次に進むボタン
        self.finishBtn = UIButton(frame: CGRectMake(0,0,70,70))
        self.finishBtn.backgroundColor = UIColor.blueColor()
        self.finishBtn.layer.masksToBounds = true
        self.finishBtn.setTitle("Finish", forState: .Normal)
        self.finishBtn.layer.position = CGPoint(x: self.view.bounds.width/4, y:self.view.bounds.height-30)
        self.finishBtn.addTarget(self, action: "finishBtnTap:", forControlEvents: .TouchUpInside)
        
        
        //Viewにボタンを追加
        self.view.addSubview(self.cameraBtn)
    }
    
    func setupRecordLabel() {
        //録画中ラベルの表示
        self.recordLabel = UILabel(frame: CGRectMake(0,0,170,80))
        self.recordLabel.text = "● 録画中"
        self.recordLabel.backgroundColor = UIColor.blackColor()
        self.recordLabel.textColor = UIColor.redColor()
        self.recordLabel.font = UIFont.systemFontOfSize(30)
        //self.recordLabel.frame = CGRectMake(0,0,300,100)
        self.recordLabel.layer.position = CGPoint(x: self.view.bounds.width/4+10, y:100)
        self.view.addSubview(self.recordLabel)

    }
    
    func setupTimerLabel(){
        //timer定義
        self.timerLabel.frame = CGRectMake(0,0,800,500)
        self.timerLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 500)
        self.timerLabel.backgroundColor = UIColor.grayColor()
        self.secCnt = cnt / 100
        self.timerLabel.text = "\(String(secCnt))/30秒"
        self.timerLabel.font = UIFont.systemFontOfSize(20)
        self.timerLabel.textColor = UIColor.whiteColor()
        self.timerLabel.shadowColor = UIColor.blueColor()
        self.timerLabel.textAlignment = NSTextAlignment.Center
        self.timerLabel.layer.masksToBounds = true
        self.timerLabel.layer.cornerRadius = 0.0
        
        // Viewにtimerラベルを追加
        self.view.addSubview(timerLabel)
    }
    
    var myGreenSlider = UISlider(frame: CGRectMake(0, 0, 0, 0))
    func setupSlider() {
        //スライダーの設置
        myGreenSlider = UISlider(frame: CGRectMake(-10, self.view.bounds.height-120, self.view.bounds.width+10, 30))
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
                //let image = UIImage(named: "stop")! as UIImage
                //self.cameraBtn.setImage(image, forState: .Normal)
                cameraBtn.enabled = false
                print("1")
                soundPlay()
            }
        }else if cameraStatus == "recording"{
            if self.cameraEngine.isCapturing {
                if self.cameraEngine.isPaused {
                    //一時停止後録画再開中がここの処理
                    self.cameraEngine.resume()
                    //ユーザーデフォルトのカウント数呼び出し
                    var myDefault = NSUserDefaults.standardUserDefaults()
                    cnt = myDefault.floatForKey("defaultCnt")
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
                    cameraBtn.enabled = false
                    setupRecordLabel()
                    print("2")
                    soundPlay()
                }else{
                    //一時停止した時にここの処理
                    self.cameraEngine.pause()
                    cnt = cnt + 1
                    //ユーザーデフォルトにカウント数書き込み
                    var myDefault = NSUserDefaults.standardUserDefaults()
                    myDefault.setFloat(cnt, forKey: "defaultCnt")
                    myDefault.synchronize()
                    timer.invalidate()
                    let image = UIImage(named: "record")! as UIImage
                    self.cameraBtn.setImage(image, forState: .Normal)
                    cameraBtn.enabled = true
                    self.recordLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                    self.recordLabel.textColor = UIColor.blackColor()
                    self.recordLabel.text = "一時停止中"
                    print("3")
                    soundPlay()
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
            var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "BGMViewController" )
            self.presentViewController( targetView as! UIViewController, animated: true, completion: nil)

        }
    }
    
    
    //timerカウント関数
    func update() {
        //３０秒制限の場合は3001、一時的に601に設定
        if cnt == 3001 {
            //３０秒到達時に自動的に次へ飛ばす
            if self.cameraEngine.isCapturing {
                self.cameraEngine.stop()
                print("カメラエンジンのStop発動")
                //ユーザーデフォルトにカウント数書き込み
                cnt = 0.00
                var myDefault = NSUserDefaults.standardUserDefaults()
                myDefault.setFloat(cnt, forKey: "defaultCnt")
                myDefault.synchronize()
                timer.invalidate()
                var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "BGMViewController" )
                self.presentViewController( targetView as! UIViewController, animated: true, completion: nil)
                soundPlay()
                print("３０秒撮影済み自動停止")
            }
            
            
        } else {
            if cnt % 200 == 1 && cnt > 1 {
                //自動的に一時停止
                self.cameraEngine.pause()
                cnt = cnt + 1
                //ユーザーデフォルトにカウント数書き込み
                var myDefault = NSUserDefaults.standardUserDefaults()
                myDefault.setFloat(cnt, forKey: "defaultCnt")
                myDefault.synchronize()
                timer.invalidate()
                cameraBtn.enabled = true
                self.recordLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                self.recordLabel.textColor = UIColor.whiteColor()
                self.recordLabel.text = "一時停止中"
                soundPlay()
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
