//
//  ViewController.swift
//  Todo
//
//  Created by 佐藤浩樹 on 2020/06/18.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView! // TableView
    // Realm Todoアイテムコレクション
    var todoItems:Results<ToDo>?{
        do{
            let realm = try! Realm()
            return realm.objects(ToDo.self).sorted(byKeyPath: "createDate")
        }catch{
            print("エラー111")
        }
        return nil
    }
    
    var actionType = "" // アクション種別（NEW or UPDATE）
    var selectedTodo:ToDo! // 選択したTODO

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // 画面が表示する度に呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        //TODO編集画面へ
        self.actionType = "NEW"
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }
    //画面移動の時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //移動時にアクション種別と更新時に）選択されたTODOリストを送る
        if segue.identifier == "toDetail" {
            let vc = segue.destination as! TodoDetailViewController
            vc.actionType = self.actionType
            vc.selectedTodo = selectedTodo
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let toDo = todoItems?[indexPath.row]
        cell.textLabel?.text = toDo?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.actionType = "UPDATE"
        selectedTodo = todoItems?[indexPath.row]
        self.performSegue(withIdentifier: "toDetail", sender: selectedTodo)
    }
}

