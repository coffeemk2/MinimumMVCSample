//
//  TodoModel.swift
//  MinimumMVCSample
//
//  Created by maekawakazuma on 2017/10/08.
//  Copyright © 2017 maekawakazuma. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

class TodoModel: NSObject{
    
    var todos: Results<Todo>?
    var notificationToken: NotificationToken? = nil
    var delegate: TodoModelProtocol?
    
    override init() {
        super.init()
        let realm = try! Realm()
        todos = realm.objects(Todo.self)
        notificationToken = todos?.addNotificationBlock({ [weak self] (changes) in
            self?.delegate?.updateUI()
        })
    }
    
    deinit {
        notificationToken?.stop()
    }
    
    func addTodo(text: String){
        postTodo(text: text) {
            let todo = Todo(text: text)
            self.storeTodo(todo: todo)
        }
    }
    
    func deleteTodo(at index: Int){
        let realm = try! Realm()
        guard let todo = todos else { return }
        try! realm.write {
            realm.delete(todo[index])
        }
    }
    
    func toggleComplete(at index: Int){
        let realm = try! Realm()
        guard let todos = todos else { return }
        try! realm.write {
            todos[index].completed = !todos[index].completed
        }
    }
    
    func fetchTodos() {
        Alamofire.request(Router.readTodos()).responseJSON { (response) in
            guard let data = response.result.value else { return }
            let jsonArray = data as! [Any]
            let todos = jsonArray.map({ (json) -> Todo in
                let data = try! JSONSerialization.data(withJSONObject: json)
                return try! JSONDecoder().decode(Todo.self, from: data)
            })
            self.storeTodos(todos: todos)
        }
    }
    
    private func postTodo(text: String, onSuccess: @escaping () -> Void){
        Alamofire.request(Router.createTodo(parameters: ["text": text])).response { (response) in
            if let err = response.error {
                print(err)
            } else {
                onSuccess()
            }
        }
    }
    
    private func storeTodo(todo: Todo){
        let realm = try! Realm()
        try! realm.write {
            realm.add(todo, update: true)
        }
    }
    
    private func storeTodos(todos: [Todo]) {
        todos.forEach{ storeTodo(todo: $0) }
    }
    
}


protocol TodoModelProtocol {
    func updateUI()
}
