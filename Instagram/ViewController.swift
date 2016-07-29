//
//  ViewController.swift
//  Instagram
//
//  Created by NAOTO OMORI on 2016/07/14.
//  Copyright © 2016年 naoto.omori. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupTab()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //currentUserがnilならログインしていない
        if FIRAuth.auth()?.currentUser != nil {
            //ログインしている時の処理
            setupTab()
        } else {
            //ログインしていない時の処理
            dispatch_async(dispatch_get_main_queue()) {
                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(loginViewController!, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupTab(){
        //画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController = ESTabBarController(tabIconNames: ["home", "camera", "setting"])!
        
        //背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44,blue: 0.11,alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red:0.96, green: 0.91,blue: 0.87,alpha: 1)
        
        //作成したESTabBarControllerを親のViewController(=self)に追加する
        addChildViewController(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.view.frame = view.bounds
        tabBarController.didMoveToParentViewController(self)
        
        //タブをタップした時に表示するViewControllerを設定する
        let homeViewController = storyboard?.instantiateViewControllerWithIdentifier("Home")
        let settingViewController = storyboard?.instantiateViewControllerWithIdentifier("Setting")
        
        tabBarController.setViewController(homeViewController, atIndex: 0)
        tabBarController.setViewController(settingViewController, atIndex: 2)
        
        tabBarController.setSelectedIndex(0, animated: false)
        
        //真ん中のタブはボタンとして扱う
        tabBarController.highlightButtonAtIndex(1)
        tabBarController.setAction({
                //ボタンが押されたらImageViewControllerをモーダルで表示する
                let imageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageSelect")
                self.presentViewController(imageViewController!, animated: true, completion: nil)
            }, atIndex: 1   )
    }

}

