//
//  ViewController.swift
//  secondMovies
//
//  Created by 高城晃一 on 2016/02/22.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let recordController = recordViewController()
    let BGMController = BGMViewController()
    
    //let cameraEngine = CameraEngine()

    @IBOutlet weak var othersBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        BGMController.deleteFiles()
        print("BGMコントローラーのファイル削除呼び出し")
     }
    
    @IBAction func backWithSegue(let segue: UIStoryboardSegue) {
        NSLog("back")
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        //ユーザーデフォルトにカウント数書き込み
        recordController.cnt = 0.00
        var myDefault = NSUserDefaults.standardUserDefaults()
        myDefault.setFloat(recordController.cnt, forKey: "defaultCnt")
        myDefault.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

