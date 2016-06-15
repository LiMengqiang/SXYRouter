//
//  ViewController1.swift
//  NavigationDemo
//
//  Created by wuhaizeng on 16/6/2.
//  Copyright © 2016年 cmss. All rights reserved.
//

import UIKit
@objc(ViewController1)
class ViewController1: BaseViewController {

    var vc1:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = String(self.dynamicType)
        // Do any additional setup after loading the view.

//        print(vc1)
//        SXYRouter.shared().matchBlock("SXY://block")
        var block = SXYRouter.shared().matchBlock("SXY://block")
        block = {params -> AnyObject in
            print(params)
            return params
        }
    }

    @IBAction func doBtn(sender: AnyObject) {
        
        (sender as? UIButton)?.setTitle(String(self.dynamicType), forState: UIControlState.Normal)
        SXYRouter.shared().pushWithRouter("SXY://ViewController2", parameters: nil)
//        SXYRouter.shared().backToRouter("myApp://user/3")
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
