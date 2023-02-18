//
//  VotingViewController.swift
//  TEKFIM
//
//  Created by Kara on 2/18/23.
//
import GoogleMaps
import UIKit

class VotingViewController: UIViewController {
    
    @IBOutlet weak var Map: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
}

/*struct URL_INFO:{
    let center: String
    let size : Int
    let key : AIzaSyBBCI4je_3F109yrQOFF8T55soxkejKBmA
    let signature :
}
let url = "https://maps.googleapis.com/maps/api/staticmap?"
*/
