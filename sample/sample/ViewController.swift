//
//  ViewController.swift
//  sample
//
//  Created by 佐藤浩樹 on 2020/06/23.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet weak var problemText: UILabel!
    @IBOutlet weak var problemDesc: UITextView!
    @IBOutlet weak var iKnow: UIButton!
    @IBOutlet weak var iDontKnow: UIButton!
    @IBOutlet weak var nextWord: UIButton!
    @IBOutlet weak var reviewLabel: UILabel!
    
    //出題する問題数
    var totalProblems = Int()
    //現在の進捗（出題済み問題数）を記録
    var currentProblem = Int()
    //正答数
    var correctAnswers = Int()
    // Realm アイテムコレクション
    var wordItems:Results<Word>?{
        let realm = try! Realm()
        return realm.objects(Word.self).sorted(byKeyPath: "name")
    }
    //説明文
    var word = Word()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //提示問題数を10問とする
        totalProblems = min(10, wordItems!.count)
        
        //現在の問題番号と正答数を0にする
        currentProblem = 0
        correctAnswers = 0
        
        //wordItemsの最初の要素の単語を画面にセット
        word = (wordItems?[currentProblem])! as Word
        problemText.text = word.name
        problemDesc.text = ""
        
        //「次へ」ボタンを非表示
        nextWord.isHidden = true
        
        //復習ラベルを非表示
        reviewLabel.isHidden = true
    }
    
    //結果表示画面へのSegueの発動
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //正答率を算出
        let percentage = correctAnswers * 100 / totalProblems
        
        //ResultViewController（RVC）のインスタンスを作成し、
        //RVCクラスのメンバー変数である「correctPercentage」に値を渡す
        if segue.identifier == "toResultView" {
            let rvc = segue.destination as! ResultViewController
            rvc.correctPercentage = percentage
        }
    }
    
    //「知ってる!」ボタンが押された場合
    @IBAction func iKnow(sender: Any) {
        //1を追加して説明を表示
        correctAnswers += 1;
        problemDesc.text = word.desc
        //完了フラグを立てる
        do{
            let realm = try! Realm()
            try realm.write{
                word.isComplete = true
            }
            print("DB更新成功")
        }catch{
            print("DB更新失敗")
        }
        //UIButtonの表示切り替え
        iKnow.isHidden = true
        iDontKnow.isHidden = true
        nextWord.isHidden = false
    }
    
    //「知らない...」ボタンが押された場合
    @IBAction func iDontKnow(sender: Any) {
        //説明を表示
        problemDesc.text = word.desc
        //完了フラグを折る
        do{
            let realm = try! Realm()
            try realm.write{
                word.isComplete = false
            }
            print("DB更新成功")
        }catch{
            print("DB更新失敗")
        }
        //UIButtonの表示切り替え
        iKnow.isHidden = true
        iDontKnow.isHidden = true
        nextWord.isHidden = false
    }
    
    //「次へ」ボタンが押された場合
    @IBAction func nextWord(sender: Any) {
        //テスト用
        print(word.isComplete)
        //次の問題を提示
        if reviewLabel.isHidden == true {
            self.nextProblem()
        } else {
            review()
        }
        //UIButtonの表示切り替え
        iKnow.isHidden = false
        iDontKnow.isHidden = false
        nextWord.isHidden = true
    }
    
    //次の問題提示 or 全問終わっていたら結果表画面へ
    func nextProblem() {
        print("next")
        //currentProblemを繰り上げ
        currentProblem += 1
        //これまで出題した問題が、提示問題数に達していない場合
        if currentProblem < totalProblems {
            //次の問題の問題文を提示
            word = (wordItems?[currentProblem])! as Word
            problemText.text = word.name
            problemDesc.text = ""
            //全問題解き終わった場合
        } else {
            //現在の問題番号と正答数を0にする
            currentProblem = 0
            //復習ラベルを表示
            reviewLabel.isHidden = false
            //復習メソッドを起動
            review()
        }
    }
    
    //間違えた問題の復習
    func review() {
        //これまで出題した問題が、提示問題数に達していない場合
        if currentProblem < totalProblems {
            //次の問題の問題文を提示
            word = (wordItems?[currentProblem])! as Word
            print(word.isComplete, "完了フラグ")
            //currentProblemを繰り上げ
            currentProblem += 1
            //暗記済みなら飛ばす
            if word.isComplete == true {
                review()
            } else {
                problemText.text = word.name
                problemDesc.text = ""
            }
            //全問題解き終わった場合
        } else {
            //結果表示画面へのSegueを始動
            self.performSegue(withIdentifier: "toResultView", sender:self)
        }
    }
}

