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
    
    var bioguideId = "L000174"
    var member: MemberData?
    var state: termInfo?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(bioguideId)

        // Do any additional setup after loading the view.
        let apiKey = "cgBFpkuWG24jDavEv8jI0oWg54XgDenXJHPQUYGi"
        
        let memberUrl = "https://api.congress.gov/v3/member/\(bioguideId)?api_key=\(apiKey)&format=json"
        getMemberData(from: memberUrl)
//        getTermInfoData(from: memberUrl)

        setName()
    }
//      change name for senator
    private func setName(){
        self.Name.text = member?.directOrderName
        print(member?.directOrderName)
        
        self.DistrictName.text = member?.terms[0].stateName
        print(member?.terms[0].stateName)
        
        self.Party.text = member?.partyHistory[0].partyName
        print(member?.partyHistory[0].partyName)
        
        self.website.text = member?.officialWebsiteUrl
        print(member?.officialWebsiteUrl)
        
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
                print("failed to convert")
            }

            guard let json = result else{
                return
            }

//            print(json.member.directOrderName)
            self.member = json.member
            self.setName()
        })

        task.resume()
        print("task resumed")
//        self.setName()
        }
    
    //senator state info

//    private func getTermInfoData(from url: String){
//        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
//            guard let data = data, error == nil else{
//                print("something went wrong")
//                return
//            }
//
//            //convert json data into obejct
//            var result: termInfo?
//
//            do{
//                result = try JSONDecoder().decode(termInfo.self, from: data)
//
//            }
//            catch{
//                print("failed to convert")
//            }
//
//            guard let json = result else{
//                return
//            }
//
////            print(json.member.directOrderName)
//            self.state = json
//            self.setState()
////        })
//
//        task.resume()
//        print("task resumed")
////        self.setName()
//        }



    
    

    struct CongressionalMember: Codable{
        let member: MemberData

    }

    struct MemberData: Codable{
        let directOrderName: String;
        let depiction: MemberImage;
        let partyHistory: [partyInfo];
        let terms: [termInfo];
        let officialWebsiteUrl: String
    }
    struct MemberImage: Codable{
        let imageUrl: String;
    }
    struct partyInfo: Codable{
        let partyName: String;
    }
    struct termInfo: Codable{
        let stateName: String;
        
    }

    }


