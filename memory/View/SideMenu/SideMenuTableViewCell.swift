//
//  SideMenuTableViewCell.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/21.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    let sideMenuLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupSideMenuCell(text: String) {
        sideMenuLabel.text = text
    }
    
}
