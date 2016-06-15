//
//  UserViewController.swift
//  AlamofireDemo
//
//  Created by wuhaizeng on 16/6/1.
//  Copyright © 2016年 cmss. All rights reserved.
//

import UIKit
@objc(UserViewController)
class UserViewController: BaseViewController {

    var xyz:String?
    
    @IBOutlet weak var doBtn: UIButton!

    @IBAction func press(sender: AnyObject) {
//        SXYRouter.shared().pushWithRouter("myApp://v1", parameters: ["vc1":"vc111"])
        let btn = UIButton()
        SXYRouter.shared().callBlock("SXY://block", parameters: ["sss":btn])
//        var x:Int = Int(xyz!)!
//        if x == 5 {
            SXYRouter.shared().pushWithRouter("SXY://ViewController1", parameters: nil)
//            return
//        }
//        x += 1
//        xyz = String(x)
//        let s = "SXY://UserViewController" + xyz!
//        SXYRouter.shared().pushWithRouter(s, parameters: ["xyz":xyz!])
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = String(self.dynamicType)
        print("xyz is ",xyz)
        let route = params["route"]
        doBtn.setTitle(route as? String, forState: UIControlState.Normal)
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
