//
//  ProfileSummaryViewController.swift
//  TEKFIM
//
//  Created by Fernando Rojas on 2/18/23.
//

import UIKit

class ProfileSummaryViewController: UIViewController {
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var District: UILabel!
    
    @IBOutlet weak var DistrictName: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    var bioguideId = "test"
    override func viewDidLoad() {
        super.viewDidLoad()
        print(bioguideId)

        // Do any additional setup after loading the view.
        let apiKey = "cgBFpkuWG24jDavEv8jI0oWg54XgDenXJHPQUYGi"

                let cosponsorUrl = "https://api.congress.gov/v3/bill/117/hr/3076/cosponsors?api_key=\(apiKey)&format=json"

//                getCosponsordata(from: cosponsorUrl)


                

            }
    }


