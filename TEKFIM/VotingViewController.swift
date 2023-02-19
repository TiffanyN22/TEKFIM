//
//  VotingViewController.swift
//  TEKFIM
//
//  Created by Kara on 2/18/23.
//
import GoogleMaps
import UIKit
import GooglePlaces

class VotingViewController: UIViewController {
    
    let electionId = "2000"
    let apiKey = "AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM"
    let address = "1263 Pacific Ave. Kansas City KS"

    @IBOutlet weak var Map: GMSMapView!
    @IBOutlet weak var placeTextField: UITextField!
    
    var lat: Double = -33
    var long: Double = 151

    override func viewDidLoad() {
        super.viewDidLoad()
        let camera =        GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 6.0)
        Map.camera = camera
        
    }

}


