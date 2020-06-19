//
//  ToDo.swift
//  Todo
//
//  Created by 佐藤浩樹 on 2020/06/18.
//  Copyright © 2020 ALJ. All rights reserved.
//

import Foundation
import RealmSwift

class ToDo: Object{
    
    @objc dynamic var name = ""
    
    @objc dynamic var desc = ""
    
    @objc dynamic var isComplete = false
    
    @objc dynamic var createDate = NSDate(timeIntervalSince1970: 0)
    
    @objc dynamic var updateDate = NSDate(timeIntervalSince1970: 0)
}
