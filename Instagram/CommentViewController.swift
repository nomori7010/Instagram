//
//  CommentViewController.swift
//  Instagram
//
//  Created by NAOTO OMORI on 2016/07/27.
//  Copyright © 2016年 naoto.omori. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var scvBackGround: UIScrollView!
    var txtActiveField = UITextField()
    var postData:PostData!
    
    @IBOutlet weak var commentTextView: UILabel!
    @IBOutlet weak var commentText: UITextField!
    var text:String = ""
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
 
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する。
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(CommentViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        for i in 0..<postData.comments.count {
            text = text + postData.comments[i]["name"]! + " : " + postData.comments[i]["comment"]! + "\n"
        }
        commentTextView.text = text
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(CommentViewController.handleKeyboardWillShowNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(CommentViewController.handleKeyboardWillHideNotification(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
        notificationCenter.removeObserver(self)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        txtActiveField = textField
        return true
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //Firebaseに保存するデータの準備
        if let uid = FIRAuth.auth()?.currentUser?.uid  {
            if let displayName = FIRAuth.auth()?.currentUser?.displayName {
                
                let comment = ["uid":uid, "name":displayName, "comment":commentText.text!]
                postData.comments.append(comment)
                let imageString = postData.imageString
                let name = postData.name
                let caption = postData.caption
                let time = (postData.date?.timeIntervalSinceReferenceDate)! as NSTimeInterval
                let likes = postData.likes
                let comments = postData.comments
            
                
                //辞書を作成してFirebaseに保存する
                let post = ["caption": caption!, "image": imageString!, "name": name!, "time": time, "likes": likes, "comments":comments]
            
                let postRef = FIRDatabase.database().reference().child(CommonConst.PostPATH)
                postRef.child(postData.id!).setValue(post)
            }
        }

        view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        return true
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let myBoundSize:CGSize = UIScreen.mainScreen().bounds.size
        
        let txtLimit = txtActiveField.frame.origin.y + txtActiveField.frame.height + 25.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        print("テキストフィールドの下辺：\(txtLimit)")
        print("キーボードの上辺：\(kbdLimit)")
        
        if txtLimit >= kbdLimit {
            scvBackGround.contentOffset.y = txtLimit - kbdLimit
        }
    }
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        scvBackGround.contentOffset.y = 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        return cell
    }
    
    
    func dismissKeyboard(){
        //キーボードを閉じる
        view.endEditing(true)
    }

}
