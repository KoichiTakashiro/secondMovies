//
//  ViewController.swift
//  secondMovies
//
//  Created by 高城晃一 on 2016/02/22.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var othersBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        othersBtn.setImage(UIImage(named: "shrimp"), forState: UIControlState.Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

