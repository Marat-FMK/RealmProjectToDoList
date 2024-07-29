//
//  Extension + UITableViewCell.swift
//  RealmProjectToDoList
//
//  Created by Marat Fakhrizhanov on 26.07.2024.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func configure (with taskList: TaskList) {
        let currentTasks = taskList.tasks.filter("isComplete = false")
        let completedTasks = taskList.tasks.filter("isComplete = true")
        var content = defaultContentConfiguration()
        content.text = taskList.name
        
        if taskList.tasks.isEmpty {
            content.secondaryText = "0"
            accessoryType = .none
        }else if currentTasks.isEmpty {
            content.secondaryText = "\(completedTasks.count)" // или "\(completedTasks.count)" если нужно знать сколько задач выполнено
            accessoryType = .checkmark
        }else {
            content.secondaryText = "\(currentTasks.count)"
            accessoryType = .none
        }
        contentConfiguration = content
    }
}
