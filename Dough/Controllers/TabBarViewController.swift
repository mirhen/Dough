//
//  TabBarViewController.swift
//  Dough
//
//  Created by Miriam Hendler on 8/6/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if isAppAlreadyLaunchedOnce() == false {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let viewController = storyboard.instantiateViewControllerWithIdentifier("TabBarViewController") as! TabBarViewController
////            self.presentingViewController(viewController, animated: true, completion: nil)
//            
        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let viewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
//            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//            self.window?.rootViewController = viewController
//            self.window?.makeKeyAndVisible()
        }
        // Do any additional setup after loading the view.
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
