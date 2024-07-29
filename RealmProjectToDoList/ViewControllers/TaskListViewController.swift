//
//  TaskListViewController.swift
//  RealmProjectToDoList
//
//  Created by Marat Fakhrizhanov on 26.07.2024.
//

import UIKit
import RealmSwift

class TaskListViewController: UITableViewController {

    private var taskLists: Results<TaskList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTempData()
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        
        navigationItem.rightBarButtonItem = addButtonItem
        navigationItem.leftBarButtonItem = editButtonItem
        
        taskLists = StorageManager.shared.realm.objects(TaskList.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskLists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        let taskList = taskLists[indexPath.row]
        cell.configure(with: taskList)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskList = taskLists[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(taskList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in // isDone - момент когда должен закрыться свайп что бы не зависло прилодение
            self.showAlert(with: taskList) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, isDone in
            StorageManager.shared.done(taskList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone (true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return UISwipeActionsConfiguration(actions: [doneAction,editAction,deleteAction])// -  в массив добавляем кнопки слева направо - доне будет самая правая и при длинном свайпе будет задача уходить в выполненные в приложении
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        guard let taskVC = segue.destination as? TasksViewController else { return }
        let taskList = taskLists[indexPath.row]
        taskVC.taskList = taskList
    }
    
    @objc func addButtonPressed() {
        showAlert()
    }
    
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
        
        taskLists = sender.selectedSegmentIndex == 0
        ? taskLists.sorted(byKeyPath: "date")
        : taskLists.sorted(byKeyPath: "name")
        tableView.reloadData()
    }
    }


extension TaskListViewController {
    
    private func showAlert(with taskList: TaskList? = nil, completion: (() -> Void)? = nil) {
        let title = taskList != nil ? "Edit list" : "New list"
        
        let alert = UIAlertController.createAlert(withTitle: title, andMessage: "Please set title for new task list" )
        
        alert.action(with: taskList) { newValue in
            if let taskList = taskList, let completion = completion {
                StorageManager.shared.rename(taskList, to: newValue)
                completion()
            } else {
                self.save(taskList: newValue)
            }
        }
        present(alert, animated: true)
    }
        
    private func save(taskList: String) {
        let taskList = TaskList(value: [taskList])
        StorageManager.shared.save(taskList)
        let rowIndex = IndexPath(row: taskLists.index(of: taskList) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with:  .automatic)
    }
    private func createTempData() {
        DataManager.shared.createTempData {
            self.tableView.reloadData()
        }
    }
}
