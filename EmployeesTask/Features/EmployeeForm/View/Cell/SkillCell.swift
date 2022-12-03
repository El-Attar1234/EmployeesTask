//
//  SkillCell.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit

class SkillCell: UICollectionViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private  weak var skillLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(skill: String?, isSelectedSkill: Bool) {
        skillLabel.text = skill
        if isSelectedSkill {
            containerView.backgroundColor = Asset.Colors.mainBlue.color
            skillLabel.textColor = .white
        } else {
            containerView.backgroundColor = Asset.Colors.grayBackground.color
            skillLabel.textColor = Asset.Colors.itemBlack.color
        }
    }
    
}
