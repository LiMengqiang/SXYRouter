//
//  ViewController2.swift
//  NavigationDemo
//
//  Created by wuhaizeng on 16/6/2.
//  Copyright © 2016年 cmss. All rights reserved.
//

import UIKit
@objc(ViewController2)
class ViewController2: BaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func doBtn(sender: AnyObject) {
        (sender as? UIButton)?.setTitle(String(self.dynamicType), forState: UIControlState.Normal)
//        Navigator.presentURL("myapp://view3/", wrap: wrap)
        SXYRouter.shared().presentWithRouter("SXY://ViewController3", parameters: nil, wrap: true)
//        SXYRouter.shared().backToRouter("myApp://user")
        SXYRouter.shared().callBlock("SXY://block", parameters: ["12":"43"])
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
