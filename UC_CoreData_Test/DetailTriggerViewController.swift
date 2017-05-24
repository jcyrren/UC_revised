//
//  DetailTriggerViewController.swift
//  UC_CoreData_Test
//
//  Created by Katie Collins on 1/31/17.
//  Copyright © 2017 CollinsInnovation. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class DetailTriggerViewContoller: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //var entries: [Entry] = []
    var entries: NSDictionary?
    var dates: [String] = []
    
    let pickerData = ["PUCAI Score", "Number of Stools", "Stool Consistency", "Nocturnal", "Rectal Bleeding", "Activity Level", "Abdominal Pain"]
    
    var triggerName: String! {
        didSet {
            navigationItem.title = triggerName
        }
    }
    
    var maxHeight = 85
    
    var ref: FIRDatabaseReference?
    var uid: String?
    
    @IBOutlet var graph: GraphView!
    @IBOutlet var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        /*let context = appDelegate.persistentContainer.viewContext
        
        do {
            let unfilteredEntries = try context.fetch(Entry.fetchRequest()) as! [Entry]
            self.entries = filterEntries(unfilteredEntries)
            
            guard entries.count > 0 else {
                print("ERROR")
                return
                // later change this to show on the graph that no data has been entered yet
            }
            
            self.dates = setUpDates()
            
            picker.dataSource = self
            picker.delegate = self
            
            setUpGraphWithData(data: pucaiArray())
            
        }
        catch {
            print("ERROR")
        }*/
        
        ref = FIRDatabase.database().reference()
        
        guard let currentUserID = appDelegate.uid else {
            self.uid = nil
            return
        }
        
        self.uid = currentUserID
        
        retrieveFirebaseData()
        
        picker.dataSource = self
        picker.delegate = self
        
    }
    
    func retrieveFirebaseData() {
        
        guard let userID = uid else {
            print("ERROR: no current user")
            return
        }
        
        ref?.child("users").child(userID).child("entries").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let unfilteredEntries = snapshot.value as? NSDictionary
            self.entries = self.filterEntries(unfilteredEntries)
            
            if self.entries != nil && self.entries!.count > 0 {
                //self.dates = self.entries!.allKeys as! [String]
                self.setUpGraphWithData(data: self.pucaiArray())
            } else {
                print("ERROR: no entries /n Cannot make graph until data is entered")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /*
    func filterEntries(_ data: [Entry]) -> [Entry] {
        var filteredEntries: [Entry] = []
        for entry in data {
            if let triggers = entry.triggerArrayAsString?.components(separatedBy: ";") {
                if triggers.contains(triggerName) { filteredEntries.append(entry) }
            }
        }
        return filteredEntries // these are the entries wherein the trigger occured
    }*/
    
    func filterEntries(_ data: NSDictionary?) -> NSDictionary? {
        
        guard let data = data else {
            return nil
        }
        
        var filteredEntries = NSMutableDictionary()
        
        for (k, v) in data {
            let dict = v as! NSDictionary
            let trigString = dict["triggerArrayAsString"] as? String
            if let triggers = trigString?.components(separatedBy: ";") {
                if triggers.contains(triggerName) {
                    filteredEntries[k] = v
                    self.dates.append(k as! String)
                }
            }
        }
        
        return filteredEntries // these are the entries wherein the trigger occured
    }
    
    func pucaiArray() -> [Int]{
        var pucai: [Int] = []
        
        for d in dates {
            let entry = entries?[d] as! NSDictionary
            pucai.append(Int(entry["pucaiScore"] as! Int16))
        }
        
        
        maxHeight = 85
        return pucai
    }
    
    func nocturnalArray() -> [Int]{
        var nocturnal: [Int] = []
        for d in dates {
            let entry = entries?[d] as! NSDictionary
            nocturnal.append(Int(entry["nocturnal"] as! Int16))
        }
        maxHeight = 1
        return nocturnal
    }
    
    func bleedingArray() -> [Int]{
        var rectalBleeding: [Int] = []
        for d in dates {
            let entry = entries?[d] as! NSDictionary
            rectalBleeding.append(Int(entry["rectalBleeding"] as! Int16))
        }
        maxHeight = 3
        return rectalBleeding
    }
    
    func activityLevelArray() -> [Int]{
        var activityLevel: [Int] = []
        for d in dates {
            let entry = entries?[d] as! NSDictionary
            activityLevel.append(Int(entry["activityLevel"] as! Int16))
        }
        maxHeight = 2
        return activityLevel
    }
    
    func abdPainArray() -> [Int]{
        var abdominalPain: [Int] = []
        for d in dates {
            let entry = entries?[d] as! NSDictionary
            abdominalPain.append(Int(entry["abdominalPain"] as! Int16))
        }
        maxHeight = 2
        return abdominalPain
    }
    
    func numStoolsArray() -> [Int]{
        var numStools: [Int] = []
        for d in dates {
            let entry = entries?[d] as! NSDictionary
            numStools.append(Int(entry["numStools"] as! Int16))
        }
        maxHeight = 3
        return numStools
    }
    
    func consistencyArray() -> [Int]{
        var stoolConsistency: [Int] = []
        for d in dates {
            let entry = entries?[d] as! NSDictionary
            stoolConsistency.append(Int(entry["stoolConsistency"] as! Int16))
        }
        maxHeight = 2
        return stoolConsistency
    }
    
    /*
    func setUpDates() -> [String]{
        var dates: [String] = []
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .short
        for e in entries {
            let date = e.date
            dates.append(myFormatter.string(from: date as! Date))
        }
        return dates
    }
    
    func pucaiArray() -> [Int]{
        var pucai: [Int] = []
        for e in entries {
            pucai.append(Int(e.pucaiScore))
        }
        maxHeight = 85
        return pucai
    }
    
    func nocturnalArray() -> [Int]{
        var nocturnal: [Int] = []
        for e in entries {
            nocturnal.append(Int(e.nocturnal))
        }
        maxHeight = 10
        return nocturnal
    }
    
    func bleedingArray() -> [Int]{
        var rectalBleeding: [Int] = []
        for e in entries {
            rectalBleeding.append(Int(e.rectalBleeding))
        }
        maxHeight = 30
        return rectalBleeding
    }
    
    func activityLevelArray() -> [Int]{
        var activityLevel: [Int] = []
        for e in entries {
            activityLevel.append(Int(e.activityLevel))
        }
        maxHeight = 10
        return activityLevel
    }
    
    func abdPainArray() -> [Int]{
        var abdominalPain: [Int] = []
        for e in entries {
            abdominalPain.append(Int(e.abdominalPain))
        }
        maxHeight = 10
        return abdominalPain
    }
    
    func numStoolsArray() -> [Int]{
        var numStools: [Int] = []
        for e in entries {
            numStools.append(Int(e.numStools))
        }
        maxHeight = 15
        return numStools
    }
    
    func consistencyArray() -> [Int]{
        var stoolConsistency: [Int] = []
        for e in entries {
            stoolConsistency.append(Int(e.stoolConsistency))
        }
        maxHeight = 10
        return stoolConsistency
    }
    */
    
    func setUpGraphWithData(data: [Int]) {
        graph.vals = data
        //graph.number = entries.count
        graph.number = dates.count
        graph.maxHeight = maxHeight
        graph.setNeedsDisplay()
    }
    
    // Returns the number of 'columns' to display...UIPickerView!
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // Returns the # of rows in each component.. ..UIPickerView!
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        let identifier = pickerData[row]
        
        switch (identifier) {
        case "PUCAI Score":
            setUpGraphWithData(data: pucaiArray())
        case "Stool Consistency":
            setUpGraphWithData(data: consistencyArray())
        case "Activity Level":
            setUpGraphWithData(data: activityLevelArray())
        case "Number of Stools":
            setUpGraphWithData(data: numStoolsArray())
        case "Abdominal Pain":
            setUpGraphWithData(data: abdPainArray())
        case "Rectal Bleeding":
            setUpGraphWithData(data: bleedingArray())
        case "Nocturnal":
            setUpGraphWithData(data: nocturnalArray())
        default:
            break
        }
    }

}
