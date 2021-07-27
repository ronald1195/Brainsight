//
//  LoginViewController.swift
//  Brainsight
//
//  Created by Ronald Muñoz on 7/25/21.
//

import UIKit
import Foundation
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    
    func setupView(){
        // Hide error label
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            // There is something missing
            return "Make sure all the fields are filled"
        }
        
        return nil
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func goToHomePage(){
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeStoryBoard) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func signInUser(){
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: cleanedEmail, password: cleanedPassword) { result, error in
            
            if error != nil{
                self.showError("There was a problem singing you in.")
            }
            else {
                self.goToHomePage()
            }
            
        }
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        
        // Validate fields
        let error = self.validateFields()
        
        if error != nil {
            showError(error!)
        }
        else{
            self.signInUser()
        }
    }

}
