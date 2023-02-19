//
//  HomeViewController.swift
//  TEKFIM
//
//  Created by Tiffany Nguyen on 2/18/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var legislatorButton: UIButton!
    @IBOutlet weak var resourcesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //center button text
        legislatorButton.titleLabel?.textAlignment = NSTextAlignment.center
        resourcesButton.titleLabel?.textAlignment = NSTextAlignment.center

    }
    

}
