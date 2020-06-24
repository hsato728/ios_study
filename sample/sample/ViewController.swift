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
    
    //問題（Problemクラスのインスタンス）を格納する配列
    var problemSet = NSMutableArray()
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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //問題を読み込み
            self.loadProblemSet()
        
            //提示問題数を10問とする
            totalProblems = min(10, wordItems!.count)
            
            //現在の問題番号と正答数を0にする
            currentProblem = 0
            correctAnswers = 0
            
            //problemSetの最初の要素の問題文をクイズ画面にセット
            let questions = problemSet.object(at: currentProblem) as! Problem
            problemText.text = questions.getQ()
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
    @IBAction func iKnow(sender: AnyObject) {
        //1を追加して次の問題を提示
        correctAnswers += 1;
        self.nextProblem()
    }
    
    //「知らない...」ボタンが押された場合
    @IBAction func iDontKnow(sender: AnyObject) {
        //次の問題を提示
        self.nextProblem()
    }
    
    //問題の読み込み
    func loadProblemSet() {
        // 問題の数だけ繰り返し
        for i in 0..<wordItems!.count {
            //Problemクラスのインスタンスを生成・初期化し、問題文と答えを格納
            let word = wordItems?[i]
            let p = Problem()
            let q = word?.name
            let m = word?.desc
            p.setQ(q: q!, m: m!)
            //新たに生成したProblemクラスのインスタンスをproblemSetに追加
            problemSet.add(p)
        }
     }
    
    //次の問題提示 or 全問時終わっていたら結果表画面へ
    func nextProblem() {
        //currentProblemを繰り上げ
        currentProblem += 1
        //これまで出題した問題が、提示問題数に達していない場合
        if currentProblem < totalProblems {
            //次の問題の問題文を提示
            let questions = problemSet.object(at: currentProblem) as! Problem
            problemText.text = questions.getQ()
            //全問題解き終わった場合
        } else {
            //結果表示画面へのSegueを始動
            self.performSegue(withIdentifier: "toResultView", sender:self)
        }
    }
}

