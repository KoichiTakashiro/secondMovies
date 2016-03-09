//
//  detailViewController.swift
//  secondMovies
//
//  Created by 高城晃一 on 2016/02/22.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {
    
    var recievedSelectedIndex = -1
    var recievedSerectedDetail = ""
    
    @IBOutlet weak var detailText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailText.text = recievedSerectedDetail
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
