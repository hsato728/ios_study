//
//  QuizViewController.swift
//  Quiz
//
//  Created by 佐藤浩樹 on 2020/06/05.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var problemText: UITextView!
    
    //問題（Problemクラスのインスタンス）を格納する配列
    var problemSet = NSMutableArray()
    //出題する問題数
    var totalProblems = Int()
    //現在の進捗（出題済み問題数）を記録
    var currentProblem = Int()
    //正答数
    var correctAnswers = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //クイズ問題を読み込み
        self.loadProblemSet()
        //クイズ問題をランダムに並び替え（シャッフル）
        self.shuffleProblemSet()
        
        //提示問題数を10問とする
        totalProblems = 10
        
        //現在の問題番号と正答数を0にする
        currentProblem = 0
        correctAnswers = 0
        
        //problemSetの最初の要素の問題文をクイズ画面にセット
        let questions = problemSet.object(at: currentProblem) as! Problem
        problemText.text = questions.getQ()
    }
    
    @IBAction func answerIsTrue(_ sender: AnyObject) {
        //答えを確認し、次の問題を提示
        let questions = problemSet.object(at: currentProblem) as! Problem
        if questions.getA() == 0 {
            correctAnswers += 1;
        }
        self.nextProblem()
    }
    
    @IBAction func answerIsFalse(_ sender: AnyObject) {
        //答えを確認し、次の問題を提示
        let questions = problemSet.object(at: currentProblem) as! Problem
        if questions.getA() == 1 {
            correctAnswers += 1;
        }
        self.nextProblem()
    }
    
    //問題の読み込み
    func loadProblemSet() {
        // ファイルの読み込み
        let path = Bundle.main.path(forResource: "quiz", ofType: "csv")
     
        let enc = String.Encoding.utf8
        let data = NSData(contentsOfFile: path!)
        let text = String(NSString(data: data as! Data, encoding: enc.rawValue)!)
        // 行ごとに分割し、配列「lines」に格納
        let lines = text.components(separatedBy: "\n")
        // 問題の数だけ繰り返し
        for i in 0..<lines.count {
            //問題をカンマで区切って、要素を配列「items」に格納
            let items = lines[i].components(separatedBy: ",")
            //Problemクラスのインスタンスを生成・初期化し、問題文と答えを格納
            let p = Problem()
            let q = items[0]
            let a = Int(items[1])
            p.setQ(q: q, a: a!)
            //新たに生成したProblemクラスのインスタンスをproblemSetに追加
            problemSet.add(p)
        }
     }
    
    //問題文をシャッフル
    func shuffleProblemSet() {
        //problemSetに格納された全問題の数を取得
        let totalQuestions = problemSet.count
        //Fisher-Yatesアルゴリズム用のカウンターを取得
        var i = totalQuestions
        //Fisher-Yatesアルゴリズムによって配列の要素をシャッフル
        while i > 0 {
            //乱数を発生
            let j = arc4random() % UInt32(i)
            //要素を並び替え
            problemSet.exchangeObject(at: i-1, withObjectAt: Int(j))
            //カウンターを減少させる
            i -= 1
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

}
