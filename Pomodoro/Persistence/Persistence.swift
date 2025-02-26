//
//  Persistence.swift
//  Pomodoro
//
//  Created by Luis Amorim on 26/02/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Pomodoro")
        if let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.amorim.pomodoro")?.appendingPathComponent("Pomodoro.sqlite") {
            let storeDescription = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [storeDescription]
        }
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Error loading Core Data: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
