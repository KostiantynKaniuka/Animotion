//
//  SideMenuCellTableViewCell.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 01.06.2023.
//

import UIKit

class SideMenuCellTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    static let sideMenuReuseId = "SideMenuCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
