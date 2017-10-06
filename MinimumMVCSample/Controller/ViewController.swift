//
//  ViewController.swift
//  MinimumMVCSample
//
//  Created by maekawakazuma on 2017/10/05.
//  Copyright © 2017 maekawakazuma. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var todos: Results<Todo>?
    var notificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        todos = realm.objects(Todo.self)
        // Observe Realm Notifications
        notificationToken = todos?.addNotificationBlock({ [weak self] (changes) in
            self?.tableView.reloadData()
        })
    }
    
    deinit {
        notificationToken?.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addButton(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            realm.add( Todo(text: self.textField.text!) )
        }
        self.textField.text = ""
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let todo = todos else { return cell }
        cell.textLabel?.text = todo[indexPath.row].text
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let todo = todos else { return }
            try! realm.write {
                realm.delete(todo[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

