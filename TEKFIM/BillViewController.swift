//
//  BillViewController.swift
//  TEKFIM
//
//  Created by Fernando Rojas on 2/18/23.
//

import UIKit

class BillViewController: UIViewController {

    @IBOutlet weak var Container_1: UILabel!
    
    @IBOutlet weak var subjectText: UILabel!
    @IBOutlet weak var summaryText: UILabel!
    @IBOutlet weak var actionsText: UILabel!
    
    var billCongress = 117
    var billNumber = "5353"
    var billType = "S"
    var billTitle = "Refugee Protection Act of 2022"
    
    var summary = "No summary is currently available"
    var subject = ""
    var action = "No actions have been completed"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiKey = "cgBFpkuWG24jDavEv8jI0oWg54XgDenXJHPQUYGi"
        let summaryUrl = "https://api.congress.gov/v3/bill/\(billCongress)/\(billType)/\(billNumber)/summaries?api_key=\(apiKey)&format=json"
        getBillSummary(from: summaryUrl)
        
        let subjectUrl = "https://api.congress.gov/v3/bill/\(billCongress)/\(billType)/\(billNumber)/subjects?api_key=\(apiKey)&format=json"
        getBillSubject(from: subjectUrl)
        
        let actionUrl = "https://api.congress.gov/v3/bill/\(billCongress)/\(billType)/\(billNumber)/actions?api_key=\(apiKey)&format=json"
        getBillAction(from: actionUrl)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.updateBillPage()
        }
        
    }
    
    private func getBillSummary(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            
            //convert json data into obejct
            var result: BillSummaryInfo?
            do{
                result = try JSONDecoder().decode(BillSummaryInfo.self, from: data)
            }
            catch{
                print("failed to convert bill summary")
            }
            
            guard let json = result else{
                return
            }
            if(!json.summaries.isEmpty){
                self.summary = json.summaries[0].text
                //get rid of html
                self.summary = self.summary.replacingOccurrences(of: "<p>", with: "")
                self.summary = self.summary.replacingOccurrences(of: "</p>", with: "")
                self.summary = self.summary.replacingOccurrences(of: "<b>", with: "")
                self.summary = self.summary.replacingOccurrences(of: "</b>", with: "")
                self.summary = self.summary.replacingOccurrences(of: "<strong>", with: "")
                self.summary = self.summary.replacingOccurrences(of: "</strong>", with: "")
                self.summary = self.summary.replacingOccurrences(of: "<br>", with: "")
                self.summary = self.summary.replacingOccurrences(of: "</br>", with: "")
                print(json.summaries[0].text)
            } else{
                print(url)
            }
        })
        task.resume()
    }
    
    private func getBillSubject(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            
            //convert json data into obejct
            var result: BillSubjectInfo?
            do{
                result = try JSONDecoder().decode(BillSubjectInfo.self, from: data)
            }
            catch{
                print("failed to convert bill subject")
                print(url)
            }
            
            guard let json = result else{
                return
            }
            
            var legislativeSubjects = "Legislative Subjects: "
            if(!json.subjects!.legislativeSubjects.isEmpty){
                legislativeSubjects.append("\(json.subjects!.legislativeSubjects[0].name)")
                if(json.subjects!.legislativeSubjects.count > 1){
                    for i in 1...json.subjects!.legislativeSubjects.count-1{
                        legislativeSubjects.append(", \(json.subjects!.legislativeSubjects[i].name)")
                    }
                }
            } else{
                legislativeSubjects = ""
            }
            
            var policyArea = "Policy Area: "
            if(json.subjects!.policyArea != nil){
                policyArea.append(json.subjects!.policyArea!.name)
            } else{
                policyArea = ""
            }
            if(legislativeSubjects == "" && policyArea == ""){
                self.subject = "No current subject"
            } else if (legislativeSubjects == ""){
                self.subject = policyArea
            }
            else{
                self.subject = legislativeSubjects + "\n" + policyArea
            }
        })
        task.resume()
    }
    
    private func getBillAction(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            
            //convert json data into obejct
            var result: BillActionInfo?
            do{
                result = try JSONDecoder().decode(BillActionInfo.self, from: data)
            }
            catch{
                print("failed to convert bill summary")
            }
            
            guard let json = result else{
                return
            }
            if(json.actions != nil){
                self.action = json.actions![0].actionDate + ": " + json.actions![0].text
                if (json.actions!.count > 1){
                    for i in 1...json.actions!.count-1{
                        self.action.append("\n\(json.actions![i].actionDate): \(json.actions![i].text)")
                    }
                }
            }
        })
        task.resume()
    }
    
    
    private func updateBillPage(){
        summaryText.text = summary
        subjectText.text = subject
        actionsText.text = action
    }
    
    //summary
    struct BillSummaryInfo: Codable{
        let summaries: [BillSummary]
    }
    struct BillSummary: Codable{
        let text: String
    }
    
    //subject
    struct BillSubjectInfo: Codable{
        let subjects: BillSubjectTypes?
    }
    struct BillSubjectTypes: Codable{
        let legislativeSubjects: [LegislativeSubjects]
        let policyArea: PolicyArea?
    }
    struct LegislativeSubjects: Codable{
        let name: String
    }
    struct PolicyArea: Codable{
        let name: String
    }
    
    //action
    struct BillActionInfo: Codable{
        let actions: [BillAction]?
    }
    struct BillAction: Codable{
        let actionDate: String
        let text: String
    }

}
