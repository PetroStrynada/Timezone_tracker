//
//  TextTableViewCell.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 08.08.2023.


import UIKit

class TextTableViewCell: UITableViewCell {
    @IBOutlet var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
