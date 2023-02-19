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

    @IBOutlet weak var website: UILabel!
    
    @IBOutlet weak var Party: UILabel!
    
    @IBOutlet weak var sponsoredLegislationTable: UITableView!
    
    
    var bioguideId = "L000174"
    var member: MemberData?
    var state: termInfo?
    var sponsoredLegislationList: [LegislationInfo] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(bioguideId)

        // Do any additional setup after loading the view.
        let apiKey = "cgBFpkuWG24jDavEv8jI0oWg54XgDenXJHPQUYGi"
        
        let memberUrl = "https://api.congress.gov/v3/member/\(bioguideId)?api_key=\(apiKey)&format=json"
        getMemberData(from: memberUrl)

        
        let sponsoredLegislationUrl = "https://api.congress.gov/v3/member/\(bioguideId)/sponsored-legislation?api_key=\(apiKey)&format=json"
        getSponsoredLegislationData(from: sponsoredLegislationUrl)
        
        sponsoredLegislationTable.delegate = self
        sponsoredLegislationTable.dataSource = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.updateLegislationTable()
            self.setName()
        }
        
    }
//      change name for senator
    private func setName(){
        self.Name.text = member?.directOrderName
//        print(member?.directOrderName)
        
        self.DistrictName.text = member?.terms[0].stateName
//        print(member?.terms[0].stateName)
        
        self.Party.text = member?.partyHistory[0].partyName
//        print(member?.partyHistory[0].partyName)
        
        self.website.text = member?.officialWebsiteUrl
//        print(member?.officialWebsiteUrl)
        
    }
//    change state for senator
//    private func setState(){
//        print("set state called")
//        self.DistrictName.text = state?.stateName
//        print(state?.stateName)
//
//    }
    //member name data
    private func getMemberData(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }

            //convert json data into obejct
            var result: CongressionalMember?

            do{
                result = try JSONDecoder().decode(CongressionalMember.self, from: data)

            }
            catch{
                print("failed to convert member")
            }

            guard let json = result else{
                return
            }

//            print(json.member.directOrderName)
            self.member = json.member
//            self.setName()
        })

        task.resume()
        print("task resumed")
//        self.setName()
        }
    
    private func getSponsoredLegislationData(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }

            //convert json data into obejct
            var result: SponsoredLegislationList?

            do{
                result = try JSONDecoder().decode(SponsoredLegislationList.self, from: data)
            }
            catch{
                print("failed to convert legislation")
                print(url)
            }

            guard let json = result else{
                return
            }
            
            if(json.sponsoredLegislation != nil){
                self.sponsoredLegislationList = json.sponsoredLegislation!.filter{ currentLegislation in
                    return currentLegislation.number != nil && currentLegislation.type != nil &&
                    currentLegislation.title != nil
                }
//                print(self.sponsoredLegislationList[0].title)
            }
//            self.updateLegislationTable() ??
//            if(self.sponsoredLegislationList.count != 0){
//                for i in 0...self.sponsoredLegislationList.count-1{
//                    print(self.sponsoredLegislationList[i].title)
//                }
//            } else{
//                print("No legislation")
//            }
        })
        task.resume()
//        self.updateLegislationTable()
    }
    
    private func updateLegislationTable(){
        sponsoredLegislationTable.reloadData()
    }

    //Member Data from Json
    struct CongressionalMember: Codable{
        let member: MemberData
    }
    struct MemberData: Codable{
        let directOrderName: String
        let depiction: MemberImage
        let partyHistory: [partyInfo]
        let terms: [termInfo]
        let officialWebsiteUrl: String
    }
    struct MemberImage: Codable{
        let imageUrl: String
    }
    struct partyInfo: Codable{
        let partyName: String
    }
    struct termInfo: Codable{
        let stateName: String
    }
    
    //Sponsored Legislation Data from Json
    struct SponsoredLegislationList: Codable{
        var sponsoredLegislation: [LegislationInfo]?
    }
    struct LegislationInfo: Codable{
        let congress: Int;
        let number: String?
        let type: String?
        let title: String?
    }
}

//table
extension ProfileSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //deselect or unhghlight app, indexPath is position
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "billViewController") as! BillViewController
        vc.billType = self.sponsoredLegislationList[indexPath[1]].type!
        vc.billNumber = self.sponsoredLegislationList[indexPath[1]].number!
        vc.billTitle = self.sponsoredLegislationList[indexPath[1]].title!

        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension ProfileSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sponsoredLegislationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sponsoredLegislationCell", for:indexPath)
        cell.textLabel?.text = self.sponsoredLegislationList[indexPath.row].title
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor(named: "TekfimNavy")
        cell.textLabel?.numberOfLines = 0
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor(named: "TekfimGray")
        } else{
            cell.backgroundColor = UIColor(named: "TekfimBlue")
        }
        return cell
    }
}
