//
//  ClearViewController.swift
//  DLSCovidScreen
//
//  Created by Helen Xiao on 5/20/20.
//  Copyright © 2020 Helen Xiao. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ClearViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Clear all saved data before going back to questionnaire screen
        let savedDefaults = UserDefaults.standard
        savedDefaults.removeObject(forKey: "FormSubmittedClear")
        savedDefaults.removeObject(forKey: "TempEntered")
        savedDefaults.removeObject(forKey: "DateSubmitted")
        savedDefaults.removeObject(forKey: "TimeSubmitted")
    }
    
    // Moves backward to questionnaire screen when "Back" button is pressed
    @IBAction func backtoQuestionnairePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ClearToQuestionnaire", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backButton.layer.cornerRadius = 10.0
        
        let username = Auth.auth().currentUser?.displayName

        if (username != nil){
            nameLabel.text = username
        }
        
        let savedDefaults = UserDefaults.standard
        let timeSubmitted = savedDefaults.value(forKey: "TimeSubmitted")
        timeLabel.text = timeSubmitted as? String
        
        // Get day of the week
        let date = Date()
        let calendar = Calendar.current;
        let dayOfWeek = calendar.component(.weekday, from: date)
        var day = ""
        if (dayOfWeek == 1) {
            day = "Sunday"
        }
        else if (dayOfWeek == 2) {
            day = "Monday"
        }
        else if (dayOfWeek == 3) {
            day = "Tuesday"
        }
        else if (dayOfWeek == 4) {
            day = "Wednesday"
        }
        else if (dayOfWeek == 5) {
            day = "Thursday"
        }
        else if (dayOfWeek == 6) {
            day = "Friday"
        }
        else if (dayOfWeek == 7) {
            day = "Saturday"
        }
       
        // Formats date label to Day of Week, Month, Day, Year
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        let form = formatter.string(from: date)
        dateLabel.text = day + ", " + form
    }

}
