 
import UIKit
import CoreData

class ReminderListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var reminder = [
        "Watering",
        "Fertilizing",
        "Pruning",
        "Repotting",
        "Sunlight exposure",
        "Check for pests",
        "Others"
    ]

    var reminderPlant:[ReminderData] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reminderPlant = DatabseHelper.shared.fetchReminder()

        if(reminderPlant.isEmpty) {
            showAlert(message: "No Reminder")
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}


extension ReminderListVC : UITableViewDelegate,UITableViewDataSource {
    
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return reminderPlant.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let plant = reminderPlant[indexPath.row]
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedPlantList
       
          cell.plantName.text =  plant.plantname
          cell.plantDate.text = plant.dateAndTime
          cell.plantTask.text = plant.plantTask

          return cell
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
      
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let plant = reminderPlant[indexPath.row]
            reminderPlant.remove(at: indexPath.row)
            
            DatabseHelper.shared.deletePlantReminder(plantName: plant.plantname ?? "", dateAndTime: plant.dateAndTime ?? "")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
