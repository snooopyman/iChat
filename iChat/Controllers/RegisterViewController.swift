//
//  RegisterViewController.swift
//  iChat
//
//  Created by Armando Cáceres on 26/5/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    //error in the your language
                    print(e.localizedDescription)
                } else {
                    print("usuario creado correctamente")
                    self.performSegue(withIdentifier: "RegisterToChat", sender: self)
                }
                
            }
        }

    }
    
}
