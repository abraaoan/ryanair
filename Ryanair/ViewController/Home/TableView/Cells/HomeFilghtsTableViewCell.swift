//
//  HomeFilghtsTableViewCell.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 23/10/21.
//

import UIKit

class HomeFilghtsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDepartTime: UILabel!
    @IBOutlet weak var lblArraiveTime: UILabel!
    @IBOutlet weak var lblOriginStation: UILabel!
    @IBOutlet weak var lblDestinationStation: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblFlightNumber: UILabel!
    @IBOutlet weak var price: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
