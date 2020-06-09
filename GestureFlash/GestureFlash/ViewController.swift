//
//  ViewController.swift
//  GestureFlash
//
//  Created by 佐藤浩樹 on 2020/06/05.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var highScore1Label: UILabel!
    @IBOutlet weak var highScore2Label: UILabel!
    @IBOutlet weak var highScore3Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backView(segue: UIStoryboardSegue) {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //User Defaultsへアクセスする
        let defaults = UserDefaults.standard
        //1位から3位までのハイスコアを取得し、double型の変数に格納
        let highScore1 = defaults.double(forKey: "highScore1")
        let highScore2 = defaults.double(forKey: "highScore2")
        let highScore3 = defaults.double(forKey: "highScore3")
        //NSLogによるデバッグメッセージ
        NSLog("ハイスコア: 1位-%f 2位-%f 3位-%f", highScore1,highScore2, highScore3)
        //ハイスコアの存在を確認
        //もし、ハイスコアが存在する場合（0でない場合）は画面の一覧に表示
        if highScore1 != 0 {
            highScore1Label.text = String(format: "%.3f 秒", highScore1)
        }
        if highScore2 != 0 {
            highScore2Label.text = String(format: "%.3f 秒", highScore2)
        }
        if highScore3 != 0 {
            highScore3Label.text = String(format: "%.3f 秒", highScore3)
        }
    }

}

