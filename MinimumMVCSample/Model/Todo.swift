//
//  Todo.swift
//  MinimumMVCSample
//
//  Created by maekawakazuma on 2017/10/05.
//  Copyright © 2017 maekawakazuma. All rights reserved.
//

import Foundation
import RealmSwift

class Todo: Object, Codable{
    @objc dynamic var id = 0
    @objc dynamic var text = ""
    @objc dynamic var completed = false
    
    convenience init(text: String) {
        self.init()
        self.id = Int(arc4random_uniform(UINT32_MAX))
        self.text = text
    }
    
    override static func primaryKey()->String? {
        return "text" // 普通はidで管理する
    }
    
}

