//
//  LoginViewController.swift
//  PhotoShare
//
//  Created by 佐藤浩樹 on 2020/06/16.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import NCMB

class LoginViewController: UIViewController {

        @IBOutlet weak var userIdTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
        }


        @IBAction func loginButtonTapped(_ sender: AnyObject) {
            // NCMBログイン
            let userId = userIdTextField.text!
            let password = passwordTextField.text!
            NCMBUser.logInWithUsername(inBackground: userId, password: password, block: ({(user, error) in
                if (error != nil){
                    print("ログイン失敗:\(String(describing: error))")
                }else{
                    print("ログイン成功:\(String(describing: user))")
                    // トップ画面へ戻る
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }))
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
