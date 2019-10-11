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
    
   
    
    func saveToPersistentStore() {
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
       
    }
    
    
    func Create(title: String, notes: String? = nil, mood: EntryMood) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let result = formatter.string(from: date)

        
        let _ = Entry(title: title, notes: notes, mood: mood, timestamp: result)
       
        
        saveToPersistentStore()
    }
    
    func Update(entry: Entry, title: String, notes: String, mood: EntryMood) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let result = formatter.string(from: date)
        
        entry.title = title
        entry.notes = notes
        entry.timestamp = result
        entry.mood = mood.rawValue
        
        saveToPersistentStore()
        
    }
    
}
