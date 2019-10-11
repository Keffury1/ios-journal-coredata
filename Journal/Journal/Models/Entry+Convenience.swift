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
    convenience init(title: String, notes: String? = nil, identifier: UUID = UUID(), timestamp: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.notes = notes
        self.identifier = identifier
        
    }
}
