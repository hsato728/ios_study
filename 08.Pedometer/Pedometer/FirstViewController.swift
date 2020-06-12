//
//  FirstViewController.swift
//  Pedometer
//
//  Created by 佐藤浩樹 on 2020/06/09.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import CoreMotion
import MessageUI

class FirstViewController: UIViewController, MFMailComposeViewControllerDelegate {

    // 歩数関連のデータを取得するための変数
    var pedometer = CMPedometer()
    //歩数の合計
    var stepCount = Int()

    @IBOutlet weak var stepCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 歩数取得開始
        startStepCounting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendMail(_ sender: AnyObject) {
        //MFMailComposeViewControllerを生成
        let mailViewController = MFMailComposeViewController()
        //件名と本文の内容
        let subject = "歩きました！"
        let message = String(format: "たった今、私は %d 歩きました！", stepCount)
        //MFMailComposeViewControllerからのDelegate通知を受け取り
        mailViewController.mailComposeDelegate = self
        //件名を指定
        mailViewController.setSubject(subject)
        //本文を指定
        mailViewController.setMessageBody(message, isHTML: false)
        //MailPicker（メール送信画面）を呼び出し
        self.present(mailViewController, animated: true, completion: nil)
    }
    
    @IBAction func resetButtonAction(sender: AnyObject) {
        self.reset()
    }
    
    //リセット処理
    func reset() {
        //各変数をリセット
        self.stepCount = 0
        pedometer = CMPedometer()
        
        // 歩数取得開始
        startStepCounting()
        
        //ラベルの値をリセット
        self.stepCountLabel.text = "\(self.stepCount)"
    }
    
    // 歩数を取得する関数
    func startStepCounting() {
        // CMPedometerの確認
        if(CMPedometer.isStepCountingAvailable()){
            // 計測開始
            self.pedometer.startUpdates(from: NSDate() as Date) {
                (data: CMPedometerData?, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil){
                        // 歩数
                        self.stepCount = Int(truncating: data!.numberOfSteps)
                        // 結果をラベルに出力
                        self.stepCountLabel.text = "\(self.stepCount)"
                    }
                })
            }
        }
        
    }
    
    //メール送信画面終了時に呼び出される
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
