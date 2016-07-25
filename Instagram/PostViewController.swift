//
//  PostViewController.swift
//  Instagram
//
//  Created by NAOTO OMORI on 2016/07/14.
//  Copyright © 2016年 naoto.omori. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class PostViewController: UIViewController {
    var image:UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBAction func handlePostButton(sender: UIButton) {
        let postRef = FIRDatabase.database().reference().child(CommonConst.PostPATH)
        
        //imageViewから画像を取得する
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)
        
        //NSUserDefaultsから表示名を取得する
        let ud = NSUserDefaults.standardUserDefaults()
        let name = ud.objectForKey(CommonConst.DisplayNameKey) as! String
        
        //時間を取得する
        let time = NSDate.timeIntervalSinceReferenceDate()
        
        //辞書を作成してFirebaseに保存する
        let postData = ["caption":textField.text!, "image": imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength), "name": name , "time": time]
        postRef.childByAutoId().setValue(postData)
        
        //HUDで投稿完了を表示する
        SVProgressHUD.showSuccessWithStatus("投稿しました")
        
        //すべてのモーダルを閉じる
        UIApplication.sharedApplication().keyWindow!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func handleCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = image
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
