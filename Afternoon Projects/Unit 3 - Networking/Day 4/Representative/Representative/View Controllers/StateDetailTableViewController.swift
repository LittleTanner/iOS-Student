//
//  StateDetailTableViewController.swift
//  Representative
//
//  Created by Kevin Tanner on 8/14/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateDetailTableViewController: UITableViewController {

    // MARK: - Properties
    var representative: [Representative] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    var state: String?
    

    // MARK: - Lifecycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        guard let state = state else { return }
        RepresentativeController.searchRepresentatives(forState: state) { (representative) in
            
            DispatchQueue.main.async {
                self.representative = representative
            }
        }

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return representative.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "stateDetailCell", for: indexPath) as? StateDetailTableViewCell else { return UITableViewCell()}

        let state = representative[indexPath.row]
        
        cell.nameLabel.text = state.name
        cell.districtLabel.text = state.district
        cell.partyLabel.text = state.party
        cell.phoneNumberLabel.text = state.phone
        cell.websiteLabel.text = state.link
        

        return cell
    }


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

}
