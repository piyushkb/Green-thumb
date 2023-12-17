
import UIKit

class ProfileVC: UIViewController {

   
   @IBOutlet weak var firstName: UITextField!
   @IBOutlet weak var lastName: UITextField!
   @IBOutlet weak var email: UITextField!
 
 
   override func viewWillAppear(_ animated: Bool) {
       self.fetchData()
   }
   func fetchData() {
       
       if let user =  DatabseHelper.shared.getUser() {
                    self.firstName.text = "First Name : \(user.firstName!)"
                    self.lastName.text = "Last Name : \(user.lastName!)"
                    self.email.text = "Email : \(user.email!)"
           
       }
       
   }
   
    @IBAction func onName(_ sender: Any) {
        
        
    }
    
    @IBAction func logout(_ sender: Any) {
       
       showConfirmationAlert(message: "Are you sure want to logout?") { _ in
           
           let defaults = UserDefaults.standard
           let dictionary = defaults.dictionaryRepresentation()
           dictionary.keys.forEach{key in   defaults.removeObject(forKey: key)}
           
           SceneDelegate.sceneDelegate?.isLoggedIn()
       }
      
   }
}
