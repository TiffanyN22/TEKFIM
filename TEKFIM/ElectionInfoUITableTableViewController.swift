//
//  ElectionInfoUITableTableViewController.swift
//  TEKFIM
//
//  Created by Kara on 2/19/23.
//

import UIKit

//seperate address
var myStr1 = "1263 Pacific Ave Kansas City KS"
var addressArray = myStr1.components(separatedBy: " ")
var runningSet = ["Albemarle", "Brandywine", "Chesapeake"]
public var rowsInSec = 0

public struct run{
    var runFor = ""
    var runningPeople = [String]()
}
public var displays = [run]()


class ElectionInfoUITableTableViewController: UITableViewController {
    
    //@MainActor class UITableView : UIScrollView
    

    var apiKey = "AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM"
    
    // for loop that adds all of the seperated strings from addressArray together with %20 between them into a new string to use in the address= section
    var addressNum = 1263
    var address1st = "Pacific"
    var address2nd = "Ave"
    var city1st = "Kansas"
    var city2nd = "City"
    var state = "KS"
    var electionID = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = "https://www.googleapis.com/civicinfo/v2/voterinfo?key=AIzaSyBjl48j1CVf4T5O-uaPsNY9d_FFOzOsKwM&address=1263%20Pacific%20Ave.%20Kansas%20City%20KS&electionId=2000"

        getData(from: url)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
                displays[i].runFor = json.contests[i].type
                
                if(json.contests[i].candidates != nil){
                    let m = json.contests[i].candidates!.count - 1
                        for j in 0...m {
                            print(json.contests[i].candidates![j].name)
                            runningSet.append(json.contests[i].candidates![j].name)
                            displays[i].runningPeople[j].append(json.contests[i].candidates![j].name)
                            rowsInSec+=1
                        }
                }
//
            }
        })

        task.resume()
        
        

    }
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //structs for api req
    
    struct groupRunning: Codable{
        let runFor: String
        var name = [String]()
    }
    
    struct MyResult: Codable{
        let election: Election
        var contests = [Contests]()
    }
    
    struct Election: Codable{
        let id: String
        let name: String
        let electionDay: String
        let ocdDivisionId: String
    }
    
    struct Contests: Codable {
        let type: String
        let candidates: [Candidates]?
    }
    
    struct Candidates: Codable {
        let name: String
        let party: String
    }
    
    
}
/*
func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int // replace int with rowsInSec?
) -> Int{
    
}

func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
) -> UITableViewCell{
    
}

func tableView(
    _ tableView: UITableView,
    titleForHeaderInSection section: Int
) -> String?{
    */

     
func numberOfSections(in tableView: UITableView) -> Int {
    return displays.count
}
   
func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
    return displays[0].runningPeople.count
}



