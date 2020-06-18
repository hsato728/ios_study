//
//  UserListViewController.swift
//  NCMB
//
//  Created by 佐藤浩樹 on 2020/06/16.
//

import UIKit
import NCMB

class UserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var userList = NSArray()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    // 画面が表示される度に呼ばれる
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // ユーザリスト取得
        fetchUserList()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        // ユーザ情報取得
        let user = userList.object(at: indexPath.row) as! NCMBUser
        cell.textLabel!.text = user.userName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userList.object(at: indexPath.row) as! NCMBUser
        self.performSegue(withIdentifier: "toUserDetail", sender: user)
    }
    
    // ユーザ取得
    func fetchUserList(){
        let query = NCMBQuery(className: "user")
        // 自分以外を条件
        query!.whereKey("objectId", notEqualTo: NCMBUser.current().objectId)
        query?.findObjectsInBackground({(objects, error) in
            if (error != nil){
                print("友達取得失敗:\(String(describing: error))")
            } else {
                print("友達取得成功")
                // print(objects)
                self.userList = objects! as NSArray
                self.tableView.reloadData()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserDetail" {
            let vc = segue.destination as! UserDetailViewController
            vc.user = sender as! NCMBUser
        }
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
