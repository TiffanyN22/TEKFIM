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
    
    
    //var apiKey : "AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM"
    var addressNum = String()//1263
    var address1st = String()//"Pacific"
    var address2nd = String()//"Ave"
    var city1st = String()//"Kansas"
    var city2nd = String()//"City"
    var state = String()//"KS"
    //var electionID = 2000
    
    var lat: Double = 37.4222525
    var long: Double = -122.0841782
    
    var ads: [String] = []
    var latlon: [Double] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 37.4222525, longitude: 37.4222525, zoom: 6.0)
        Map.camera = camera
        
        let hardMarker = GMSMarker()
        hardMarker.position = CLLocationCoordinate2D(latitude: 52.192143, longitude: -1.063709)
        hardMarker.title = "Sydney"
        
        var initialAddress = "1263 Pacific Ave Kansas City KS"
        
        var getAddressesUrl = "https://www.googleapis.com/civicinfo/v2/voterinfo?key=AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM&address=\(getAddString(from: initialAddress))&electionId=2000"
        
        getAppData(from: getAddressesUrl)
        
        var k = ads.count
        for i in 0...k{
            
            var urlForFlags = "https://maps.googleapis.com/maps/api/geocode/json?place_id=\(getAddString(from: ads[i]))&key=AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM"
            getLongData(from: urlForFlags)
            /*https://maps.googleapis.com/maps/api/geocode/json?place_id=ChIJeRpOeF67j4AR9ydy_PIzPuM&key=AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM
             */
            //add marker
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latlon[0], longitude: latlon[1])
            marker.title = "Sydney"
            marker.snippet = "Australia"
            
        }
        
        
        
    }
    
    func getAddString(from address: String) -> String{
        
        let addressArray = address.components(separatedBy: " ")
        let addressNum = addressArray[0]//1263
        let address1st = addressArray[1]//"Pacific"
        let address2nd = addressArray[2]//"Ave"
        let city1st = addressArray[3]//"Kansas"
        let city2nd = addressArray[4]//"City"
        let state = addressArray[5]
        let add = "\(addressNum)%20\(address1st)%20\(address2nd).%20\(city1st)%20\(city2nd)%20\(state)"
        return(add)
    }
    
    private func getAppData(from url: String) {
        
        
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("something went wrong when getting data from url")
                return()
            }
            
            //convert json data into obejct
            var result: MyResult?
            do{
                result = try JSONDecoder().decode(MyResult.self, from: data)
            }
            catch{
                print("failed to convert data into json")
            }
            
            guard let json = result else{
                return()
            }
            let k = json.pollingLocations.count-1
            for i in 0...k{
                let address = "\(json.pollingLocations[i].address.line1) \(json.pollingLocations[i].address.city) \(json.pollingLocations[i].address.state) \(json.pollingLocations[i].address.zip)"
                self.ads.append(address)
            }
            return() //returns array of addresses in format "423 West Street San Jose CA 95120" and how many addresses there are
            
        })

        task.resume()

    }
    private func getLongData(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("something went wrong when getting data from url")
                return
            }
            
            //convert json data into obejct
            var result: LatLonResult?
            do{
                result = try JSONDecoder().decode(LatLonResult.self, from: data)
            }
            catch{
                print("failed to convert data into json")
            }
            
            guard let json = result else{
                return
            }
            self.latlon[0] = json.result[0].geometry.location.lat
            self.latlon[1] = json.result[0].geometry.location.lon
            
        })

        task.resume()

    }
    struct LatLonResult: Codable{
        let result: [Result]
    }
    
    struct Result: Codable{
        let geometry: Geometry
    }
    struct Geometry: Codable{
        let location: Location
    }
    struct Location: Codable{
        let lat: Double
        let lon: Double
    }
    
    
    struct MyResult: Codable{
        let pollingLocations: [PollingLocations]
    }

    struct PollingLocations: Codable{
        let address: Address
    }
    
    struct Address: Codable{
        let line1: String
        let city: String
        let state: String
        let zip: String
    }
}



