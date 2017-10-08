//
//  TodoModel.swift
//  MinimumMVCSample
//
//  Created by maekawakazuma on 2017/10/08.
//  Copyright © 2017 maekawakazuma. All rights reserved.
//

import Foundation
import RealmSwift

class TodoModel: NSObject{
    let realm = try! Realm()
    var todos: Results<Todo>?
    var notificationToken: NotificationToken? = nil
    
    var delegate: TodoModelProtocol?
    
    
    override init() {
        super.init()
        todos = realm.objects(Todo.self)
        notificationToken = todos?.addNotificationBlock({ [weak self] (changes) in
            self?.delegate?.updateUI()
        })
    }
    
    deinit {
        notificationToken?.stop()
    }
    
    func addTodo(text: String){
        let realm = try! Realm()
        try! realm.write {
            realm.add( Todo(text: text) )
        }
    }
    
    func deleteTodo(index: Int){
        guard let todo = todos else { return }
        try! realm.write {
            realm.delete(todo[index])
        }
    }
    
    
}

protocol TodoModelProtocol {
    func updateUI()
}
