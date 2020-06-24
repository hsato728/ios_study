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
    //解説
    var meaning = String()
    
    //問題と解説を格納
    func setQ(q: String, m: String) {
        question = q
        meaning = m
    }
    
    //問題を読み出し
    func getQ() -> String {
        return question
    }
    //解説を読み出し
    func getM() -> String {
        return meaning
    }

}
