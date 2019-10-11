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
}

extension Entry {
    convenience init(title: String, notes: String? = nil, mood: EntryMood = .😐, timestamp: String? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.notes = notes
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
}
