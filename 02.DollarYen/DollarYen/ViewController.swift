//
//  ViewController.swift
//  DollarYen
//
//  Created by 佐藤浩樹 on 2020/06/04.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var input = Double()
    var result = Double()
    var rate = Double()
    var isYenToDollar = Bool()
    
    @IBOutlet weak var inputCurrency: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var selector: UISegmentedControl!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultCurrency: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rate = 120.0
        input = 0
        result = 0
        
        rateLabel.text = String(format: "%.1f", rate)
        isYenToDollar = true
        
        inputField.delegate = self;
    }
    
    func convert() {
        // 円→ドル変換の場合
        if isYenToDollar == true {
            // ドルの金額　＝　円の入力値を変換レートで割った値
            result = input / rate;
            // 小数点以下2桁までのみをresultLabelに表示
            resultLabel.text = String(format: "%.2f", result)
            // ドル→円変換の場合
        } else if isYenToDollar == false {
            // 円の金額　＝　ドルの入力値を変換レートで掛けた値
            result = input * rate;
            // 小数点以下を切り捨て、整数部分のみをresultLabelに表示
            resultLabel.text = String(format: "%.0f", result)
        }
    }
    
    @IBAction func changeCalcMethod(sender: AnyObject) {
        // 左側（円→ドル）が選択された場合（selectorの値が「0」のとき）
        if sender.selectedSegmentIndex == 0 {
            isYenToDollar = true
            inputCurrency.text = "円"
            resultCurrency.text = "ドル"
            // 右側（ドル→円）が選択された場合（selectorの値が「1」のとき）
        } else if sender.selectedSegmentIndex == 1 {
            isYenToDollar = false
            inputCurrency.text = "ドル"
            resultCurrency.text = "円"
        }
        // 通貨を変換
        self.convert()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 受け取った入力値（String型の文字列）をDoubleに変換し、inputに代入
        input = atof(textField.text!)
        // キーボードを閉じる
        textField.resignFirstResponder()
        //通貨を変換
        self.convert()
        return true
    }

}

