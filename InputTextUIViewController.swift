//
//  InputTextUIViewController.swift
//  
//
//  Created by Kara on 2/19/23.
//

import UIKit

class InputTextUIViewController: UIViewController {
//    @IBOutlet weak var addressInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func nextBut(_ sender: UIButton){
        performSegue(withIdentifier: "goToNext", sender: self)
    }
    override func prepare(for seque: UIStoryboardSegue, sender: Any?){
        if segue.identifier=="goToNext"{
            let destinationVC = segue.destination as? VotingViewController
            if let address = addressInput.text{
                destinationVC?.address = address
            }
        }
    }

}
