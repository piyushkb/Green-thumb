 

import UIKit

class UpdateProfileVC: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    
    override func viewDidLoad() {
        
        if let user = DatabseHelper.shared.getUser() {
                     self.firstName.text = "\(user.firstName!)"
                     self.lastName.text = "\(user.lastName!)"
            
        }
        
        self.firstName.isUserInteractionEnabled = true
        self.lastName.isUserInteractionEnabled = true
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        
        let user = DatabseHelper.shared.getUser()!
            
        user.firstName = self.firstName.text!
        user.lastName = self.lastName.text!
        user.email = user.email!
        
        DatabseHelper.shared.updateUser(user)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
