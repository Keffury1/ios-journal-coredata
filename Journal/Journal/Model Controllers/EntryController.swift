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
            
            try CoreDataStack.shared.save()
            
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
    
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data returned by the data task")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dictionaryOfEntries = try decoder.decode([String: EntryRepresentation].self, from: data)
                let entryRepresentations = Array(dictionaryOfEntries.values)
                try self.updateEntries(with: entryRepresentations)
                completion(nil)
                
            } catch {
                print("Error decoding entry representations: \(error)")
                completion(error)
                return
            }
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
    
    
    func Create(title: String, notes: String? = nil, mood: EntryMood) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let result = formatter.string(from: date)

        
        let entry = Entry(title: title, notes: notes, mood: mood, timestamp: result)
       
        put(entry: entry)
        
        
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
        
        
    }
    
    
    func updateEntries(with representations: [EntryRepresentation]) throws {
        
        let entriesWithID = representations.filter({ $0.identifier != nil })
        
        let identifiersToFetch = entriesWithID.compactMap({ UUID(uuidString: $0.identifier!) })
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier in %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
            do {
                
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let representation = representationsByID[id] else {
                            continue
                    }
                    self.update(entry: entry, entryRepresentation: representation)
                    
                    entriesToCreate.removeValue(forKey: id)
                }
                
                for representation in entriesToCreate.values {
                    let _ = Entry(entryRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching tasks for UUIDs: \(error)")
            }
        }
        
        try CoreDataStack.shared.save(context: context)
        
        
    }
    
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        
        let mood = EntryMood(stringName: entryRepresentation.mood) ?? EntryMood.😐
        
        entry.title = entryRepresentation.title
        entry.notes = entryRepresentation.notes
        entry.timestamp = entryRepresentation.timestamp
        entry.mood = mood.rawValue
        
    }
    
}
