//
//  SettingsViewController.swift
//  UC_CoreData_Test
//
//  Created by Katie Collins on 2/15/17.
//  Copyright © 2017 CollinsInnovation. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    var ref: FIRDatabaseReference?
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        ref = FIRDatabase.database().reference()
        
        guard let currentUserID = appDelegate.uid else {
            self.uid = nil
            return
        }
        
        self.uid = currentUserID
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
        guard let currentUserID = self.uid else {
            let alert = UIAlertController(title: "Error", message: "We apologize. Something went wrong, and we cannot allow you to change your password at the moment. Please try again.", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alert.addAction(closeAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "Change Password", message: "You will recieve a link to change your password via email. Please enter the email address linked with this account.", preferredStyle: .alert)
        
        let sendAction = UIAlertAction(title: "Send Reset Code", style: .default){(_) in
            let emailTF = alert.textFields![0]
            let email = emailTF.text!
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
                // Add code if need be
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(sendAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "authVC") as! AuthenticationViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
}
