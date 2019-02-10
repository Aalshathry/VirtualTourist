//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Al Shathry on 27/05/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    static let shared = DataController()
    
    private let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Virtual_Tourist")
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            completion?()
        }
    }
}

extension DataController {
    private func autoSaveViewContext(interval:TimeInterval = 30) {
        let timeInterval = interval > 0 ? interval : 30
        if interval <= 0 {
            print("Time interval cannot be negative")
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            print("Auto Saving...")
            self.autoSaveViewContext(interval: timeInterval)
        }
    }
}
