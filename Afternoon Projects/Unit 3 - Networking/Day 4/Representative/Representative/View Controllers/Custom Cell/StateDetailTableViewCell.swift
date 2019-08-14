//
//  StateDetailTableViewCell.swift
//  Representative
//
//  Created by Kevin Tanner on 8/14/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateDetailTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    // MARK: - Properties
    var representative: Representative? {
        didSet {
            updateViews()
        }
    }


//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    
    
    // MARK: - Custom Methods
    
    func updateViews() {
        guard let representative = representative else { return }
        
        self.nameLabel.text = representative.name
        self.partyLabel.text = representative.party
        self.districtLabel.text = representative.district
        self.websiteLabel.text = representative.link
        self.phoneNumberLabel.text = representative.phone
    }


}
