//
//  AppDelegate.swift
//  secondMovies
//
//  Created by 高城晃一 on 2016/02/22.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var recordingNum = 1


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // ▼ 1. windowの背景色にLaunchScreen.xibのviewの背景色と同じ色を設定
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        //self.window!.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.window!.backgroundColor = UIColor(red: 245/255, green: 108/255, blue: 102/255, alpha: 1)
        self.window!.makeKeyAndVisible()
        
        // rootViewController from StoryBoard
        // ▼ 2. rootViewControllerをStoryBoardから設定
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var navigationController = mainStoryboard.instantiateViewControllerWithIdentifier("navigationController") as! UIViewController
        self.window!.rootViewController = navigationController
        
        // logo mask
        // ▼ 3. rootViewController.viewをロゴ画像の形にマスクし、LaunchScreen.xibのロゴ画像と同サイズ・同位置に配置
        //要はLoanchスクリーンと同じ状態を作る
        navigationController.view.layer.mask = CALayer()
        navigationController.view.layer.mask!.contents = UIImage(named: "flamingo")!.CGImage
        navigationController.view.layer.mask!.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        navigationController.view.layer.mask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        navigationController.view.layer.mask!.position = CGPoint(x: navigationController.view.frame.width / 2, y: navigationController.view.frame.height / 2)
        
        // logo mask background view
        // ▼ 4. rootViewController.viewの最前面に白いviewを配置
        var maskBgView = UIView(frame: navigationController.view.frame)
        maskBgView.backgroundColor = UIColor.whiteColor()
        navigationController.view.addSubview(maskBgView)
        navigationController.view.bringSubviewToFront(maskBgView)
        
        // logo mask animation
        // ▼ 5. rootViewController.viewのマスクを少し縮小してから、画面サイズよりも大きくなるよう拡大するアニメーション
        let transformAnimation = CAKeyframeAnimation(keyPath: "bounds")
        transformAnimation.delegate = self
        transformAnimation.duration = 1
        transformAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
        let initalBounds = NSValue(CGRect: navigationController.view.layer.mask!.bounds)
        let secondBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: 50, height: 50))
        let finalBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
        transformAnimation.values = [initalBounds, secondBounds, finalBounds]
        transformAnimation.keyTimes = [0, 0.5, 1]
        transformAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        transformAnimation.removedOnCompletion = false
        transformAnimation.fillMode = kCAFillModeForwards
        navigationController.view.layer.mask!.addAnimation(transformAnimation, forKey: "maskAnimation")
        
        // logo mask background view animation
        // ▼ 6. rootViewController.viewの最前面に配置した白いviewを透化するアニメーション (完了後に親viewから削除)
        UIView.animateWithDuration(0.1,
            delay: 2.2,
            options: UIViewAnimationOptions.CurveEaseIn,
            animations: {
                maskBgView.alpha = 0.0
            },
            completion: { finished in
                maskBgView.removeFromSuperview()
        })
        
        // root view animation
        // ▼ 7. rootViewController.viewを少し拡大して元に戻すアニメーション
        UIView.animateWithDuration(0.25,
            delay: 1.3,
            options: UIViewAnimationOptions.TransitionNone,
            animations: {
                self.window!.rootViewController!.view.transform = CGAffineTransformMakeScale(1.05, 1.05)
            },
            completion: { finished in
                UIView.animateWithDuration(0.3,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        self.window!.rootViewController!.view.transform = CGAffineTransformIdentity
                    },
                    completion: nil
                )
        })
        return true
    }
    
    // ▼ 8. 「5.」のアニメーション完了時のdelegateメソッドを実装し、マスクを削除する
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        // remove mask when animation completes
        self.window!.rootViewController!.view.layer.mask = nil
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.koichitakashiro.secondMovies" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("secondMovies", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

