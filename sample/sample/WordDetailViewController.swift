//
//  WordDetailViewController.swift
//  sample
//
//  Created by 佐藤浩樹 on 2020/06/23.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import RealmSwift

class WordDetailViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    var actionType = "" // アクション種別
    var selectedWord:Word! // 前の画面から送られたWord


    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    // 画面表示切替
    func initView(){
        // アクション種別によりタイトル・ボタンのラベル、タイトル、説明を変更
        if actionType == "NEW" {
            self.title = "新規追加"
            self.commitButton.setTitle("新規追加", for: .normal)
            self.commitButton.addTarget(self, action: #selector(dbAdd(_:)), for: .touchUpInside)
            self.titleField.text = ""
            self.descTextView.text = ""
            self.navigationItem.rightBarButtonItem = nil
            
        } else if actionType == "UPDATE" {
            self.title = "編集"
            self.commitButton.setTitle("更新", for: .normal)
            self.commitButton.addTarget(self, action: #selector(dbUpdate(_:)), for: .touchUpInside)
            self.titleField.text = selectedWord.name
            self.descTextView.text = selectedWord.desc
        }
    }
    
    // Word追加
    @objc func dbAdd(_ sender: UIButton) {
        if isValidateInputContents() == false{
            return
        }
        //wordデータ作成
        let word = Word()
        word.name = titleField.text!
        word.desc = descTextView.text!
        //DB登録
        do{
            let realm = try! Realm()
            try realm.write{
                realm.add(word)
            }
            print("DB登録成功")
        }catch{
            print("DB登録失敗")
        }
        //前の画面戻る
        self.navigationController?.popViewController(animated: true)
    }
    
    // DB更新
    @objc func dbUpdate(_ sender:UIButton) {
        do{
            let realm = try! Realm()
            try realm.write{
                selectedWord.name = self.titleField.text!
                selectedWord.desc = self.descTextView.text!
            }
            print("DB更新成功")
        }catch{
            print("DB更新失敗")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // 削除
    @IBAction func dbDelete(sender: AnyObject) {
        do{
            let realm = try! Realm()
            try realm.write{
                realm.delete(selectedWord)
            }
        }catch{
            print("失敗")
        }
        self.navigationController?.popViewController(animated: true)
    }

    // 入力チェック
    private func isValidateInputContents() -> Bool{
        //単語入力
        if let title = titleField.text{
            if title.count == 0{
                return false
            }
        }else{
            return false
        }
        return true
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
