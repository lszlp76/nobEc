//
//  CellModel.swift
//  travelguide
//
//  Created by ulas özalp on 29.06.2022.
//

import UIKit

class CellModel: UITableViewCell {

    @IBOutlet weak var phoneNumberText: UILabel!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var pharmacyNameText: UILabel!
    @IBOutlet weak var distanceText: UILabel!
    
    @IBOutlet weak var countyText: UILabel!
    
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
