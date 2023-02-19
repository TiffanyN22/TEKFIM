//
<<<<<<< Updated upstream
//  LoginController.swift
=======
//  LoginViewController.swift
>>>>>>> Stashed changes
//  TEKFIM
//
//  Created by Madeline Follosco on 2/18/23.
//

import UIKit
<<<<<<< Updated upstream

class LoginController: NSObject {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButt: UIButton!
    @IBOutlet weak var signUpButt: UIButton!
    
    }
=======
import Firebase

class LoginController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) {firebaseResult, error in
            if let e = error { print("error")
            }
            else{
                //go to 'account created' screen
                self.performSegue(withIdentifier: "goToHome", sender: self)
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
>>>>>>> Stashed changes
