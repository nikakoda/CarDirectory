//
//  NewPlaceViewController.swift

//  Created by Ника Перепелкина on 02/09/2019.
//  Copyright © 2019 Nika Perepelkina. All rights reserved.
//

import UIKit

class NewCarViewController: UITableViewController {
    
    var currentCar: Car!
    var imageIsChanged = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeYear: UITextField!
    @IBOutlet weak var placeManufacturer: UITextField!
    @IBOutlet weak var placeModel: UITextField!
    @IBOutlet weak var placeTypeOfBody: UITextField!
    
    
    
    // @IBOutlet var ratingControl: RatingControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.choiceImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.choiceImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    
    
    func saveCar() {
        
        var image: UIImage?
        
        if imageIsChanged{
            image = placeImage.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        let newCar = Car(name: placeName.text!,
                             year: placeYear.text,
                             manufacturer: placeManufacturer.text,
                             imageData: imageData,
                             model: placeModel.text,
                             typeOfBody: placeTypeOfBody.text
                             )
        
        // rating: Double(ratingControl.rating)
        
        
        if currentCar != nil {
            try! realm.write {
                currentCar?.name = newCar.name
                currentCar?.year = newCar.year
                currentCar?.manufacturer = newCar.manufacturer
                currentCar?.imageData = newCar.imageData
                currentCar?.model = newCar.model
                currentCar?.typeOfBody = newCar.typeOfBody
                
            }
        } else {
            StorageManager.saveObject(newCar)
        }
        
        
    }
    
    
    
    private func setupEditScreen() {
        if currentCar != nil {
            setupNavigationBar()
            imageIsChanged = true // изображение остается
            
            guard let data = currentCar?.imageData, let image = UIImage(data: data) else { return }
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentCar?.name
            placeYear.text = currentCar?.year
            placeManufacturer.text = currentCar?.manufacturer
            placeModel.text = currentCar?.model
            placeTypeOfBody.text = currentCar?.typeOfBody
        }
    }
    
    
    private func setupNavigationBar() {
        
        // заголовок возврата
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        
        
        navigationItem.leftBarButtonItem = nil
        title = currentCar?.name
        saveButton.isEnabled = true
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}



extension NewCarViewController: UITextFieldDelegate {
    
    // скрыть клавиатуру
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @objc private func textFieldChanged() {
        
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
}


extension NewCarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func choiceImagePicker(source: UIImagePickerController.SourceType) {
        
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            
            present(imagePicker, animated: true)
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}
