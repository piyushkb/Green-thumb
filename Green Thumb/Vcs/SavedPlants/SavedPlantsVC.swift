 

import UIKit

class SavedPlantsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var savedPlants:[SavedPlants] = []
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "SavedPlantList", bundle: nil), forCellReuseIdentifier: "SavedPlantList")
        self.fetchPlants()
    }
    
    
    func fetchPlants(){
        self.savedPlants = DatabseHelper.shared.fetchSavedPlants()
        self.tableView.reloadData()
        if(savedPlants.isEmpty) {
            showAlert(message: "No Saved Plants")
        }
    }
}


extension SavedPlantsVC:UITableViewDelegate,UITableViewDataSource {
    
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return savedPlants.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let plant = savedPlants[indexPath.row]
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "SavedPlantList", for: indexPath) as! SavedPlantList
       
          cell.plantName.text =  plant.plantName ?? ""
          cell.plantImage.image = convertBase64StringToImage(imageBase64String: plant.image!)
          
          return cell
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
      
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let plant = savedPlants[indexPath.row]
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlantDetailsVC") as! PlantDetailsVC
          vc.image = convertBase64StringToImage(imageBase64String: plant.image!)
          vc.identifiedPlant = plant.plantName!
          self.navigationController?.pushViewController(vc, animated: true)
      }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               // Remove the item from your data source
               
               let plant = savedPlants[indexPath.row]
               
             
               // Perform any additional actions you need, such as deleting from the database
               DatabseHelper.shared.deleteSavedPlant(plant) {
                   self.fetchPlants()
               }
               
           }
       }
    
}
