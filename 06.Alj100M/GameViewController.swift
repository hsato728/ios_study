//
//  GameViewController.swift
//  Alj100M
//
//  Created by 佐藤浩樹 on 2020/06/09.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var CountLabel: UILabel!
    @IBOutlet weak var Cara1: UIImageView!
    @IBOutlet weak var Cara2: UIImageView!
    @IBOutlet weak var ase1: UIImageView!
    @IBOutlet weak var ase2: UIImageView!
    @IBOutlet weak var ganba1: UIImageView!
    @IBOutlet weak var ganba2: UIImageView!
    @IBOutlet weak var goal: UIImageView!
    
    //変数の宣言(「CountInt」という名前の箱(数字しか入らない箱(Int型))を作って「0」を入れる。)
    var CountInt:Int = 0
    
    //変数の宣言(「timer」という名前の箱(NSTimerオブジェクトしか入らない箱)を作る)
    var timer:Timer!
    
    //連打ボタンが押された時(Touch up inside)に実行される処理
    @IBAction func rendaButton(sender: AnyObject) {
        //Cara1が非表示かどうか確認して
        if Cara1.isHidden == true {
            //Cara1が非表示だったら
            //Cara1を表示して、Cara2を非表示にする
            Cara1.isHidden = false
            Cara2.isHidden = true
        } else{
            //Cara1が表示していたら
            //Cara1を非表示にして、Cara2を表示させる
            Cara1.isHidden = true
            Cara2.isHidden = false
        }
        
        //CountIntに+1する
        CountInt = CountInt + 1
        
        //CountIntを文字列へ変換してCountLabel.textへ代入する
        CountLabel.text = CountInt.description
        
        if CountInt > 90{
            
            if ase1.isHidden == false{
                ase1.isHidden = true
                ase2.isHidden = false
            }else{
                ase1.isHidden = false
                ase2.isHidden = true
            }

            if ganba1.isHidden == false{
                ganba1.isHidden = true
                ganba2.isHidden = false
            }else{
                ganba1.isHidden = false
                ganba2.isHidden = true
            }

            if goal.isHidden == true{
                goal.isHidden = false
            }
            
        }
        
        //CountIntが100になったら画面を遷移させる
        if CountInt == 100 {
            
            //timerを停止
            timer.invalidate()
            
            //画面を遷移させる(segue(toResult)を実行させる)
            self.performSegue(withIdentifier: "toResult", sender: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //数値を文字列へ変換してCountLabel.textへ入れる
         CountLabel.text = CountInt.description
         
         //非表示
         Cara1.isHidden = true
         ase1.isHidden = true
         ase2.isHidden = true
         ganba1.isHidden = true
         ganba2.isHidden = true
         goal.isHidden = true
         
         //表示
         Cara2.isHidden = false
        
         //timer変数へNSTimer関数(0.1秒間毎にonUpdate関数を実行させる)を入れる
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameViewController.onUpdate), userInfo: nil, repeats: true)
        
    }
    
    //timer処理(0.1秒ごとに実行される)
    @objc func onUpdate(timer : Timer){
        CountTimer = CountTimer + 0.1
    }

}
