//
//  PoliticianSelectViewController.swift
//  TEKFIM
//
//  Created by Tiffany Nguyen on 2/18/23.
//

import UIKit

class PoliticianSelectViewController: UIViewController {
    @IBOutlet weak var senatorsTable: UITableView!
    
    var state: String = "Alaska"
    var congressionMembers: [Member] = []
    var senators = ["senator1" ,"senator2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(state)
        //get congressional members from api
        let apiKey = "cgBFpkuWG24jDavEv8jI0oWg54XgDenXJHPQUYGi"
        let congresssionalMembersUrl = "https://api.congress.gov/v3/member?api_key=\(apiKey)&format=json&limit=250"
        let congresssionalMembersUrl2 = "https://api.congress.gov/v3/member?api_key=\(apiKey)&format=json&limit=250&offset=250"
        let congresssionalMembersUrl3 = "https://api.congress.gov/v3/member?api_key=\(apiKey)&format=json&limit=35&offset=500"
    

        if (congressionMembers.count == 0){
           Task {
               do {
                   await getFilteredCongressionalData(from: congresssionalMembersUrl, from: congresssionalMembersUrl2, from: congresssionalMembersUrl3)
               }
           }
       } else{
           Task {
               do {
                   await filterCongressionalData()
               }
           }
       }
        //set up senator table
        senatorsTable.delegate = self
        senatorsTable.dataSource = self
    }

    
    private func appendToCongressionMembers(newMembers: [Member]){
        self.congressionMembers.append(contentsOf: newMembers)
    }
    
    private func getFilteredCongressionalData(from url1: String, from url2: String, from url3: String) async{
        //filter
        print("getting congressional data")
        await getCongressionalData(from: url1)
        print("done with await url 1")
        await getCongressionalData(from: url2)
        print("done with await url 2")
        await getCongressionalData(from: url3)
        print("done with await url 3")

        await filterCongressionalData()
    }
    
    private func getCongressionalData(from url: String) async{
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
                    await self.appendToCongressionMembers(newMembers: json.members)
                    await self.filterCongressionalData()
                }
            }
        })
        task.resume()
        
    }
    
    private func filterCongressionalData() async{
        print(self.congressionMembers.count)
        let stateSenators = self.congressionMembers.filter { currentMember in
            return currentMember.member.state == self.state && currentMember.member.served.Senate != nil && currentMember.member.served.Senate?[0].end == nil //TODO: filter senator vs rep
        }
        if(stateSenators.count == 0){
            print("No senators found")
        } else{
            self.senators = []
            for i in 0...stateSenators.count-1{
                self.senators.append(stateSenators[i].member.name)
            }
            
            //update senators
            self.updateSenators()
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
}

extension PoliticianSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //deselect or unhghlight app, indexPath is position
      
        //TODO: navigation
    }
}

extension PoliticianSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.senators.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SenatorCell", for:indexPath)
        cell.textLabel?.text = self.senators[indexPath.row]
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
