//
//  QuestionViewController.swift
//  DLSCovidScreen
//
//  Created by Helen Xiao on 5/19/20.
//  Copyright © 2020 Helen Xiao. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class QuestionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var temperatureText: UITextField!
    @IBOutlet weak var notAllFilledOut: UILabel!
    
    @IBOutlet weak var question1Prompt: UILabel!
    @IBOutlet weak var question2Prompt: UILabel!
    @IBOutlet weak var question3Prompt: UILabel!
    @IBOutlet weak var question4Prompt: UILabel!
    
    @IBOutlet weak var question1Yes: UIButton!
    @IBOutlet weak var question1No: UIButton!
    @IBOutlet weak var question2Yes: UIButton!
    @IBOutlet weak var question2No: UIButton!
    @IBOutlet weak var question3Yes: UIButton!
    @IBOutlet weak var question3No: UIButton!
    @IBOutlet weak var question4Yes: UIButton!
    @IBOutlet weak var question4No: UIButton!
    
    var ref: DatabaseReference!
    
// Radio buttons for Question 1
    @IBAction func question1YesSelected(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            question1No.isSelected = false
        }
        else {
            sender.isSelected = true
            question1No.isSelected = false
        }
    }
    
    @IBAction func question1NoSelected(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            question1Yes.isSelected = false
        }
        else {
            sender.isSelected = true
            question1Yes.isSelected = false
        }
    }
 
// Radio buttons for Question 2
    @IBAction func question2YesSelected(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            question2No.isSelected = false
        }
        else {
            sender.isSelected = true
            question2No.isSelected = false
        }
    }
    
    @IBAction func question2NoSelected(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            question2Yes.isSelected = false
        }
        else {
            sender.isSelected = true
            question2Yes.isSelected = false
        }
    }

// Radio buttons for Question 3
    @IBAction func question3YesSelected(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            question3No.isSelected = false
        }
        else {
            sender.isSelected = true
            question3No.isSelected = false
        }
    }
    
    @IBAction func question3NoSelected(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            question3Yes.isSelected = false
        }
        else {
            sender.isSelected = true
            question3Yes.isSelected = false
        }
    }
    
