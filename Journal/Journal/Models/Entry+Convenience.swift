//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Bobby Keffury on 10/10/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, notes: String? = nil, timestamp: String? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.notes = notes
        self.timestamp = timestamp
    }
}
