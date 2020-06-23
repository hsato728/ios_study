//
//  UserDetailViewController.swift
//  Deai
//
//  Created by 佐藤浩樹 on 2020/06/19.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import NCMB
import MessageUI

class UserDetailViewController: UIViewController,MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var user = NCMBUser() // 選択されたユーザ

    override func viewDidLoad() {
        super.viewDidLoad()

        // メールアドレス表示
        mailLabel.text = user.object(forKey: "mailAddress") as? String
        // 画像表示
        let fbPictureUrl = "https://3.bp.blogspot.com/-_pEwLQP90EY/XNE_U4nPeJI/AAAAAAABSws/QEIfXNVUQPoNTbRJDiJTC4AxmkXJxIsewCLcBGAs/s800/pose_heart_hand_idol_woman.png"
        // 本番環境は下記
        // let fbPictureUrl = "https://graph.facebook.com/" + user.userName + "/picture?type=large"
        if let fbpicUrl = NSURL(string: fbPictureUrl) {
            if let data = NSData(contentsOf: fbpicUrl as URL) {
                self.imageView.image = UIImage(data: data as Data)
            }
        }
    }
    
    @IBAction func contact(_ sender: Any) {
        //メールを送信できるかチェック
        if MFMailComposeViewController.canSendMail()==false {
            print("Email Send Failed")
            return
        }
        let mailViewController = MFMailComposeViewController()
        let toRecipients = [user.object(forKey: "mailAddress") as! String] //Toのアドレス指定
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("「出会いアプリ」メール通知")
        mailViewController.setToRecipients(toRecipients) //Toアドレスの表示
        mailViewController.setMessageBody("", isHTML: false)
        // 画像追加
        let fbPictureUrl = "https://3.bp.blogspot.com/-_pEwLQP90EY/XNE_U4nPeJI/AAAAAAABSws/QEIfXNVUQPoNTbRJDiJTC4AxmkXJxIsewCLcBGAs/s800/pose_heart_hand_idol_woman.png"
        if let fbpicUrl = NSURL(string: fbPictureUrl) {
            if let data = NSData(contentsOf: fbpicUrl as URL) {
                mailViewController.addAttachmentData(data as Data, mimeType: "image/png", fileName: "image")
            }
        }
        self.present(mailViewController, animated: true, completion: nil)
        
    }
    
    // メール完了時
    private func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("メール送信キャンセル")
            break
        case MFMailComposeResult.saved:
            print("メールドラフト保存")
            break
        case MFMailComposeResult.sent:
            print("メール送信完了")
            break
        case MFMailComposeResult.failed:
             print("メール送信失敗")
            break
        default:
            break
        }
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
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
