//
//  musicViewController.swift
//  secondMovies
//
//  Created by 高城晃一 on 2016/02/24.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit

class musicViewController: UIViewController {
    
    let cameraEngine = CameraEngine()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func completeBtnTap(sender: UIBarButtonItem) {
        //これは機能していいない
        cameraEngine.save()
        print("保存ボタン押した")
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
