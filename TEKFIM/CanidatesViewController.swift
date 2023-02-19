//
//  VotingViewController.swift
//  TEKFIM
//
//  Created by Kara on 2/18/23.
//
import GoogleMaps
import UIKit
import GooglePlaces

class CandidatesViewController: UIViewController {
    
    let electionId = "2000"
    let apiKey = "AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM"
    let address = "1263 Pacific Ave. Kansas City KS"
        
    @IBOutlet weak var candidatesTable: UITableView!
    var electionDisplayInfo: [String] = []
    var isElectionDisplayContest: [Bool] = [] //true for contest, false for candidate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = "https://www.googleapis.com/civicinfo/v2/voterinfo?key=AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM&address=1263%20Pacific%20Ave.%20Kansas%20City%20KS&electionId=2000"

        getData(from: url)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            print("FROM ELECTION DISPLAY :)")
//             for i in 0...self.electionDisplayInfo.count-1{
//                print(self.electionDisplayInfo[i])
//            }
            self.candidatesTable.reloadData()
        }
        
        candidatesTable.delegate = self
        candidatesTable.dataSource = self
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
//            print(json.election.name)
            
            let k = json.contests.count-1
            for i in 0...k{
                print(json.contests[i].office)
                self.electionDisplayInfo.append(json.contests[i].office ?? "unknown office")
                self.isElectionDisplayContest.append(true)
                
                if(json.contests[i].candidates != nil){
                    let m = json.contests[i].candidates!.count - 1
                    for j in 0...m {
                        print(json.contests[i].candidates![j].name)
                        self.electionDisplayInfo.append(json.contests[i].candidates![j].name ?? "unnamed")
                        self.isElectionDisplayContest.append(false)
                    }
                }
            }
            print("k is \(k)")
            print("number of display info: \(self.electionDisplayInfo.count)")
        })
        task.resume()
    }
    
//    struct groupRunning: Codable{
//        let runFor: String
//        var name = [String]()
//    }
    struct MyResult: Codable{
//        let election: Election
        var contests = [Contests]()
    }
//    struct Election: Codable{
//        let id: String
//        let name: String
//        let electionDay: String
//        let ocdDivisionId: String
//    }
    struct Contests: Codable {
        let office: String?
        let candidates: [Candidates]?
    }
    struct Candidates: Codable {
        let name: String?
        let party: String?
    }
}

//table
extension CandidatesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //deselect or unhghlight app, indexPath is position
//
//        let vc = storyboard?.instantiateViewController(withIdentifier: "candidateTableCell") as! BillViewController
//        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CandidatesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return electionDisplayInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "candidateTableCell", for:indexPath)
        cell.textLabel?.text = self.electionDisplayInfo[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor(named: "TekfimNavy")
        cell.textLabel?.numberOfLines = 0

        if(isElectionDisplayContest[indexPath.row]){
            cell.backgroundColor = UIColor(named: "TekfimRed")
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        } else{
            cell.backgroundColor = UIColor(named: "TekfimGray")
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        }
        return cell
    }
}


