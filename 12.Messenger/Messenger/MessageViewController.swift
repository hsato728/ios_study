//
//  MessageViewController.swift
//  Messenger
//
//  Created by 佐藤浩樹 on 2020/06/15.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import NCMB

class MessageViewController: UIViewController,UITableViewDataSource,UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        let msg = messages.object(at: indexPath.row) as! NCMBObject
        cell.textLabel!.text = msg.object(forKey: "text") as? String
        return cell
    }
    
    var room = NCMBObject() // ユーザ一覧から取得するルーム
    var messages = NSArray()
    
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        messageTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // メッセージ取得
        fetchMessages()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // メッセージ取得
    func fetchMessages(){
        let query = NCMBQuery(className: "Message")
        query?.whereKey("room", equalTo: room)
        query?.order(byAscending: "createDate")
        query?.findObjectsInBackground({(objects, error) in
            if (error == nil) {
                if(objects!.count > 0) {
                    self.messages = objects! as NSArray;
                    self.tableView.reloadData()
                } else {
                    print("エラー")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
    }

    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        let msgStr = messageTextField.text
        // 文字を何かしら入力していたら送信
        if msgStr!.count > 0 {
            // メッセージ送信
            let msg = NCMBObject(className: "Message")
            msg!.setObject(msgStr, forKey: "text")
            msg!.setObject(room, forKey: "room")
            // データストアに保存
            msg!.saveInBackground({(error) in
                if (error != nil) {
                    print("Message:保存失敗:\(String(describing: error))")
                }else{
                    print("Message:保存成功:\(String(describing: msg))")
                    // TableView更新
                    self.fetchMessages()
                    // テキストフィールドの入力内容をリセット
                    self.messageTextField.text = ""
                }
            })
        }
        messageTextField.resignFirstResponder()
    }
    
    // 改行ボタンタップ時
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
