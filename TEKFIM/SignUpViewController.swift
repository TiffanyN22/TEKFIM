//
//  SignUpViewController.swift
//  TEKFIM
//
//  Created by Madeline Follosco on 2/18/23.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpAdressTextField: UITextField!
    
    @IBOutlet weak var signUpEmailTextField: UITextField!
    
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signUpClicked(_ sender: UIButton) {
        guard let email = signUpEmailTextField.text else {return}
        guard let password = signUpPasswordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) {firebaseResult, error in
            if let e = error { print("error")
            }
            else{
                //go to 'account created' screen
                self.performSegue(withIdentifier: "goToAC", sender: self)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
