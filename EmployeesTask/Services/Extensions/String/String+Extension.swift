//
//  String+Extension.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = self.size(withAttributes: fontAttributes)
            return size.width
        }
}
