//
//  LogInViewController.swift
//  DLSCovidScreen
//
//  Created by Helen Xiao on 6/13/20.
//  Copyright © 2020 Helen Xiao. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var logInMessage: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    @IBAction func logInTapped(_ sender: Any) {
        let email = emailInput.text!
        let password = passwordInput.text!
        
        if (email == nil || password == nil || email == "" || password == "") {
            logInMessage.text = "Please fill out all entries."
            logInMessage.isHidden = false
        } else {
            logInMessage.text = "Logging you in..."
            logInMessage.isHidden = false
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if (error != nil) {
                    self.logInMessage.text = "Invalid email and password credentials. Try again, or:"
                    self.resetPasswordButton.isHidden = false
                    self.signUpButton.isHidden = false
                }
                else {
                    if (Auth.auth().currentUser?.isEmailVerified == true ) {
                        // If user is verified go to prescreen
                        if (Auth.auth().currentUser?.email == nil || Auth.auth().currentUser?.email == "") {
                            Auth.auth().currentUser?.updateEmail(to: email)
                        }
                        if (Auth.auth().currentUser?.displayName == nil || Auth.auth().currentUser?.displayName == "") {
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = email
                            changeRequest?.commitChanges { (error) in
                                if (error != nil) {
                                }
                            }
                        }
                        self.performSegue(withIdentifier: "LoggedInSuccess", sender: self)
                    } else {
                        self.logInMessage.text = "Your email has not been verified. Another email verification email has been sent."
                        
   //                     let firebaseAuth = Auth.auth()
                        Auth.auth().currentUser?.sendEmailVerification { (error) in
                            if (error != nil) {
                                self.logInMessage.text = "Error: unable to send verification email."
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "LogInToSignUp", sender: self)
    }
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        let email = emailInput.text!
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if (error != nil) {
                self.logInMessage.text = "No user exists. Please create an account."
                self.resetPasswordButton.isHidden = true
            }
            else {
                self.logInMessage.text = "Password reset email has been sent to " + email + "."
            }
        }
        
    }
    
    //Keyboard functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.emailInput.delegate = self
        self.passwordInput.delegate = self
        
        logInButton.layer.cornerRadius = 20.0;
        signUpButton.layer.cornerRadius = 10.0;
        resetPasswordButton.layer.cornerRadius = 10.0
    }

}
