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
        statesTable.reloadData()
    }
    
}

extension StateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.backgroundColor = UIColor(named: "TekfimNavy")
        tableView.deselectRow(at: indexPath, animated: true) //deselect or unhghlight app, indexPath is position
//        print(indexPath)
      
        //navigate to polician select page
        let vc = storyboard?.instantiateViewController(withIdentifier: "PoliticianSelect") as! PoliticianSelectViewController
        vc.state = StateViewController.states[indexPath[1]]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension StateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StateViewController.states.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        stateIcon = UIImageView(image: UIImage(named: "icons8-alabama-50"))

        let cell = tableView.dequeueReusableCell(withIdentifier: "StateCell", for:indexPath) as! StateTableViewCell
        cell.label.text = StateViewController.states[indexPath.row]
        let imageName = "icons8-\(StateViewController.states[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "-", options: .literal, range: nil))-50"
        cell.stateIcon.image = UIImage(named: imageName)
        
//        cell.textLabel?.text = StateViewController.states[indexPath.row]
//        cell.textLabel?.textAlignment = .center
//        cell.textLabel?.textColor = UIColor(named: "TekfimNavy")
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor(named: "TekfimGray")
        } else{
            cell.backgroundColor = UIColor(named: "TekfimRed")
        }
        
        return cell
    }
}
