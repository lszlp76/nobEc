//
//  SettingsCellModelTableViewCell.swift
//  travelguide
//
//  Created by ulas özalp on 30.06.2022.
//

import UIKit

class SettingsCellModelTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    @IBAction func toggleSwitced(_ sender: Any) {
    }
    
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
