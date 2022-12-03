//
//  EmployeeCell+Extension.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit

extension EmployeeCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DataCount-----> \(employee?.skills?.count)")
        return employee?.skills?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: SkillCell.self, for: indexPath)
        let skill = employee?.skills?[indexPath.item]
        cell.setup(skill: skill, isSelectedSkill: true)
        return cell
        
    }
 
}

// MARK: - Extension For UICollectionView Layout
extension EmployeeCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let skill = employee?.skills?[indexPath.item]
        let width = (skill ?? "").widthOfString(usingFont: .cairoSemiBoldFont(with: 20))
        return CGSize(width: width + 16, height: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return   5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
