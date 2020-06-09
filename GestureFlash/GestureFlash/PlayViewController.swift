//
//  PlayViewController.swift
//  GestureFlash
//
//  Created by 佐藤浩樹 on 2020/06/08.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var completedGesturesLabel: UILabel!
    @IBOutlet weak var gestureImage: UIImageView!
    
    //ゲームの経過時間を計測
    var startTime = NSDate()
    //こなしたジェスチャーの数を管理
    var completedGestures = Int()
    //現在の問題で、発見すべきジェスチャーを記録
    var currentGesture = Int()
    //経過時間を画面に表示するためのタイマー
    var timer = Timer()
    var timerCount = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ///こなしたジェスチャーの数を0にリセット
        completedGestures = 0
        //Gesture Recognizersをセット
        self.setGestureRecognizers()
        //最初の問題を表示
        self.nextProblem()
        
        //経過時間を表示するタイマーの始動
        //0.1秒毎に「-(void)onTimer」が呼ばれる
        timerCount = 0
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(PlayViewController.onTimer(timer:)),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func onTimer(timer: Timer) {
        timerCount = timerCount + 0.1
        timeLabel.text = String(format: "%.1f", timerCount)
    }
    
    //結果表示画面へのSegueの発動
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //所要時間を計測
        var elapsedTime = startTime.timeIntervalSinceNow
        elapsedTime = -(elapsedTime)
        //ResultViewController（RVC）のインスタンスを作成し、
        //RVCクラスのメンバー変数である「time」に値を渡す
        if segue.identifier == "toResultView" {
            let rvc = segue.destination as! ResultViewController
            rvc.time = elapsedTime
        }
    }
    
    //次の問題を表示
    func nextProblem() {
        //もし出題規定数（ジェスチャー30個）に達している場合
        if completedGestures == 30 {
            //結果表示画面へのSegueを始動
            self.performSegue(withIdentifier: "toResultView", sender: self)
        } else {
            //配列にジェスチャーを示す画像取り込み
            let gestureIcons = [
                UIImage(named: "swipe-right"),
                UIImage(named: "swipe-left"),
                UIImage(named: "swipe-up"),
                UIImage(named: "swipe-down"),
                UIImage(named: "pinch-in"),
                UIImage(named: "pinch-out"),
                UIImage(named: "rotate-right"),
                UIImage(named: "rotate-left")
            ]
            //乱数をもとに、次のジェスチャーを選択
            //Xcodeで不可能な動きがあるため種類を3つに制限
            currentGesture = Int(arc4random() % 3)
            NSLog("got new gesture current: %d", currentGesture)
            //画面に出てるジェスチャーの画像を差し替え、問題番号を更新
            gestureImage.image = gestureIcons[currentGesture]
            completedGesturesLabel.text = String(format: "%d", completedGestures)
        }
    }
    
    //Gesture Recognizerをセット
    func setGestureRecognizers() {
        //右向きのSwipe（1本指でなぞる）の認識
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlayViewController.swipeRightDetected(sender:)))
        swipeRightRecognizer.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRightRecognizer)
        //左向きのSwipe（1本指でなぞる）の認識
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlayViewController.swipeLeftDetected(sender:)))
        swipeLeftRecognizer.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeftRecognizer)
        //上向きのSwipe（1本指でなぞる）の認識
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlayViewController.swipeUpDetected(sender:)))
        swipeUpRecognizer.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUpRecognizer)
    }
    
    //右向きスワイプ検知時に呼ばれるメソッド
    @objc func swipeRightDetected(sender: UIGestureRecognizer) {
        NSLog("右向きSwipe")
        NSLog("current: %d", currentGesture)
        //正解が右向きSwipe（0番）なら
        if currentGesture == 0 {
            NSLog("NEXT")
            completedGestures += 1
            self.nextProblem()
        }
    }
    //左向きスワイプ検知時に呼ばれるメソッド
    @objc func swipeLeftDetected(sender: UIGestureRecognizer) {
        NSLog("左向きSwipe")
        NSLog("current: %d", currentGesture)
        //正解が右向きSwipe（0番）なら
        if currentGesture == 1 {
            NSLog("NEXT")
            completedGestures += 1
            self.nextProblem()
        }
    }
    //上向きスワイプ検知時に呼ばれるメソッド
    @objc func swipeUpDetected(sender: UIGestureRecognizer) {
        NSLog("上向きSwipe")
        NSLog("current: %d", currentGesture)
        //正解が右向きSwipe（0番）なら
        if currentGesture == 2 {
            NSLog("NEXT")
            completedGestures += 1
            self.nextProblem()
        }
    }

}
