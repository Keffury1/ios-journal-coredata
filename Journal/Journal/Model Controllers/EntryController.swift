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
    
    typealias CompletionHandler = (Error?) -> Void
    
    let baseURL = URL(string: "https://journal-5acd6.firebaseio.com/")!
    
    
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        let identifier = entry.identifier ?? UUID()
        
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(nil)
                return
            }
            representation.identifier = identifier.uuidString
            entry.identifier = identifier
            
            request.httpBody = try JSONEncoder().encode(representation)
        
        } catch {
            print("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                print("Error PUTting entry to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(nil)
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            print("Deleted entry with UUID: \(identifier.uuidString)")
            
            completion(error)
        }.resume()
    }
    
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

        
        let entry = Entry(title: title, notes: notes, mood: mood, timestamp: result)
       
        put(entry: entry)
        
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
        
        put(entry: entry)
        
        saveToPersistentStore()
        
    }
    
}
