//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Bobby Keffury on 10/10/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: Int16, CaseIterable {
    case 🙁 = 0
    case 😐 = 1
    case 🙂 = 2
    
    var name: String {
        switch self {
        case .🙁:
            return "🙁"
        case .😐:
            return "😐"
        case .🙂:
            return "🙂"
        }
    }
    
    init?(stringName: String) {
        switch stringName {
        case "🙁":
            self = .🙁
        case "😐":
            self = .😐
        case "🙂":
            self = .🙂
        default:
            return nil
        }
    }
}

extension Entry {
    convenience init(title: String, notes: String? = nil, mood: EntryMood = .😐, timestamp: String, identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.notes = notes
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let mood = EntryMood(stringName: entryRepresentation.mood),
            let identifierString = entryRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString) else {
                return nil
                
        }
        
        self.init(title: entryRepresentation.title, notes: entryRepresentation.notes, mood: mood, timestamp: entryRepresentation.timestamp, identifier: identifier, context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let mood = EntryMood(rawValue: mood) else {
                return nil
        }
        
        return EntryRepresentation(title: title, timestamp: timestamp!, notes: notes, mood: mood.name, identifier: identifier?.uuidString ?? "")
        
    }
    
}
