//
//  lifelinesTableViewCell.swift
//  Lifelines
//
//  Created by Jason Puwardi on 29/04/22.
//

import UIKit

class lifelinesTableViewCell: UITableViewCell {

    @IBOutlet weak var viewlLifelinesCell: UIView!
    @IBOutlet weak var activityTitleLbl: UILabel!
    @IBOutlet weak var activityDeadlineLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
