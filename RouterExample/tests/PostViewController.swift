//
//  PostViewController.swift
//  AlamofireDemo
//
//  Created by wuhaizeng on 16/6/1.
//  Copyright © 2016年 cmss. All rights reserved.
//

import UIKit
@objc(PostViewController)
class PostViewController: UIViewController {

    @IBAction func press(sender: AnyObject) {

//        Navigator.pushURL("myapp://view1/")
        SXYRouter.shared().backToRouter(nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = String(self.dynamicType)
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
