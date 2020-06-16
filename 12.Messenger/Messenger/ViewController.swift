//
//  ViewController.swift
//  Messenger
//
//  Created by 佐藤浩樹 on 2020/06/11.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var users = NSArray() // ユーザデータ
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択したユーザ
        let selectedUser = users.object(at: indexPath.row) as! NCMBUser
        // 自ユーザ
        let myUser = NCMBUser.current()
        // 既にRoomが作成されているかチェック
        self.checkRoomExist(myUser: myUser!, selectedUser: selectedUser)
    }
    
    // Roomデータ保存
    func createRoom(myUser:NCMBUser,selectedUser:NCMBUser){
        // Roomテーブル登録用NCMBオブジェクト生成
        let room = NCMBObject(className: "Room")
        // 部屋の名前は選択したユーザを連結したものにする
        room?.setObject("\(String(describing: myUser.userName)) <--> \(String(describing: selectedUser.userName))", forKey: "roomName")
        // Roomメンバー設定
        room?.setObject([myUser,selectedUser], forKey: "users")
        // Roomデータ保存
        room?.saveInBackground({(error) in
            if (error != nil) {
                print("Room保存失敗:\(String(describing: error))")
            }else{
                print("Room保存成功:\(String(describing: room))")
                // 次の画面へ遷移（roomを次の画面に渡す）
                self.performSegue(withIdentifier: "toMessage", sender: room)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        // ユーザIDをセルに表示
        let user = users.object(at: indexPath.row) as! NCMBUser
        cell.textLabel!.text = user.userName
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // ログインチェック
        self.loginCheck()
    }
    
    func loginCheck(){
        if (NCMBUser.current() != nil) {
            print("ログイン済み")
            // ユーザ取得
            fetchUserList()
        } else {
            print("未ログイン")
            // ログイン画面へ遷移
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // ユーザ取得
    func fetchUserList(){
        // 取得対象のテーブルを"user"に指定
        let query = NCMBQuery(className: "user")
        // 取得条件として自分以外の条件追加
        query?.whereKey("objectId", notEqualTo: NCMBUser.current().objectId)
        // データ取得
        query!.findObjectsInBackground({(objects, error) in
            if (error != nil){
                print("ユーザ取得失敗:\(String(describing: error))")
            } else {
                print("ユーザ取得成功:\(String(describing: objects))")
                self.users = objects! as NSArray
                self.tableView.reloadData()
            }
        })
    }
    
    // すでにルーム作成されているかチェック
    func checkRoomExist(myUser:NCMBUser,selectedUser:NCMBUser){
        let query = NCMBQuery(className: "Room")
        query?.whereKey("users", containsAllObjectsInArrayTo: [myUser,selectedUser])
        query?.findObjectsInBackground({(objects, error) in
            if (error != nil){
                print("RoomUser取得失敗:\(String(describing: error))")
            } else {
                print("RoomUser取得成功:\(String(describing: objects))")
                if (objects?.count)! > 0 {
                    print("Room作成済")
                    // 次の画面へ遷移（roomを次の画面に渡す）
                    let room = objects![0] as! NCMBObject
                    self.performSegue(withIdentifier: "toMessage", sender: room)
                    
                } else {
                    print("Room未作成")
                    // Roomデータ保存
                    self.createRoom(myUser: myUser, selectedUser: selectedUser)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessage"{
            let vc = segue.destination as! MessageViewController
            vc.room = sender as! NCMBObject
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        NCMBUser.logOut()
        self.loginCheck()
    }

}
