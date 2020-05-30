//
//  File 4.0.swift
//  On The Map
//
//  Created by Sergey on 27/12/19.
//  Copyright © 2019 Sergey. All rights reserved.
//
import Foundation
import UIKit

class login: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
      
      override func viewDidLoad() {
          super.viewDidLoad()
          userNameTextField.delegate = self
          passwordTextField.delegate = self
          
      }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        print("pressed")
        
        if userNameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            displayAlert(title: "Login Unsuccessful", message: "Username and/or Password is empty")
            
            } else {
            taskPostASessionAuth(username: userNameTextField.text!, password: passwordTextField.text!) { (success, errorString) in performUIUpdatesOnMain {
                if success{
                    performUIUpdatesOnMain {
                        self.userNameTextField.text = ""
                        self.passwordTextField.text = ""
                        
                        print("Successfully logged in!")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "mapView")
                        self.present(controller, animated: true, completion: nil)
                }
                    
                } else if errorString != nil {
                        performUIUpdatesOnMain {
                            self.displayAlert(title: "Login Unsuccessful", message: errorString)
                        }
                    } else {
                        performUIUpdatesOnMain {
                            self.displayAlert(title: "Login Unsuccessful", message: "Invalid Username and/or Password")
                    
                }
            }
            
            func enableControllers(_ enable: Bool) {
                self.userNameTextField? .isEnabled = false
                self.passwordTextField.isEnabled = false
                self.loginButton.isEnabled = false
                self.facebookButton.isEnabled = false
                
            }
            
        }
        
        
    }
        }
}
}
