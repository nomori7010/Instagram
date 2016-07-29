//
//  SettingViewController.swift
//  Instagram
//
//  Created by NAOTO OMORI on 2016/07/14.
//  Copyright © 2016年 naoto.omori. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBAction func handleChangeButton(sender: AnyObject) {
        if let name = displayNameTextField.text {
            //表示名が入力されていない場合はHUDを出して何もしない
            if name.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("表示名を入力してください")
                return
            }
            
            //Firebaseに表示名を保存する
            if let request = FIRAuth.auth()?.currentUser?.profileChangeRequest() {
                request.displayName = name
                request.commitChangesWithCompletion() { error in
                    if error != nil {
                        print(error)
                    } else {
                        //NSUserDefaultsに表示名を保存する
                        let ud = NSUserDefaults.standardUserDefaults()
                        ud.setValue(name , forKey: CommonConst.DisplayNameKey)
                        ud.synchronize()
                        
                        //HUDで完了を知らせる
                        SVProgressHUD.showSuccessWithStatus("表示名を変更しました")
                        
                        //キーボードを閉じる
                        self.view.endEditing(true)
                    }
                }
            }
        }
    }
    @IBAction func handleLogoutButton(sender: AnyObject) {
        //ログアウトする
        try! FIRAuth.auth()?.signOut()
        
        //ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
        self.presentViewController(loginViewController!, animated: true, completion: nil)
        
        //ログイン画面から戻ってきた時のためにホーム画面（index=0）を選択している状態にしておく。
        let tabBarController = parentViewController as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //NSUserDefaultsから表示名を取得してTextFieldに設定する
        let ud = NSUserDefaults.standardUserDefaults()
        if let name = ud.objectForKey(CommonConst.DisplayNameKey) {
            displayNameTextField.text = name as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
