//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Bobby Keffury on 10/10/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentControl: UISegmentedControl!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        self.title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        
        var mood: EntryMood
        if let entryMoodString = entry?.mood, let entryMood = EntryMood(rawValue: entryMoodString) {
            mood = entryMood
        } else {
            mood = .😐
        }
        if let index = EntryMood.allCases.firstIndex(of: mood) {
            moodSegmentControl.selectedSegmentIndex = index
        }
        
        bodyTextView.text = entry?.notes
        
       
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty, let notes = bodyTextView.text, !notes.isEmpty else{ return }
        
        let moodIndex = moodSegmentControl.selectedSegmentIndex
        let mood = EntryMood.allCases[moodIndex]
        
        if let entry = entry {
            entryController?.Update(entry: entry, title: title, notes: notes, mood: mood)
        } else {
            entryController?.Create(title: title, notes: notes, mood: mood)
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}
