//
//  ViewController.swift
//  Deai
//
//  Created by 佐藤浩樹 on 2020/06/19.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var interestedInWomen: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // ログインチェック
        self.loginCheck()
    }
    
    func loginCheck(){
        if (NCMBUser.current() != nil) {
            print("ログイン済み")
            // 自分写真を表示
            self.setMyPicture()
        } else {
            print("未ログイン")
            // ログイン画面へ遷移
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        }
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        NCMBUser.logOut()
        self.loginCheck()
    }
    
    // スタートボタンタップ時
    @IBAction func startButtonTapped(sender: AnyObject) {
        // NCMBに好みの性別情報を保存
        let user = NCMBUser.current()
        user?.setObject(interestedInWomen.isOn, forKey: "interestedInWomen")
        user?.saveEventually({(error) in
            if (error != nil) {
                print("保存失敗:\(String(describing: error))")
            }else{
                print("保存成功:\(String(describing: user))")
                // 次の画面
                self.performSegue(withIdentifier: "toTinder", sender: nil)
            }
        })
    }
    
    // 自分の写真を表示
    func setMyPicture(){
        let user = NCMBUser.current()
        print("user:\(String(describing: user))")
        let fbPictureUrl = "https://1.bp.blogspot.com/-K8DEj7le73Y/XuhW_wO41mI/AAAAAAABZjQ/NMEk02WcUBEVBDsEJpCxTN6T0NmqG20qwCNcBGAsYHQ/s1600/kesyou_jirai_make.png"
        if let fbpicUrl = NSURL(string: fbPictureUrl) {
            if let data = NSData(contentsOf: fbpicUrl as URL) {
                self.imageView.image = UIImage(data: data as Data)
            }
        }
    }
    
}

