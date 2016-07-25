//
//  LoginViewController.swift
//  Instagram
//
//  Created by NAOTO OMORI on 2016/07/14.
//  Copyright © 2016年 naoto.omori. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func handleLoginButton(sender: AnyObject) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            //アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.characters.isEmpty || password.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus(ErrorMessage.FieldEmpty)
                return
                
            }
            
            //処理中を表示
            SVProgressHUD.show()
            
            FIRAuth.auth()?.signInWithEmail(address, password: password ) { user, error in
                if error != nil {
                    SVProgressHUD.showErrorWithStatus(ErrorMessage.Unknown)
                    print(error)
                } else {
                    //Firebaseからログインしたユーザの表示名を取得してNSUserDefaultsに保存する
                    if let displayName = user?.displayName {
                        
                        self.setDisplayName(displayName)
                    }
                    
                    //HUDを消す
                    SVProgressHUD.dismiss()
                    
                    
                    //画面を閉じる
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    @IBAction func handleCreateAccountButton(sender: AnyObject) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            if address.characters.isEmpty || password.characters.isEmpty || displayName.characters.isEmpty {
                //
                SVProgressHUD.showErrorWithStatus(ErrorMessage.FieldEmpty)
                return
            
            }
        
            FIRAuth.auth()?.createUserWithEmail(address, password: password) { user, error in
                if error != nil {
                    SVProgressHUD.showErrorWithStatus(ErrorMessage.Unknown)
                    print(error)
                } else {
                    //ユーザー作成できたらそのままログインする
                    FIRAuth.auth()?.signInWithEmail(address, password: password){ user , error in
                        if error != nil {
                            SVProgressHUD.showErrorWithStatus(ErrorMessage.Unknown)
                            print(error)
                        } else {
                            if let user = user {
                                //Firebaseに表示名を保存する
                                let request = user.profileChangeRequest()
                                request.displayName = displayName
                                request.commitChangesWithCompletion() { error in
                                    if error != nil {
                                        print(error)
                                    } else {
                                        //NSUserDefaultsに表示名を保存する
                                        self.setDisplayName(displayName)
                                    
                                        //HUDを消す
                                        SVProgressHUD.dismiss()
                                        
                                        //画面を閉じる
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDisplayName(name: String) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setValue(name, forKey: CommonConst.DisplayNameKey)
        ud.synchronize()
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
