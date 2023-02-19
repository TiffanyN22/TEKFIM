//
//  CanidatesViewController.swift
//  TEKFIM
//
//  Created by Kara on 2/18/23.
//

import UIKit
import AVFoundation

class CanidatesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let apiKey = "AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM"
        let addressNum = 1263
        let address1st = "Pacific"
        let address2nd = "Ave"
        let city1st = "Kansas"
        let city2nd = "City"
        let state = "KS"
        let electionID = 2000
        let url =  "https://www.googleapis.com/civicinfo/v2/voterinfo?key=\(apiKey)&address=\(addressNum)%20\(address1st)%20\(address2nd).%20\(city1st)%20\(city2nd)%20\(state)&electionId=\(electionID)" // possibly append &format=json
        getData(from: url)

        // Do any additional setup after loading the view.
    }
    private func getData(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("something went wrong when getting data from url")
                return
            }
            
            //convert json data into obejct
            var result: Response?
            do{
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch{
                print("failed to convert data into json")
            }
            
            guard let json = result else{
                return
            }
            
            print("call works!")
            
            let k = json.results.contests.count-1
            for i in 0...k{
                print(json.results.contests[i].type)
                let m = json.results.contests[i].candidates.count - 1
                for j in 0...m {
                    print(json.results.contests[i].candidates[j].name)
                }
            }
        })

        task.resume()

    }
    
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
    
    struct Sources: Codable{
        let name: String
        let official: Bool
    }
    
    struct Election: Codable{
        let id: String
        let name: String
        let electionDay: String
        let ocdDivisionId: String
    }
    
    struct NormalizedInput: Codable{
        let line1: String
        let city: String
        let state: String
        let zip: String
    }
    
    struct PollingLocations: Codable{
        let address: Address
        let notes: String
        let pollingHours: String
        let sources: [Sources]
    }
    
    struct Address: Codable{
        let line1: String
        let city: String
        let state: String
        let zip: String
    }
    
    
    struct Contests: Codable {
        let type: String
        let office: String
        let level: [Level]
        let roles: [Roles]
        let district: District
        let sources: [Sources]
        let candidates: [Candidates]
    }
    
    struct Level: Codable {
        let lvl: String
    }
    
    struct Roles: Codable {
        let role: String
    }
    
    struct District: Codable{
        let name: String
        let scope: String
        let id: String
    }

    
    struct Candidates: Codable {
        let name: String
        let party: String
        let canddiateUrl: String
        let channels: [Channels]
    }
    
    struct Channels: Codable {
        let type: String
        let id: String
    }
    
    struct State: Codable{
        let name: String
        let electionAdministrationBody: ElectionAdministrationBody
        let local_jurisdiction: Local_Jurisdiction
        let sources: [Sources]
    }
    
    struct ElectionAdministrationBody: Codable{
        let name: String
        let electionInfoUrl: String
        let electionRegistrationUrl: String
        let electionRegistrationConfirmationUrl: String
        let absenteeVotingInfoUrl: String
        let votingLocationFinderUrl: String
        let ballotInfoUrl: String
        let correspondanceAddress: CorrespondanceAddress
    }
    
    struct CorrespondanceAddress: Codable{
        let line1: String
        let city: String
        let state: String
        let zip: String
    }
    
    struct Local_Jurisdiction: Codable{
        let name: String
        let electionAdministrationBody: ElectionAdministrationBody
        let sources: [Sources]
    }
    

}
