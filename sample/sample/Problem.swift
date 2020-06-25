//
//  Problem.swift
//  sample
//
//  Created by 佐藤浩樹 on 2020/06/24.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class Problem: NSObject {
    //問題
    var question = String()
    //説明文
    var meaning = String()
    //完了フラグ
    var isComplete = false
    
    //問題と解説を格納
    func setQ(q: String, m: String, c:Bool) {
        question = q
        meaning = m
        isComplete = c
    }
    
    //問題を読み出し
    func getQ() -> String {
        return question
    }
    //解説を読み出し
    func getM() -> String {
        return meaning
    }
    //完了フラグを読み出し
    func getC() -> Bool {
        return isComplete
    }

}
