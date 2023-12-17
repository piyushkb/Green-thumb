import Foundation
import CoreData
import UIKit


class DatabseHelper {
    
    static let shared = DatabseHelper()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Green_Thumb")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    
    func getUser() -> User? {
        
        let email = UserDefaultsHelper.shared.getEmail().lowercased()
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
     
        
        do {
            let users = try managedContext.fetch(fetchRequest)
            return users.first
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    
    func deleteSavedPlant(_ plant: SavedPlants, completion: @escaping () -> Void) {
        persistentContainer.viewContext.delete(plant)
        do {
            try persistentContainer.viewContext.save()
            completion() // Call the completion handler with nil to indicate success
        } catch {
            print("Failed to save context after deleting plant: \(error)")
            completion() // Call the completion handler with the error if saving fails
        }
    }

    
    func fetchSavedPlants() -> [SavedPlants] {
        
          let email =  UserDefaultsHelper.shared.getEmail().lowercased()
            
            let fetchRequest = NSFetchRequest<SavedPlants>(entityName: "SavedPlants")
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)

            do {
                let savedPlants = try persistentContainer.viewContext.fetch(fetchRequest)
                return savedPlants
            } catch {
                print("Failed to fetch saved plants: \(error)")
                return []
            }
        }
    
    func savePlant(plantName:String,image:String) {
        
        if(isAlreadySaved(plantName, UserDefaultsHelper.shared.getEmail().lowercased())) {
            showAlert(message: "Plant Already Saved")
        }else {
            savePlantData(plantName: plantName, image: image, email: UserDefaultsHelper.shared.getEmail().lowercased())
            showAlert(message: "Plant Saved")
        }
    
    }
    
    func isAlreadySaved(_ plantName:String,_ email: String) -> Bool {
        let fetchRequest = NSFetchRequest<SavedPlants>(entityName: "SavedPlants")
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND plantName == %@", email.lowercased(), plantName)

            do {
                let count = try persistentContainer.viewContext.count(for: fetchRequest)
                return count > 0
            } catch {
                return false
            }
   }
    
    func savePlantData(plantName: String, image: String, email: String) {
            let context = persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "SavedPlants", in: context)!
            let savedPlant = NSManagedObject(entity: entity, insertInto: context) as! SavedPlants

            savedPlant.setValue(plantName, forKey: "plantName")
            savedPlant.setValue(image, forKey: "image")
            savedPlant.setValue(email, forKey: "email")

            do {
                try context.save()
            } catch {
                print("Failed to save plant data: \(error)")
            }
        }
 
    func saveReminderData(plantName: String, dateAndTime: String, task: String, frequency: String) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PlantReminder", in: context)!
        let savedPlant = NSManagedObject(entity: entity, insertInto: context) as! PlantReminder
        
        savedPlant.setValue(plantName, forKey: "plantname")
        savedPlant.setValue(dateAndTime, forKey: "dateAndTime")
        savedPlant.setValue(task, forKey: "plantTask")
        savedPlant.setValue(frequency, forKey: "frequency")
        
        do {
            try context.save()
        } catch {
            print("Failed to save reminder data: \(error)")
        }
    }
    
    func fetchReminder() -> [ReminderData] {
        let fetchRequest = NSFetchRequest<PlantReminder>(entityName: "PlantReminder")

        do {
            let reminders = try persistentContainer.viewContext.fetch(fetchRequest)

            // Convert Reminder entities to ReminderData
            let reminderDataArray = reminders.map { reminder in
                return ReminderData(
                    plantname: reminder.plantname ?? "",
                    dateAndTime: reminder.dateAndTime ?? "",
                    plantTask: reminder.plantTask ?? "",
                    frequency: reminder.frequency ?? ""
                )
            }

            return reminderDataArray
        } catch let error as NSError {
            print("Failed to fetch reminders: \(error.localizedDescription)")
            return []
        }
    }

    
    func deletePlantReminder(plantName: String, dateAndTime: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlantReminder")

        fetchRequest.predicate = NSPredicate(format: "plantname == %@ AND dateAndTime == %@", plantName, dateAndTime)

        do {
            let reminders = try persistentContainer.viewContext.fetch(fetchRequest)

            for reminder in reminders {
                if let reminderObject = reminder as? NSManagedObject {
                    persistentContainer.viewContext.delete(reminderObject)
                }
            }

            try persistentContainer.viewContext.save()
            showOkAlertAnyWhereWithCallBack(message: "Reminder deleted successfully") {
            }
            
        } catch let error as NSError {
            print("Failed to delete record: \(error.localizedDescription)")
        }
    }
    
    func updateUser(_ user: User) {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error saving : \(error.localizedDescription)")
        }
    }

 
    func crateAccount(firstName: String,lastName:String, email: String,password:String){
        
        let email = email.lowercased()
        
        if(isAlreadyRegister(email)) {
            showAlert(message:"Email Already Registered")
            return
        }
        
        let managedContext = persistentContainer.viewContext
        
        let user = User(context: managedContext)
        user.firstName = firstName
        user.lastName = lastName
        user.email = email
        user.password = password
     
       
        do {
            try managedContext.save()
            showOkAlertAnyWhereWithCallBack(message: "Account created") {
                SceneDelegate.sceneDelegate?.isLoggedIn()
            }
          
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
   
    func login(email: String, password: String) {
        
            let email = email.lowercased()

            let managedContext = persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)

            do {
                let users = try managedContext.fetch(fetchRequest)
                guard let user = users.first else {
                    showAlert(message: "Email not found")
                    return
                }
                if user.password == password {
                    UserDefaultsHelper.shared.saveLogin(email: user.email!)
                    SceneDelegate.sceneDelegate?.isLoggedIn()
                } else {
                    showAlert(message:"Password does not match")
                    return
                }
            } catch _ as NSError {
                return
            }
        }
        
   
    func isAlreadyRegister(_ email: String) -> Bool {
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
            do {
                let count = try persistentContainer.viewContext.count(for: fetchRequest)
                return count > 0
            } catch {
                return false
            }
        }
    
}

 
 
class UserDefaultsHelper  {
   
   static  let shared =  UserDefaultsHelper()
    
   func clearUserDefaults() {
       
       let defaults = UserDefaults.standard
       let dictionary = defaults.dictionaryRepresentation()

           dictionary.keys.forEach
           {
               key in   defaults.removeObject(forKey: key)
           }
   }
   
   func isLoggedIn() -> Bool{
       
       let email = getEmail()
       
       if(email.isEmpty) {
           return false
       }else {
          return true
       }
     
   }
    
   func getEmail()-> String {
       
       let email = UserDefaults.standard.string(forKey: "email") ?? ""
       
       print(email)
       return email
   }
   

  
   
   func saveLogin(email:String) {
       UserDefaults.standard.setValue(email, forKey: "email")
   }
   
 
   
}

 
struct ReminderData {
    let plantname: String?
    let dateAndTime: String?
    let plantTask: String?
    let frequency: String?
}
