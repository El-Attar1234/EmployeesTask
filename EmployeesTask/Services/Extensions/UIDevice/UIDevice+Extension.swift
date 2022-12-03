//
//  UIDevice+Extension.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit

extension UIDevice {
    static var isSimulator: Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
    
    static var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}
