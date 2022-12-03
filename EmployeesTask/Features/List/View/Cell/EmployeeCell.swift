//
//  EmployeeCell.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit

class EmployeeCell: UITableViewCell {
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var employeeName: UILabel!
    @IBOutlet private weak var employeeEmail: UILabel!
    
    var deleteAction: (() -> Void)?
    var editAction: (() -> Void)?
    var employee: Employee?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setup(employee: Employee, editAction: (() -> Void)?, deleteAction: (() -> Void)?) {
        self.deleteAction = deleteAction
        self.editAction = editAction
        self.employee = employee
        self.employeeName.text = employee.fullName
        self.employeeEmail.text = employee.email
        if let photoData = employee.photoData {
            self.profileImageView.image = UIImage(data: photoData)
        }
        print("skills ->>>>> \(employee.skills)")
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.editAction?()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.deleteAction?()
    }
}
