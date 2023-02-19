//
//  CanidatesViewController.swift
//  TEKFIM
//
//  Created by Kara on 2/18/23.
//

import UIKit
import AVFoundation


class Contest {
    var name: String
    var participants: [String]
    
    init(name: String, participants: [String]) {
        self.name = name
        self.participants = participants
    }
}

class CanidatesViewController: UIViewController, UITableViewDataSource{
    
    var contests: [Contest] = []
    var apiKey = "AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM"
    var addressNum = 1263
    var address1st = "Pacific"
    var address2nd = "Ave"
    var city1st = "Kansas"
    var city2nd = "City"
    var state = "KS"
    var electionID = 2000
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = "https://www.googleapis.com/civicinfo/v2/voterinfo?key=AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM&address=1263%20Pacific%20Ave.%20Kansas%20City%20KS&electionId=2000"
        
        getData(from: url)
        let contest1 = Contest(name: "Contest 1", participants: ["Alice", "Bob", "Charlie"])
        let contest2 = Contest(name: "Contest 2", participants: ["Dave", "Eve"])
        contests = [contest1, contest2]
        
        tableView.dataSource = self

//        candidateTable.delegate = self
//        candidateTable.dataSource = self
        // Do any additional setup after loading the view.
    }
 
    private func getData(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("something went wrong when getting data from url")
                return
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
                return
            }
            
            print("call works!")
            print(json.election.name)
            
            let k = json.contests.count-1
            for i in 0...k{
                print(json.contests[i].type)
                if(json.contests[i].candidates != nil){
                    let m = json.contests[i].candidates!.count - 1
                        for j in 0...m {
                            print(json.contests[i].candidates![j].name)
                            let contest = Contest(name: json.contests[i].type, participants: ["Alice", "Bob", "Charlie"])
                        }
                }
                
//
            }
        })

        task.resume()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contests.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contests[section].participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let participant = contests[indexPath.section].participants[indexPath.row]
        cell.textLabel?.text = participant
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.size.width - 15, height: 30))
        headerLabel.text = contests[section].name
        headerLabel.textColor = .black
        headerView.addSubview(headerLabel)
        return headerView
    }
    
//    class MyTableViewController: UITableViewController {
//        var candidates: [String] = [] // Populate this with json.contests[i].candidates
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            tableView.dataSource = self
//        }
//
//        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return candidates.count
//        }
//
//        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CandidateCell", for: indexPath) as! CandidateTableViewCell
//            let candidate = candidates[indexPath.row]
//            cell.NameLabel.text = candidate
//            return cell
//        }
//    }
    
    struct groupRunning: Codable{
        let runFor: String
        var name = [String]()
    }
    
    struct MyResult: Codable{
        let election: Election
        //let normalizedInput: NormalizedInput
        //let pollingLocations: [PollingLocations]
        var contests = [Contests]()
        //let state: [State]
    }
    
//
//    struct Sources: Codable{
//        let name: String
//        let official: Bool
//    }
    
    struct Election: Codable{
        let id: String
        let name: String
        let electionDay: String
        let ocdDivisionId: String
    }
    
    /*
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
    */
    
    struct Contests: Codable {
        let type: String
        //let office: String
        //let level: [Level]
        //let roles: [Roles]
        //let district: District
        //let sources: [Sources]
        let candidates: [Candidates]?
    }
    /*
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

    */
    struct Candidates: Codable {
        let name: String
        let party: String
    }
    /*
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
     */

}


