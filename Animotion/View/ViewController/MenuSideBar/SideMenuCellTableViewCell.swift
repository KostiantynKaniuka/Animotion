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
    @IBOutlet weak var darkView: UIView!
    
    static let sideMenuReuseId = "SideMenuCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureCellAppearance()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureCellAppearance() {
        cellImage.layer.cornerRadius = 15
        cellImage.clipsToBounds = true
        darkView.layer.cornerRadius = 15
        darkView.clipsToBounds = true
    }
}
