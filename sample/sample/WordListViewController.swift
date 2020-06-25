//
//  WordListViewController.swift
//  sample
//
//  Created by 佐藤浩樹 on 2020/06/23.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import RealmSwift

class WordListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView! // TableView
    
    // Realm アイテムコレクション
    var wordItems:Results<Word>?{
        let realm = try! Realm()
        return realm.objects(Word.self).sorted(byKeyPath: "name")
    }
    // アクション種別（NEW or UPDATE）
    var actionType = ""
    // 選択した単語
    var selectedWord:Word!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // 画面が表示する度に呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TableView更新
        tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        //編集画面へ
        self.actionType = "NEW"
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    //画面移動の時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //移動時にアクション種別と更新時に）選択された単語リストを送る
        if segue.identifier == "toDetail" {
            let vc = segue.destination as! WordDetailViewController
            vc.actionType = self.actionType
            vc.selectedWord = selectedWord
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordItems!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let word = wordItems?[indexPath.row]
        cell.textLabel?.text = word?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.actionType = "UPDATE"
        selectedWord = wordItems?[indexPath.row]
        self.performSegue(withIdentifier: "toDetail", sender: selectedWord)
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
