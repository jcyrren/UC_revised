//
//  DetailMedViewController.swift
//  UC_CoreData_Test
//
//  Created by Katie Collins on 2/2/17.
//  Copyright © 2017 CollinsInnovation. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseDatabase

// This is taken from online: https://gist.github.com/stinger/a8a0381a57b4ac530dd029458273f31a
extension String {
    //: ### Base64 encoding a string
    /*func base64Encoded() -> Data? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
            return data
        }
        return nil
    }*/
    
    //: ### Base64 decoding a string
    func base64Decoded() -> Data? {
        if let data = Data(base64Encoded: self) {
            //return String(data: data, encoding: .utf8)
            return data
        }
        return nil
    }
}

class DetailMedViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    var medName: String! {
        didSet {
            navigationItem.title = medName
        }
    }
        
    //var med: Medication!
    
    //var med: NSDictionary?
    var med: NSDictionary!
    
    var medDose: Double?
    
    var medFreq: Int32?
    
    var medTime: Date?
    
    var appearance: String?
    
    var key: String?
    
    let imagePicker = UIImagePickerController()
    
    //var data: NSData?
    var data: Data?
    
    var ref: FIRDatabaseReference?
    var uid: String?
    
    //var medIndex: Int!
    
    @IBOutlet var doseTF: UITextField!
    @IBOutlet var freqTF: UITextField!
    @IBOutlet var appTF: UITextField!
    
    @IBOutlet var timeTaken: UIDatePicker!
    override func viewDidLoad() {
        self.doseTF.delegate = self
        self.appTF.delegate = self
      //  self.freqTF.delegate = self
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        ref = FIRDatabase.database().reference()
        
        guard let currentUserID = appDelegate.uid else {
            self.uid = nil
            return
        }
        
        self.uid = currentUserID
        
        //self.retrieveMed()
        
        /*
        self.appearance = self.med.appearance
        self.medDose = self.med.dosage
        self.medFreq = self.med.dailyFreq
        
        self.key = self.med.imageKey
        print("key in class: \(self.key)")*/
        
        self.appearance = med.object(forKey: "appearance") as? String
        self.medDose = med.object(forKey: "dosage") as? Double
        self.medFreq = med.object(forKey: "dailyFreq") as? Int32
        
        self.key = med.object(forKey: "imageKey") as? String
        
        self.medTime = (med.object(forKey: "medTime") as? Date)!
        
        
        let dose: Double = self.medDose ?? 0.0
        //let freq: Int32 = self.medFreq ?? 0
        let medTime = self.timeTaken.date
        
        self.appTF.text = self.appearance ?? ""
        self.doseTF.text = "\(dose)"
        //self.freqTF.text = "\(freq)"
        
        //self.data = self.med.imageData
        /*let dataString = med?.object(forKey: "imageData") as? String
        guard let ds = dataString else {
            self.data = nil
            return
        }
        self.data = Data(base64Encoded: ds) as? NSData*/
        
        let dataString = med?.object(forKey: "imageData") as? String
        //self.data = dataString?.data(using: .)
        self.data = dataString?.base64Decoded()
        
        print("data: \(self.data)")
        
        if let imageData = data {
            print("able to open data")
            if let imageToDisplay = UIImage(data: imageData as Data) {
                print("put image in view")
                imageView.image = imageToDisplay
            }
        }
        
        print("image in view: \(imageView.image)")
        
        imagePicker.delegate = self
        timeTaken.date = medTime

    }
    
    func retrieveMed() {
        
        print("retrieving med")
        
        guard let database = ref, let currentUserID = uid else {
            print("could not retrieve")
            return
        }
        database.child("users").child(currentUserID).child("medications").child(medName).observeSingleEvent(of: .value, with: { (snapshot) in
                self.med = snapshot.value as? NSDictionary
        })
    }
    
    @IBAction func saveMed(_ sender: Any) {
        /*let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        print("original \(med)")
        
        context.delete(med)
        appDelegate.saveContext()
        
        let newMed = Medication(context: context)
        newMed.appearance = appTF.text!
        if let newFreq = Int32(freqTF.text!) {
            newMed.dailyFreq = newFreq
        } else {
            newMed.dailyFreq = 0
        }
        if let newDose = Double(doseTF.text!) {
            newMed.dosage = newDose
        } else {
            newMed.dosage = 0.0
        }
        newMed.name = medName
        //newMed.imageKey = med.imageKey
        newMed.imageKey = key
        newMed.imageData = data
        appDelegate.saveContext()
        med = newMed
        print("saving \(med)")
        */
        // FIREBASE!!!!
        guard let database = ref, let user = uid else {
            return
        }
        
        print("pre-opening, about to save: \(data)")
        
        if let openedData = data {
           // let dataString = String(data: openedData, encoding: .utf8)
            let dataString = openedData.base64EncodedString()
            print("data string: \(dataString)")
            print("med name: \(medName)")
/*let key = ref.child("posts").childByAutoId().key
 let post = ["uid": userID,
 "author": username,
 "title": title,
 "body": body]
 let childUpdates = ["/posts/\(key)": post,
 "/user-posts/\(userID)/\(key)/": post]
 ref.updateChildValues(childUpdates)*/
            //let key = database.child("users").child(user).child("medications").child("\(medName)")
            let updated_medication = ["imageKey": key ?? "", "imageData": dataString ?? "", "dosage": (Double(doseTF.text!) ?? 0.0) ,  "appearance": appTF.text!] as [String : Any]
            let childUpdate = ["/users/\(user)/medications/\(medName!)": updated_medication]
            database.updateChildValues(childUpdate)
            //database.child("users").child(user).child("medications").child("\(medName)").setValue(["imageKey": key ?? "", "imageData": dataString ?? "", "dosage": (Double(doseTF.text!) ?? 0.0) , "dailyFreq": (Int32(freqTF.text!) ?? 0), "appearance": appTF.text!])
        } else {
            print("med name, no data: \(medName)")
            
            //let key = database.child("users").child(user).child("medications").child("\(medName)")
            let updated_medication = ["imageKey": key ?? "", "imageData": "", "dosage": (Double(doseTF.text!) ?? 0.0) ,  "appearance": appTF.text!] as [String : Any]
            let childUpdate = ["/users/\(user)/medications/\(medName!)": updated_medication]
            database.updateChildValues(childUpdate)
            
            //database.child("users").child(user).child("medications").child("\(medName)").setValue(["imageKey": key ?? "", "imageData": "", "dosage": (Double(doseTF.text!) ?? 0.0) , "dailyFreq": (Int32(freqTF.text!) ?? 0), "appearance": appTF.text!])
        }
        
        let notification = UILocalNotification()
        
        notification.fireDate = fixedNotificationDate(timeTaken.date)
        
        notification.alertTitle = "time to take " + medName!
        
        notification.alertBody = "its appearance is " + (appearance ?? "not given")
        
        notification.timeZone = TimeZone.current
        
        notification.repeatInterval = NSCalendar.Unit.day
        
        notification.applicationIconBadgeNumber = 1
        print(notification)
        UIApplication.shared.scheduleLocalNotification(notification)

        
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == doseTF {
            doseTF.resignFirstResponder()
        }
        else if textField == freqTF {
            freqTF.resignFirstResponder()
        }
        else if textField == appTF {
            appTF.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera;
            imagePicker.cameraCaptureMode = .photo
            imagePicker.allowsEditing = false
        } else {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
        }
        
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let image = self.resizeImage(image: chosenImage, targetSize: CGSize.init(width: 100, height: 100))
        
        let data = UIImagePNGRepresentation(image)//as NSData?
        self.data = data
        
        print("data created: \(self.data)")
        
        imageView.image = image
        
        //dismiss(animated: true, completion: nil)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func fixedNotificationDate(_ dateToFix: Date) -> Date {
        
        var dateComponents: DateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.hour, NSCalendar.Unit.minute], from: dateToFix)
        
        dateComponents.second = 0
        
        let fixedDate: Date = Calendar.current.date(from: dateComponents)!
        
        return fixedDate
        
    }
    
}
