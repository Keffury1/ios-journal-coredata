//
//  EntryController.swift
//  Journal
//
//  Created by Bobby Keffury on 10/10/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
       
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            let allEntries = try moc.fetch(fetchRequest)
            return allEntries
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
    }
    
    func Create(title: String, notes: String? = nil) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let result = formatter.string(from: date)

        
        let _ = Entry(title: title, notes: notes, timestamp: result)
       
        
        saveToPersistentStore()
    }
    
    func Update(entry: Entry, title: String, notes: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let result = formatter.string(from: date)
        
        entry.title = title
        entry.notes = notes
        entry.timestamp = result
        
        saveToPersistentStore()
        
    }
    
}
