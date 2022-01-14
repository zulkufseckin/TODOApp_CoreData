//
//  CoreDataManager.swift
//  todo
//
//  Created by Z.Seckin on 14.01.2022.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    func getManagedContext() -> NSManagedObjectContext {
        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appdelegate?.persistentContainer.viewContext
        return managedContext!
    }
    
    func getAllItems(_ completion: @escaping (Result<[Item], Error>) -> Void) {
        var items: [Item] = []
        do {
            items = try getManagedContext().fetch(Item.fetchRequest())
            completion(.success(items))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    func deleteItem(item: Item, _ completion: @escaping (Result<Item?, Error>) -> Void) {
        getManagedContext().delete(item)
        do {
            try getManagedContext().save()
            completion(.success(item))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    func createItem(title: String, details: String?, _ completion: @escaping (Result<Item?, Error>)-> Void) {
        let newItem = Item(context: getManagedContext())
        newItem.title = title
        newItem.details = details
        
        do {
            try getManagedContext().save()
            completion(.success(newItem))
        } catch let error as NSError {
            completion(.failure(error))
        }
        
    }
    
    func updateItem(item: Item? = nil, _ completion: @escaping (Result<Item?, Error>) -> Void) {
        
        do {
            try getManagedContext().save()
            completion(.success(item))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
}
