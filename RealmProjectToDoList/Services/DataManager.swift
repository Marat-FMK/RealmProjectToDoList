//
//  DataManager.swift
//  RealmProjectToDoList
//
//  Created by Marat Fakhrizhanov on 26.07.2024.
//

import Foundation
import RealmSwift

class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    func createTempData(completion: @escaping () -> Void) {
        if !UserDefaults.standard.bool(forKey: "done") { // Создаем ЮзерДиф с ключем для того что бы в первый раз при загрузке приложения сформировалась маленькая демонстрационна база
            
            let moviesList = TaskList(value: ["Movies List",Date(),[["Best Films"], ["Italian Job", "on MINI Cooper R53", Date(), true ]]]) // Запихнуть все в одно - нечитаемо нихрена __)
            
            let shoppingList = TaskList() // создаем экземпляр ТаскЛист
            
            shoppingList.name = "ShoppingList"
            
            let milk = Task() // создаем экземпляр Таск
            milk.note = "2L" // иниц значения наме
            
            let bread = Task(value: ["Bread", "for toster", Date(), false]) // пример инициализации в квадр скобках
            
            let apples = Task(value: ["name":"Antonovka","note":"many"]) // как в словаре ключ-  name из класса Task,  note из класса Task и тд
            
            shoppingList.tasks.append(milk) // Добавляем в переменную (массив) Тасков листаТаскЛист
            shoppingList.tasks.insert(contentsOf: [bread,apples], at: 0) // Добавлям в переменную (массив) Таско другим способом ., в начало (0) или в какую то строку (какая строка в at: _ вставить номер)
            
            DispatchQueue.main.async {
                StorageManager.shared.save([shoppingList,moviesList]) // сохраняем в БД
                UserDefaults.standard.set(true, forKey: "done") //база сработала и больше не появится
                completion()
            }
        }
    }
}
