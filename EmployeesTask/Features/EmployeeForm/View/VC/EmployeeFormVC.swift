//
//  EmployeeFormVC.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit

class EmployeeFormVC: BaseVC {
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var skillsCollectionView: UICollectionView!
    @IBOutlet private weak var fullNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    
    weak var viewModel: EmployeeFormViewModelProtocol!
    init(viewModel: EmployeeFormViewModelProtocol) {
        super.init(baseViewModel: viewModel)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSkillsCollectionView()
        fillData()
        setupBinding()
        viewModel.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupSkillsCollectionView() {
        skillsCollectionView.dataSource = self
        skillsCollectionView.delegate   = self
        skillsCollectionView.register(cellType: SkillCell.self)
    }
    func setupBinding() {
        viewModel.onSuccessFetching = {[weak self] in
            guard let self else { return }
          
            self.skillsCollectionView.reloadData()
        }
        viewModel.updatedAddedSuccessfully = {[weak self] formMode in
            guard let self else { return }
            switch formMode {
            case .add:
                self.showMessage(message: "Added Successfully", type: .success)
            case .edit:
                self.showMessage(message: "Updated Successfully", type: .success)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func saveEmployee(_ sender: Any) {
        if let fullName = fullNameTextField.text, !fullName.isEmpty {
            let email = emailTextField.text ?? ""
            viewModel.saveEmployee(fullName: fullName, email: email)
        } else {
            self.showMessage(message: "Full Name is required", type: .error)
        }
       
    }
    
    @IBAction func editImageButtonTapped(_ sender: Any) {
        openImageSeletor()
    }
    func fillData() {
        switch self.viewModel.getFormMode() {
        case .add:
            print("add")
        case .edit(let employee, _):
            if let photoData = employee.photoData {
                profileImage.image = UIImage(data: photoData)
            }
            fullNameTextField.text = employee.fullName
            emailTextField.text = employee.email
            self.viewModel.setSelected(skills: employee.skills ?? [])
        }
    }
    
}

// MARK: - ImageSelection
extension EmployeeFormVC {
    
    func openImageSeletor() {
        let picker = UIImagePickerController()
        picker.allowsEditing   = true
        picker.delegate = self
        let style: UIAlertController.Style = UIDevice.isIpad ? .alert : .actionSheet
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: style)
        alert.addAction(UIAlertAction(title: "Delete Image", style: .destructive, handler: { _ in
            self.showDeletelert()
        }))
      
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                if !UIDevice .isSimulator {
                    picker.sourceType = .camera
                    self.present(picker, animated: true, completion: nil)
                } else {
                    self.showMessage(message: "Not Supported device", type: .error)
                }
               
            }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            picker.sourceType = .photoLibrary // the default
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      //  addActionSheetForiPad(actionSheet: alert)
        self.present(alert, animated: true, completion: nil)
    }
    func showDeletelert() {
        
        let alert = UIAlertController(title: "Deletion",
                                      message: "Are you sure to delete image ?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let self = self else { return }
            self.profileImage.image = Asset.Images.profileAvatar.image
            self.viewModel.selectedImageData = nil
        }))
        alert.addAction(UIAlertAction(title: "No",
                                      style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

extension EmployeeFormVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      //  self.updateData = false
        let editedImage   = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        var selectedImage = UIImage()
   
        if let editedImage = editedImage {
            profileImage.image = editedImage
            selectedImage = editedImage
        } else if let originalImage = originalImage {
            selectedImage = originalImage
            profileImage.image = originalImage
        }
        let data = selectedImage.pngData()
        
        viewModel.selectedImageData = data
        dismiss(animated: true, completion: nil)
    }
}
