//
//  CanidatesViewController.swift
//  TEKFIM
//
//  Created by Kara on 2/18/23.
//

import UIKit
import Alamofire

class CanidatesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let url = "https://www.googleapis.com/civicinfo/v2/voterinfo?key=AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM&address=1263%20Pacific%20Ave.%20Kansas%20City%20KS&electionId=2000"
    struct Response: Codable{
        let results: MyResult
        let status: String
    }
    
    struct MyResult: Codable{
        let election: Election
        let normalizedInput: NormalizedInput
        let pollingLocations: [PollingLocations]
        let contests: [Contests]
        let state: [State]
    }
    
    let Election: Codable{
        let id: String
        let name: String
        let electionDay: String
        let ocdDivisionId: String
    }
    
    let NormalizedInput: Codable{
        let line1: String
        let city: String
        let state: String
        let zip: String
    }
    
    let PollingLocations: Codable{
        let address: Address
        let notes: String
        let pollingHours: String
        let sources: [Sources]
    }
    
    let Sources: Codable{
        let name: String
        let official: Bool
    }
    
    let Contests: Codable {
        let type: String
        let office: String
        let level: [Level]
        let roles: [Roles]
        let district: District
        let sources: [Sources]
        let candidates: [Candidates]
    }
    
    let Level: Codable {
        let lvl: String
    }
    
    let Roles: Codable {
        let role: String
    }
    
    let District: Codable{
        let name: String
        let scope: String
        let id: String
    }
    
    let Sources: Codable{
        let name: String
        let official: Bool
    }
    
    let Candidates: Codable {
        let name: String
        let party: String
        let canddiateUrl: String
        let channels: [Channels]
    }
    
    let Channels: Codable {
        let type:
    }
    
    
    

}
