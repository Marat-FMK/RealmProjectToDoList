//
//  Extension + UIAlertController.swift
//  RealmProjectToDoList
//
//  Created by Marat Fakhrizhanov on 26.07.2024.
//

import Foundation
import UIKit


extension UIAlertController {
    
    static func createAlert(withTitle title: String, andMessage message : String) -> UIAlertController {
        UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    func action( with taskList: TaskList?, completion: @escaping(String) -> Void) {
        let doneButton = taskList == nil ? "Save" : "Update"
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return}
            guard !newValue.isEmpty else {return }
            completion(newValue)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "List name"
            textField.text = taskList?.name
        }
    }
    
    func action(with task: Task?, completion: @escaping (String,String) -> Void) {
        let title = task == nil ? "Save" : "Update"
        
        let saveAction = UIAlertAction(title: title, style: .default) { _ in
            guard let newTask = self.textFields?.first?.text else { return }
            guard !newTask.isEmpty else { return }
            
            if let note = self.textFields?.last?.text, !note.isEmpty {
                completion(newTask,note)
            }else {
                completion(newTask,"")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.text = task?.name
            textField.placeholder = "New task"
        }
        addTextField { textfield in
            textfield.placeholder = "Note"
            textfield.text = task?.note
        }
        
    }
}
