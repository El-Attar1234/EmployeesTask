//
//  MainCustomButton.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit

@IBDesignable
class MainCustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonSetting()
        //     setDisable()
    }
    
    private func buttonSetting() {
        backgroundColor = Asset.Colors.mainBlue.color
        titleLabel?.font = .cairoBoldFont(with: 16)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 12
    }
    
}
