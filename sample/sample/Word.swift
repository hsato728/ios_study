//
//  Word.swift
//  sample
//
//  Created by 佐藤浩樹 on 2020/06/23.
//  Copyright © 2020 ALJ. All rights reserved.
//

import Foundation
import RealmSwift

class Word: Object{
    // 名前
    @objc dynamic var name = ""
    // 説明文
    @objc dynamic var desc = ""
    // 完了フラグ
    @objc dynamic var isComplete = false
}
