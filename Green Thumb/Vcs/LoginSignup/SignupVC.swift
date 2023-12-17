import UIKit


class SignupVC: UITableViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var email: UITextField!
   
   
     @IBAction func onLockButtonPressed(_ sender: UIButton) {
        
        if(sender.tag == 2) {
            
            self.confirmPassword.isSecureTextEntry.toggle()
           
            let buttonImageName = confirmPassword.isSecureTextEntry ? "lock" : "lock.open"
                if let buttonImage = UIImage(systemName: buttonImageName) {
                    sender.setImage(buttonImage, for: .normal)
            }
            
        }else {
           
            self.password.isSecureTextEntry.toggle()
           
            let buttonImageName = password.isSecureTextEntry ? "lock" : "lock.open"
                if let buttonImage = UIImage(systemName: buttonImageName) {
                    sender.setImage(buttonImage, for: .normal)
            }
        }
       
    }
    
    
  
    
    @IBAction func onCrateAccount(_ sender: Any) {
        
        if(self.firstName.text!.isEmpty) {
             showAlert(message: "Please enter first Name")
             return
        }
        
        if(self.lastName.text!.isEmpty) {
             showAlert(message: "Please enter last Name.")
             return
        }
        
        if !email.text!.emailIsCorrect() {
            showAlert(message: "Please enter valid email id")
            return
        }
        
     
       
        if(self.password.text!.isEmpty) {
             showAlert(message: "Please enter password.")
             return
        }
        
        if self.password.text!.count < 6 {
            showAlert(message: "Password must be at least 6 characters long.")
            return
        }

        
        if(self.password.text! != self.confirmPassword.text!) {
             showAlert(message: "Password does not match.")
             return
        }
        
        
        DatabseHelper.shared.crateAccount(firstName: self.firstName.text!, lastName: self.lastName.text!, email: self.email.text!, password: self.password.text!)
 
 
        
       
      
       
    }
}
    


