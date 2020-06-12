//
//  Problem.swift
//  Quiz
//
//  Created by 佐藤浩樹 on 2020/06/05.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class Problem: NSObject {
    //問題文
    var question = String()
    //答え（「○」なら「0」、「×」なら「1」）
    var answer = Int()
    
    //問題文と答えを格納
    func setQ(q: String, a: Int) {
        question = q
        answer = a
    }
    
    func getQ() -> String {
        return question
    }
    //答えを読み出し
    func getA() -> Int {
        return answer
    }
}
