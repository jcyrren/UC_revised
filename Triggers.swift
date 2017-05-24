//
//  Triggers.swift
//  UC_CoreData_Test
//
//  Created by Katie Collins on 1/30/17.
//  Copyright © 2017 CollinsInnovation. All rights reserved.
//

import Foundation
import UIKit

class Triggers {
    var triggerNames: [String] = ["Milk", "Math Test", "Gluten", "Track Race", "Pizza", "Coffee"]
    
    func createTrigger(withName trig: String) {
        triggerNames.append(trig)
    }
    
    func removeTrigger(withName trig: String) {
        if let index = triggerNames.index(of: trig) {
            triggerNames.remove(at: index)
        }
    }
}
