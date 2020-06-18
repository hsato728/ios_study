//
//  UserDetailViewController.swift
//  PhotoShare
//
//  Created by 佐藤浩樹 on 2020/06/16.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import NCMB

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var friendRequestedLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var friendRequestButton: UIButton!
    
    var user = NCMBUser() //選択されたユーザ

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ユーザIDをラベルに表示
        self.userIdLabel.text = user.userName
        // friendRequestedLabelを非表示
        self.friendRequestedLabel.isHidden = true
        // 初期ボタン設定
        self.friendRequestButton.setTitle("友達申請", for: .normal)
        self.friendRequestButton.isEnabled = true
        self.friendRequestButton.addTarget(self, action: #selector(UserDetailViewController.sendFriendRequest(_:)), for: .touchUpInside)
        
        // 友達申請状況を取得
        self.checkFriendRequestStatus()
        
        // 申請されているかチェック
        self.checkFriendRequestedBySelectedUser()
    }
    
    // 友達申請送信
    @IBAction func sendFriendRequest(_ sender: Any) {
        let fr = NCMBObject(className: "FriendRequest")
        fr?.setObject(NCMBUser.current(), forKey: "from")
        fr?.setObject(self.user, forKey: "to")
        fr?.setObject("pending", forKey: "status")
        fr?.saveInBackground({(error) in
            if error != nil {
                print("友達申請保存失敗:\(String(describing: error))")
            } else {
                print("友達申請保存成功:\(String(describing: fr))")
                self.changeDisplayByStatus(friendRequest: fr!)
            }
        })
    }
    
    // 友達申請状況を取得
    func checkFriendRequestStatus(){
        let query = NCMBQuery(className: "FriendRequest")
        // 取得条件をfromをログインユーザ、toを選択ユーザに指定
        query?.whereKey("from", equalTo: NCMBUser.current())
        query?.whereKey("to", equalTo: self.user)
        query?.findObjectsInBackground({(objects, error) in
            if (error == nil) {
                print("登録件数: \(String(describing: objects?.count))")
                // データ取得できたら、そのデータのstatusを見て表示切り替え
                if objects!.count > 0 {
                    // ステータスに応じて画面表示切替
                    let fr = objects?[0] as! NCMBObject
                    self.changeDisplayByStatus(friendRequest: fr)
                }
            } else {
                print("友達申請状況取得失敗: \(String(describing: error))")
            }
        })
    }
    
    // 友達承認ステータスに応じて画面表示切り替え
    func changeDisplayByStatus(friendRequest:NCMBObject){
        let status = friendRequest.object(forKey: "status") as! String
        switch status {
        // pendingの場合はボタンを「友達申請中」にし、ボタンタップ不可にする
        case "pending":
            self.friendRequestButton.setTitle("友達申請中", for: .normal)
            self.friendRequestButton.isEnabled = false
        // acceptedの場合はボタンを「友達承認済み」にし、ボタンタップ不可にする
        case "accepted":
            self.friendRequestButton.setTitle("友達承認済み", for: .normal)
            self.friendRequestButton.isEnabled = false
            self.friendRequestedLabel.isHidden = true
        // requestedの場合はボタンを「承認」にし、ボタンタップ時に`acceptFriendRequest`メソッドを呼ぶようにする
        case "requested":
            self.friendRequestedLabel.isHidden = false
            self.friendRequestButton.setTitle("承認", for: .normal)
            self.friendRequestButton.isEnabled = true
            // 申請Actionは削除
            self.friendRequestButton.removeTarget(self, action: #selector(UserDetailViewController.sendFriendRequest(_:)), for: .touchUpInside)
            self.friendRequestButton.addTarget(self, action: #selector(UserDetailViewController.acceptFriendRequest(_:)), for: .touchUpInside)
        // 初期表示は「友達申請」にし、ボタンタップ時に`sendFriendRequest`メソッドを呼ぶようにする
        default:
            self.friendRequestButton.setTitle("友達申請", for: .normal)
            self.friendRequestButton.isEnabled = true
            self.friendRequestButton.addTarget(self, action: #selector(UserDetailViewController.sendFriendRequest(_:)), for: .touchUpInside)
        }
    }
    
    // 申請されているかチェック
    func checkFriendRequestedBySelectedUser(){
        let query = NCMBQuery(className: "FriendRequest")
        // 取得条件をfromを選択ユーザ、toをログインユーザにして取得
        query?.whereKey("from", equalTo: self.user)
        query?.whereKey("to", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({(objects, error) in
            if (error == nil) {
                // データが存在する場合にはstatusを"requested"に変更して表示切替
                if objects!.count > 0 {
                    print("objects:\(String(describing: objects))")
                    let fr = objects?[0] as! NCMBObject
                    if fr.object(forKey: "status") as! String == "pending"{
                        fr.setObject("requested", forKey: "status")
                    }
                    self.changeDisplayByStatus(friendRequest: fr)
                }
            } else {
                print("友達申請状況取得失敗: \(String(describing: error))")
            }
        })
    }
    
    // 友達申請承認
    @IBAction func acceptFriendRequest(_ sender:Any){
        // 1. 条件にfromを選択ユーザ、toをログインユーザにして取得
        let query = NCMBQuery(className: "FriendRequest")
        query?.whereKey("from", equalTo: self.user)
        query?.whereKey("to", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({(objects, error) in
            if (error == nil) {
                print("登録件数: \(String(describing: objects?.count))")
                if objects!.count > 0 {
                    // 2. 取得したデータのstatusを`accepted`にして保存
                    let fr = objects?[0] as! NCMBObject
                    fr.setObject("accepted", forKey: "status")
                    fr.saveInBackground({(error) in
                        if error != nil {
                            print("友達申請承認失敗:\(String(describing: error))")
                        } else {
                            print("友達申請承認成功")
                            // 3. from,toを逆さにしたデータを作り保存
                            let fr = NCMBObject(className: "FriendRequest")
                            fr?.setObject(NCMBUser.current(), forKey:"from" )
                            fr?.setObject(self.user, forKey:"to" )
                            fr?.setObject("accepted", forKey: "status")
                            fr?.saveInBackground({(error) in
                                if error != nil {
                                    print("友達申請保存失敗:\(String(describing: error))")
                                } else {
                                    print("友達申請保存成功:\(String(describing: fr))")
                                    self.changeDisplayByStatus(friendRequest: fr!)
                                }
                            })
                            self.changeDisplayByStatus(friendRequest: fr!)
                        }
                    })
                }
            } else {
                print("友達申請状況取得失敗: \(String(describing: error))")
            }
        })
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
