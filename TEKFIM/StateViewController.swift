//
//  StateViewController.swift
//  TEKFIM
//
//  Created by Tiffany Nguyen on 2/18/23.
//

import UIKit

class StateViewController: UIViewController {

    @IBOutlet weak var statesTable: UITableView!
    @IBOutlet weak var stateIcon: UIImageView!
    
    static var states = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut",
                         "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
                         "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
                         "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
                         "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma",
                         "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas",
                         "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statesTable.delegate = self
        statesTable.dataSource = self
        
        updateStates()
    }
    
    func updateStates(){
        //iterate from 0 to count, incluseve, add add tas
//        for x in 0..<StateViewController.states.count {
//            if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String{
//                tasks.append(task)
//            }
//        }
        statesTable.reloadData()
    }
    
}

extension StateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //deselect or unhghlight app, indexPath is position
      
        //todo: navigation
    }
}

extension StateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StateViewController.states.count;
    }
    
    //dequeue cell: use template over and over to get instance, then figure cell to configure icon and text
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StateCell", for:indexPath) //indentifier is name from main storyboard
        cell.textLabel?.text = StateViewController.states[indexPath.row] //position of cell in tableview
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor(named: "TekfimNavy")
//        cell.StateIcon = UIImage(named: "icons8-alabama-50")
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor(named: "TekfimGray")
        } else{
            cell.backgroundColor = UIColor(named: "TekfimRed")
        }
        
        return cell
    }
}