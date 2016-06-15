//
//  ViewController4.swift
//  NavigationDemo
//
//  Created by wuhaizeng on 16/6/2.
//  Copyright © 2016年 cmss. All rights reserved.
//

import UIKit
@objc(ViewController4)
class ViewController4: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func dobtn(sender: AnyObject) {
//        Navigator.dismissURL("myapp://view2/")
        (sender as? UIButton)?.setTitle(String(self.dynamicType), forState: UIControlState.Normal)
//        Navigator.backURL("myapp://view1/")
        SXYRouter.shared().presentWithRouter("SXY://PostViewController", parameters: nil, wrap: true)
//        SXYRouter.shared().backToRouter("myApp://v2")
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
