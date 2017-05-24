//
//  AuthenticationViewController.swift
//  UC_CoreData_Test
//
//  Created by Katie Collins on 4/3/17.
//  Copyright © 2017 CollinsInnovation. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class AuthenticationViewController: UIViewController {
    
    @IBOutlet var emailTF: UITextField!
    
    @IBOutlet var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerUser(_ sender: Any) {
        
        guard let email = emailTF.text, let password = passwordTF.text else {
            // ADD error checking
            // Validate that email is a valid email
            // Validate that password is good enough
            print("Enter a valid email and password")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            guard let u = user else {
                appDelegate.uid = nil
                return
            }
            
            appDelegate.uid = u.uid
            
            self.segueToTabCntrl()
        }
        
    }
    
    @IBAction func signInUser(_ sender: Any) {
        
        guard let email = emailTF.text, let password = passwordTF.text else {
            // ADD error checking
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate

            // Check that user isn't nil
            guard let u = user else {
                appDelegate.uid = nil
                return
            }
            
            appDelegate.uid = u.uid
            
            self.segueToTabCntrl()
        }
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        
        let alert = UIAlertController(title: "Forgot Password", message: "Enter email linked with account. You will recieve an email to reset password.", preferredStyle: .alert)
        
        let sendAction = UIAlertAction(title: "Send", style: .default){(_) in
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
    
    func segueToTabCntrl() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchToTabCntrl()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        passwordTF.resignFirstResponder()
        emailTF.resignFirstResponder()
    }

}
