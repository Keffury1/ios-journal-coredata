//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Bobby Keffury on 10/11/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    
    var title: String
    var timestamp: String
    var notes: String?
    var mood: String
    var identifier: String?
    
}
