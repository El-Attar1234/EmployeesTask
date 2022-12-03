//
//  BaseView.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import Foundation

protocol BaseView {
    func showIndicator()
    func hideIndicator()
    func showMessage(message: String, type: AlretMessageType)
}

enum AlretMessageType {
    case success
    case error
}
