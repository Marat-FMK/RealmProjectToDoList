//
//  TasksViewController.swift
//  RealmProjectToDoList
//
//  Created by Marat Fakhrizhanov on 26.07.2024.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {

    
    var taskList: TaskList!
    
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = taskList.name
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        
        currentTasks = taskList.tasks.filter("isComplete = false")
        completedTasks = taskList.tasks.filter("isComplete = true")
        
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }


    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 1 ? completedTasks.count : currentTasks.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 1 ? "Completed tasks" : "Current tasks"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        
        let task = indexPath.section == 1 ? completedTasks[indexPath.row] : currentTasks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = task.name
        content.secondaryText = task.note
    
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = indexPath.section == 1 ? completedTasks[indexPath.row] : currentTasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE") { _, _, _ in
            StorageManager.shared.delete(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        
        let editAction = UIContextualAction(style: .normal, title: "EDIT") { _, _, isDone in
            self.showAlert(with: task) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let donetitle = indexPath.section == 1 ?  "unDone"  :  "Done"
        
        let doneAction = UIContextualAction(style: .normal, title: donetitle) { _, _, isDone in
            StorageManager.shared.done(task)
            let indexPathForCurrentTask = IndexPath(row: self.currentTasks.count-1, section: 0)//-определяем индекс строки(куда вставить) если задача текущая
            
            let indexPathForCompletionTask = IndexPath(row: self.completedTasks.count-1, section: 1)// определяем строку куда поместить если задача Таск решен
            
            let destinationIndexForRow = indexPath.section == 0 ? indexPathForCompletionTask : indexPathForCurrentTask // решаем куда пометсить изходя из секции
            
            tableView.moveRow(at: indexPath, to: destinationIndexForRow) // перемешаем с анимацией из секси в секцию
            
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [doneAction,editAction,deleteAction])
      }
   
}


extension TasksViewController {
    
    private func showAlert(with task: Task? = nil,  completion: (() -> Void)? = nil) {
        let title = task != nil ? "Edit task" : "New task"
        
        let alert = UIAlertController.createAlert(withTitle: title, andMessage: "What do you want to do?")
        
        alert.action(with:task) { newValue, note in
            if let task = task, let completion = completion  {
                StorageManager.shared.rename(task, to: newValue, withNote: note)
                completion()
            } else {
                self.saveTask(withName: newValue, andNote: note)
            }
        }
        present(alert,animated: true)
        
    }
    
    private func saveTask(withName name: String, andNote note: String ) {
        let task = Task(value:[name,note])
        StorageManager.shared.save(task, to: taskList)
        let rowIndex = IndexPath(row: currentTasks.index(of: task) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
    
}