// Radio buttons for Question 4
    @IBAction func question4YesSelected(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            question4No.isSelected = false
        }
        else {
            sender.isSelected = true
            question4No.isSelected = false
        }
    }
    
    @IBAction func question4NoSelected(_ sender: UIButton) {
        if sender.isSelected {
                   sender.isSelected = false
                   question4Yes.isSelected = false
               }
               else {
                   sender.isSelected = true
                   question4Yes.isSelected = false
               }
    }
    
    @IBAction func covidLink(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://www.cdc.gov/coronavirus/2019-ncov/symptoms-testing/symptoms.html?CDC_AA_refVal=https%3A%2F%2Fwww.cdc.gov%2Fcoronavirus%2F2019-ncov%2Fabout%2Fsymptoms.html")! as URL, options: [:], completionHandler: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Creates save default so app can save all information from questionnaire
        let savedDefaults = UserDefaults.standard
        
        // Info for Clear Screen
        if segue.identifier == "ClearSegue" {
            if (temperatureText.text! != "") {
                savedDefaults.set(temperatureText.text!, forKey: "TempEntered")
            }
            savedDefaults.set(true, forKey: "FormSubmittedClear")
        }
        
        // Info for Not Clear Screen
        if segue.identifier == "NotClearSegue" {
            if (question1Yes.isSelected)
            {
                savedDefaults.set(question1Prompt.text!, forKey: "Q1Yes")
            }
            if (question2Yes.isSelected)
            {
                savedDefaults.set(question2Prompt.text!, forKey: "Q2Yes")
            }
            if (question3Yes.isSelected)
            {
                savedDefaults.set(question3Prompt.text!, forKey: "Q3Yes")
            }
            if (question4Yes.isSelected)
            {
                savedDefaults.set(question4Prompt.text!, forKey: "Q4Yes")
            }
            if (temperatureText.text! != "") {
                savedDefaults.set(temperatureText.text!, forKey: "TempEntered")
            }
            savedDefaults.set(true, forKey: "FormSubmittedNotClear")
        }
        
        // Info for both Clear and Not Clear screens AKA Submit Button Validly Pressed
        if (segue.identifier == "NotClearSegue" || segue.identifier == "ClearSegue") {
            
            guard let username = Auth.auth().currentUser?.displayName else {return}
            guard let useremail = Auth.auth().currentUser?.email else {return}
            
            var fevertemp = ""
            var q1answer = "No"
            var q2answer = "No"
            var q3answer = "No"
            var q4answer = "No"
            
            if (savedDefaults.value(forKey: "TempEntered") != nil) {
                fevertemp = (savedDefaults.value(forKey: "TempEntered") as? String)! + " °F"
            }
            
            if (question1Yes.isSelected) {
                q1answer = "Yes"
            }
            if (fevertemp != "") {
                q1answer = q1answer + " " + fevertemp
            }
            if (question2Yes.isSelected) {
                q2answer = "Yes"
            }
            if (question3Yes.isSelected) {
                q3answer = "Yes"
            }
            if (question4Yes.isSelected) {
                q4answer = "Yes"
            }
            
            // Date and Time info
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            let dateform = formatter.string(from: date)             // Produces a string like 01-01-2020
            let formatter2 = DateFormatter()
            formatter2.timeStyle = .medium
            let timestamp = formatter2.string(from: date)
            
            // Save the current day to app
            savedDefaults.set(dateform, forKey: "DateSubmitted")
            savedDefaults.set(timestamp, forKey: "TimeSubmitted")
            
            var root = ""
            let adjustedemail = useremail.replacingOccurrences(of: ".", with: ",")
            
            // For those added manually
            if (useremail == username) {
                root = adjustedemail
            }
            else {
                root = username + "; " + adjustedemail
            }

            // Data sent to firebase
          
            // By name
            self.ref.child(root).child(dateform).child("question1").setValue(q1answer)
            self.ref.child(root).child(dateform).child("question2").setValue(q2answer)
            self.ref.child(root).child(dateform).child("question3").setValue(q3answer)
            self.ref.child(root).child(dateform).child("question4").setValue(q4answer)
            self.ref.child(root).child(dateform).child("timestamp").setValue(timestamp)
            
            // By date
            self.ref.child(dateform).child(root).child("question1").setValue(q1answer)
            self.ref.child(dateform).child(root).child("question2").setValue(q2answer)
            self.ref.child(dateform).child(root).child("question3").setValue(q3answer)
            self.ref.child(dateform).child(root).child("question4").setValue(q4answer)
            self.ref.child(dateform).child(root).child("timestamp").setValue(timestamp)
        }
            
    }
    
     // Moves forward to all clear screen when "Submit" button is pressed
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        // Checks if all questions have been answered
        if ((question1Yes.isSelected || question1No.isSelected) && (question2Yes.isSelected || question2No.isSelected) && (question3Yes.isSelected || question3No.isSelected) && (question4Yes.isSelected || question4No.isSelected))
        {
            // All questions answered
        
            // Get the temperature
            let temperatureInt = Double(temperatureText.text!)
            
            // CLEAR: Qs 2-4 No + No fever / Fever < 100.4
            if ((question2No.isSelected && question3No.isSelected && question4No.isSelected) && ((question1No.isSelected) && (temperatureText.text! == "" || temperatureInt!.isLess(than: 100.4))))
            {
                self.performSegue(withIdentifier: "ClearSegue", sender: self)
            }
            
            // NOT CLEAR: At least 1 Q answered yes / fever >= 100.4
            else {
                self.performSegue(withIdentifier: "NotClearSegue", sender: self)
            }
        }
            
        // Not all quetsions were answered
        else
        {
            notAllFilledOut.isHidden = false
        }
    }
    
    // Moves backward to student info screen when "Back" button is pressed
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "BackToVC2", sender: self)
    }
    
    // Closes keyboard when user touches outside of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
       
    // Closes keyboard when user touches return key (Not present in decimal keyboard, but keeping in case switch back)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        ref = Database.database().reference()
        
        temperatureText.delegate = self
        backButton.layer.cornerRadius = 10.0
        submitButton.layer.cornerRadius = 20.0
    }

    
}
