//
//  PoliticianSelectViewController.swift
//  TEKFIM
//
//  Created by Tiffany Nguyen on 2/18/23.
//

import UIKit

class PoliticianSelectViewController: UIViewController {
    @IBOutlet weak var senatorsTable: UITableView!
    @IBOutlet weak var representativeTable: UITableView!
    
    var state: String = "Alaska"
    var congressionalMembers: [Member] = []
    var senators: [Member] = []
    var representatives: [Member] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(state)
        //get congressional members from api
        let apiKey = "cgBFpkuWG24jDavEv8jI0oWg54XgDenXJHPQUYGi"
        let congresssionalMembersUrl = "https://api.congress.gov/v3/member?api_key=\(apiKey)&format=json&limit=250"
        let congresssionalMembersUrl2 = "https://api.congress.gov/v3/member?api_key=\(apiKey)&format=json&limit=250&offset=250"
        let congresssionalMembersUrl3 = "https://api.congress.gov/v3/member?api_key=\(apiKey)&format=json&limit=35&offset=500"
    

        if (congressionalMembers.count == 0){
           getFilteredCongressionalData(from: congresssionalMembersUrl, from: congresssionalMembersUrl2, from: congresssionalMembersUrl3)
       } else{
           filterCongressionalData()
       }
        //set up senator table
        senatorsTable.delegate = self
        senatorsTable.dataSource = self
        representativeTable.delegate = self
        representativeTable.dataSource = self
    }

    
    private func appendToCongressionalMembers(newMembers: [Member]){
        self.congressionalMembers.append(contentsOf: newMembers)
    }
    
    private func getFilteredCongressionalData(from url1: String, from url2: String, from url3: String) {
        //filter
        getCongressionalData(from: url1)
        getCongressionalData(from: url2)
        getCongressionalData(from: url3)

        filterCongressionalData()
    }
    
    private func getCongressionalData(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            
            //convert json data into obejct
            var result: CongressionalMemberList?
            do{
                result = try JSONDecoder().decode(CongressionalMemberList.self, from: data)
            }
            catch{
                print("failed to convert")
            }
            
            guard let json = result else{
                return
            }

            Task {
                do {
                    self.appendToCongressionalMembers(newMembers: json.members)
                    self.filterCongressionalData()
                }
            }
        })
        task.resume()
        
    }
    
    private func filterCongressionalData() {
        //filter senators
        let stateSenators = self.congressionalMembers.filter { currentMember in
            return currentMember.member.state == self.state && currentMember.member.served.Senate != nil && currentMember.member.served.Senate?[0].end == nil
        }
        if(stateSenators.count == 0){
//            print("No senators found")
        } else{
            self.senators = []
            for i in 0...stateSenators.count-1{
                self.senators.append(stateSenators[i])
            }
            
            //update table
            self.updateSenators()
        }
        
        //filter house of representatives
        let stateRepresentatives = self.congressionalMembers.filter { currentMember in
            return currentMember.member.state == self.state && currentMember.member.served.House != nil && currentMember.member.served.House?[0].end == nil
        }
        if(stateRepresentatives.count == 0){
//            print("No representatives found")
        } else{
            self.representatives = []
            for i in 0...stateRepresentatives.count-1{
                self.representatives.append(stateRepresentatives[i])
            }
            
            //update table
            self.updateRepresentatives()
        }
    }
    
    
    struct CongressionalMemberList: Codable{
        let members: [Member]
    }
    
    struct Member: Codable{
        let member: MemberInfo;
    }
    
    struct MemberInfo: Codable{
        let bioguideId: String;
        let name: String;
        let state: String;
        let served: ServedInfo;
    }
    
    struct ServedInfo: Codable{
        let Senate:[Senate]?
        let House:[House]?
    }
    struct Senate: Codable{
        let end: Int?
        let start: Int
    }
    struct House: Codable{
        let end: Int?
        let start: Int
    }
    
    func updateSenators(){
        senatorsTable.reloadData()
    }
    func updateRepresentatives(){
        representativeTable.reloadData()
    }
}

extension PoliticianSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //deselect or unhghlight app, indexPath is position
        if(tableView == senatorsTable){
            //navigate to politician select page
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileSummary") as! ProfileSummaryViewController
            vc.bioguideId = self.senators[indexPath[1]].member.bioguideId
            navigationController?.pushViewController(vc, animated: true)
        } else{
            //navigate to politician select page
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileSummary") as! ProfileSummaryViewController
            vc.bioguideId = self.representatives[indexPath[1]].member.bioguideId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}



extension PoliticianSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == senatorsTable){
            return self.senators.count
//            return self.senatorsTest.count
        } else{
            return self.representatives.count
//            return self.representativesTest.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == senatorsTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenatorCell", for:indexPath)
            cell.textLabel?.text = self.senators[indexPath.row].member.name
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor(named: "TekfimNavy")
            
            if(indexPath.row % 2 == 0){
                cell.backgroundColor = UIColor(named: "TekfimGray")
            } else{
                cell.backgroundColor = UIColor(named: "TekfimRed")
            }
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "representativeCell", for:indexPath)
            cell.textLabel?.text = self.representatives[indexPath.row].member.name
//            cell.textLabel?.text = self.representativesTest[indexPath.row]
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor(named: "TekfimNavy")
            
            if(indexPath.row % 2 == 0){
                cell.backgroundColor = UIColor(named: "TekfimGray")
            } else{
                cell.backgroundColor = UIColor(named: "TekfimRed")
            }
            return cell
        }
    }
}
