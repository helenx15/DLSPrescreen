//
//  SecondViewController.swift
//  DLSCovidScreen
//
//  Created by Helen Xiao on 5/19/20.
//  Copyright © 2020 Helen Xiao. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var continuebutton: UIButton!
    @IBOutlet weak var signoutbutton: UIButton!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var emailaddress: UILabel!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var emaillabel: UILabel!
    
    @IBAction func signOutTap(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "signOutToMain", sender: self)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
   
    // Moves forward to questionnaire screen when "Continue" button is pressed
    @IBAction func continueButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "QuestionViewSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        continuebutton.layer.cornerRadius = 20.0;
        signoutbutton.layer.cornerRadius = 10.0;
        
        // TODO: FIX DISPLAY NAME, ALSO ON CLEAR AND NOT CLEAR SCREENS
        guard let username = Auth.auth().currentUser?.displayName else {return}
        guard let useremail = Auth.auth().currentUser?.email else {return}
        
        if (username == useremail) {
            emaillabel.isHidden = true
            emailaddress.isHidden = true
            namelabel.text = "Email"
        }
        
        fullname.text = username
        emailaddress.text = useremail
    }
    
    
}
