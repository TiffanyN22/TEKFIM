//
//  PoliticianSelectViewController.swift
//  TEKFIM
//
//  Created by Tiffany Nguyen on 2/18/23.
//

import UIKit

class PoliticianSelectViewController: UIViewController {

    
    @IBOutlet weak var senatorsTable: UITableView!
//    var senators = [String]()
    var senators = ["Dianne Feinstein", "Alex Padilla"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        senatorsTable.delegate = self
        senatorsTable.dataSource = self
        
        updateSenators()
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
        return senators.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SenatorCell", for:indexPath)
        cell.textLabel?.text = senators[indexPath.row]
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
