
import UIKit
import Lottie

class LoginViewController: UITableViewController {
   
   @IBOutlet weak var email: UITextField!
   @IBOutlet weak var password: UITextField!
   
    @IBOutlet weak var animationView: LottieAnimationView!
    override func viewDidLoad() {
        self.loadLottieAnimation()
    }
 
   @IBAction func onLogin(_ sender: Any) {
       
       if(email.text!.isEmpty) {
           showAlert(message: "Please enter your email id.")
           return
       }
       
       if(self.password.text!.isEmpty) {
           showAlert(message: "Please enter your password.")
           return
       }
       
       DatabseHelper.shared.login(email: email.text!, password: self.password.text!)
       
   }
   
   
   @IBAction func onLockButtonPressed(_ sender: UIButton) {
       
       self.password.isSecureTextEntry.toggle()
      
       let buttonImageName = password.isSecureTextEntry ? "lock" : "lock.open"
           if let buttonImage = UIImage(systemName: buttonImageName) {
               sender.setImage(buttonImage, for: .normal)
       }
   }
    
    
    func loadLottieAnimation() {
        animationView.animation = LottieAnimation.named("plant")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.play()
    }
}





