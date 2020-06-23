//
//  LoginViewController.swift
//  Deai
//
//  Created by 佐藤浩樹 on 2020/06/19.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import NCMB

class LoginViewController: UIViewController {
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //passwordの入力文字を「●」で表示する
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        // NCMBログイン
        let userId = userIdTextField.text!
        let password = passwordTextField.text!
        NCMBUser.logInWithUsername(inBackground: userId, password: password, block:({(user, error) in
            if (error != nil){
                print("ログイン失敗:\(String(describing: error))")
            }else{
                print("ログイン成功:\(String(describing: user))")
                // トップ画面へ戻る
                _ = self.navigationController?.popToRootViewController(animated: true)
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
