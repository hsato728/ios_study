//
//  ResultViewController.swift
//  GestureFlash
//
//  Created by 佐藤浩樹 on 2020/06/08.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newHighScoreLabel: UILabel!
    
    var time = TimeInterval()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeLabel.text = String(format: "%.3f 秒", time)
        //ハイスコアの判定
        self.checkHighScore()
    }
    
    func checkHighScore() {
        //ハイスコアが更新されかどうかの管理（スコア比較前は「偽」に）
        var newHighScore = false
        //一度「ハイスコア更新」ラベルを非表示
        newHighScoreLabel.isHidden = true
        //User Defaultsへアクセスする
        let defaults = UserDefaults.standard
        //1位から3位までのハイスコアを取得し、double型の変数に格納
        var highScore1 = defaults.double(forKey: "highScore1")
        var highScore2 = defaults.double(forKey: "highScore2")
        var highScore3 = defaults.double(forKey: "highScore3")
        //（全てのハイスコアが既にある場合）比較の結果、今回のtimeが当てはまる順位に記録を挿入
        //1位より早い場合
        if highScore1 != 0 && time <= highScore1 {
            highScore3 = highScore2
            highScore2 = highScore1
            highScore1 = time
            newHighScore = true
            //2位より早い場合
        } else if highScore2 != 0 && time <= highScore2 {
            highScore3 = highScore2
            highScore2 = time
            newHighScore = true
            //3位より早い場合
        } else if highScore3 != 0 && time <= highScore3 {
            highScore3 = time
            newHighScore = true
        }
            //ハイスコアがまだ格納されていない場合のtimeとの比較
            //1位がまだない場合
        else if highScore1 == 0 {
            highScore1 = time
            newHighScore = true
            //2位がまだなく、1位より遅い場合
        } else if highScore2 == 0 && time >= highScore1 {
            highScore2 = time
            newHighScore = true
            //3位がまだなく、2位より遅い場合
        } else if highScore3 == 0 && time >= highScore2 {
            highScore3 = time
            newHighScore = true
        }
        //新しいハイスコアをUser Defaultsに保存
        defaults.set(highScore1, forKey: "highScore1")
        defaults.set(highScore2, forKey: "highScore2")
        defaults.set(highScore3, forKey: "highScore3")
        
        //もし、ハイスコアが更新された場合は「ハイスコア更新」ラベルを表示
        if newHighScore == true {
            newHighScoreLabel.isHidden = false
        }
    }
}
