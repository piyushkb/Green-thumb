import UIKit
import WebKit

class PlantDetailsVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantTitle: UILabel!
    @IBOutlet weak var indecator: UIActivityIndicatorView!
    @IBOutlet weak var plantDetails: UITextView!


    var image: UIImage? = nil
    var identifiedPlant = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the image and title
        self.plantImage.image = image
        self.plantTitle.text = identifiedPlant.capitalized
       
     
        fetchPlantsDetails(plant: identifiedPlant.lowercased()) { result in
            
            DispatchQueue.main.async {
                self.indecator.isHidden = true
            }
          
            switch result {
            case .success(let plantDetails):
                
                DispatchQueue.main.async {
                    print("Plant Name: \(plantDetails.name)")
                    print("Description: \(plantDetails.des)")
                    self.plantDetails.text = plantDetails.des
                }
              
            
            case .failure(let error):
                switch error {
                case .invalidURL:
                    print("Invalid URL")
                case .networkError(let networkError):
                    print("Network Error: \(networkError.localizedDescription)")
                case .invalidResponse:
                    print("Invalid Response")
                case .decodingError(let decodingError):
                    print("Decoding Error: \(decodingError.localizedDescription)")
                case .plantNotFound:
                    print("Plant not found")
                }
            }
        }
    }


    @IBAction func onSave(_ sender: Any) {
        DatabseHelper.shared.savePlant(plantName: self.identifiedPlant.capitalized, image: convertImageToBase64String(img: self.image!))
    }
    
    @IBAction func onAddReminder(_ sender: Any) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReminderVC") as! AddReminderVC
        vc.identifiedPlant = identifiedPlant
        vc.image = image
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
