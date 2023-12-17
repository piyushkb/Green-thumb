import UIKit
import Vision
 
class HomeVC: UIViewController {
   
    var capturedImage:UIImage?
 
    lazy var classificationRequest: VNCoreMLRequest = {
    do {
       let config = MLModelConfiguration()
       let model = try VNCoreMLModel(for: Plant(configuration: config).model)
       let request = VNCoreMLRequest(model: model, completionHandler: {   [weak self] request, error in
             self?.processClassifications(for: request, error: error)
    })
       request.imageCropAndScaleOption = .centerCrop
       return request
    } catch {
       fatalError("Failed to load Vision ML model: \(error)")
    }}()
    
    @IBAction func onSavedPlants(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "SavedPlantsVC") as! SavedPlantsVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onReminder(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReminderListVC") as! ReminderListVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    @objc func onIdentifyPlant(_ sender: UIButton) {
        
        
        if(isRunningOnSimulator()) {
            
            showAlert(message: "Please use real device")
            return
            
        }
        
                let actions = ["Upload Photo", "Camera"]
        
                showActionSheetPopup(actionsTitle: actions, title: "", message: "Please select") { selectedIndex in
        
                    switch selectedIndex {
        
                    case 0:
                        // Upload Photo
                        self.open(sourceType: .photoLibrary)
                    case 1:
                        // Camera
                        self.open(sourceType: .camera)
                    default: break
                    }
                }
    }
    
    func open(sourceType:UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}


extension HomeVC {
    
    func createClassificationsRequest(for image: UIImage) {
       
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image)
        else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }
        self.capturedImage = image
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            }catch {
                print("Failed to perform \n\(error.localizedDescription)")
            }
        }
    }
 
    func processClassifications(for request: VNRequest, error: Error?) {
        
        
//        DispatchQueue.main.async {
//
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlantDetailsVC") as! PlantDetailsVC
//            vc.image = self.capturedImage
//            vc.identifiedPlant = "tulip"
//            self.navigationController?.pushViewController(vc, animated: true)
//
//
//        }
         
     
        
        
        DispatchQueue.main.async {

            guard let results = request.results else {

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    showAlert(message: "Unable to classify image.\n\(error!.localizedDescription)")
                })

                return
            }

            let classifications = results as! [VNClassificationObservation]

            if classifications.isEmpty {
                showAlert(message: "Nothing recognized.")
            } else {
                let topClassifications = classifications.prefix(1)

                guard let firstClassification = topClassifications.first else {
                    showAlert(message: "Unable to get classification details.")
                    return
                }

                let confidenceThreshold: Float = 0.93

                if firstClassification.confidence >= confidenceThreshold {
                    let descriptions = topClassifications.map { classification in
                        return String(format: "(%.2f) %@", classification.confidence, classification.identifier)
                    }

                    let text = descriptions.joined(separator: " |")
                    print(text)

                    if !firstClassification.identifier.isEmpty {

                        if(firstClassification.identifier == "others") {
                            showAlert(message: "Plant not found")
                            return
                        }
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlantDetailsVC") as! PlantDetailsVC
                        vc.image = self.capturedImage
                        vc.identifiedPlant = firstClassification.identifier
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        showAlert(message: "Image not identified")
                        return
                    }
                } else {
                    showAlert(message: "Confidence is less than \(confidenceThreshold)")
                }
            }
        }
    }

    
}


extension HomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            
            self.createClassificationsRequest(for: pickedImage)
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
 


func isRunningOnSimulator() -> Bool {
    #if targetEnvironment(simulator)
    return true
    #else
    return false
    #endif
}
