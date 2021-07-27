//
//  SingupViewController.swift
//  Brainsight
//
//  Created by Ronald Muñoz on 7/25/21.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class SingupViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        // Hide error label
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String? {
        // Check that all the fields have data
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""   ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        
        // Check for valid password
        let cleanedPasswordString = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPasswordString) == false {
            return "Your password must contain at least eight characters and a special character"
        }
        
        // Check for valid email
        let cleanedEmailString = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidEmail(cleanedEmailString) == false{
            return "Check that your email is valid"
        }
        
        
        return nil
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func joinButtonClick(_ sender: Any) {
        // Validate fields
        let error = validateFields()
        
        if error != nil {
            // There is an error
            showError(error!)
        }
        
        // Declare cleaned version of user input
        let cleanedFirstName    = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedLastName     = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedEmail        = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPassword     = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Create new user in Firestore
        Auth.auth().createUser(withEmail: cleanedEmail, password: cleanedPassword) { result, error in
            // Check for errors
            if error != nil {
                
                // There was an error
                self.showError("Error creating user")
            }
            else {
                
                // Store first name and last name in the database
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["first_name": cleanedFirstName,
                                                          "last_name":cleanedLastName]) { error in
                    if error != nil {
                        // There was an error
                        self.showError("Error adding user data")
                    }
                    else{
                        // Move to main app screen
                        self.goToHomePage()
                    }
                }
            }
        }
        
    }
    
    func goToHomePage(){
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeStoryBoard) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
