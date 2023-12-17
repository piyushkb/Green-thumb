import UIKit





extension Date {
   func dateBySubtractingMonths(_ months: Int) -> Date {
       var dateComponents = DateComponents()
       dateComponents.month = -months
       return Calendar.current.date(byAdding: dateComponents, to: self)!
   }
   
   func dateByAddingMonths(_ months: Int) -> Date {
           var dateComponents = DateComponents()
           dateComponents.month = months
           return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

 

class ButtonWithShadow: UIButton {

    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }

    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
        
    }

}



extension String {
    
    
    func emailIsCorrect() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
}



func showAlert(message:String){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
      // completion?(true)
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
}

func showOkAlertAnyWhereWithCallBack(message:String,completion:@escaping () -> Void){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
       completion()
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
  
}

func showConfirmationAlert(message: String, yesHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: yesHandler)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        UIApplication.topViewController()!.present(alertController, animated: true, completion: nil)
}






extension UITableView {
    
    func registerCells(_ cells : [UITableViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: cell))
        }
    }
}

 
extension UICollectionView {
    
    func registerCells(_ cells : [UICollectionViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: cell))
        }
    }
}

 



extension UIView {
    
    func dropShadow(scale: Bool = true , height:Int = 3 , shadowRadius:CGFloat = 3,radius:CGFloat = 0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1, height: height)
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        layer.cornerRadius = radius
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
}

 


extension DateFormatter {
   static func POSIX() -> DateFormatter {
       let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "en_US_POSIX")
       return dateFormatter
   }
}
// handel 24 hours and 12 hours settinge enable disable
 

 

extension String {
    func removeCoordinates() -> String {
        if let atIndex = self.firstIndex(of: "@") {
            let address = self[..<atIndex].trimmingCharacters(in: .whitespacesAndNewlines)
            return String(address)
        } else {
            return self
        }
    }
}


extension Date {
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension Double{
    func getTimeOnly() ->String {
        
        let date = Date(milliseconds : Int64(self))
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d HH:mm"
            return "\(dateFormatter.string(from: date))"
    }
}



extension UITableView {
    
    
    enum Position {
      case top
      case bottom
    }
    
    func scroll(to: Position, animated: Bool) {
        let sections = numberOfSections
        let rows = numberOfRows(inSection: numberOfSections - 1)
        switch to {
        case .top:
            if rows > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: animated)
            }
            break
        case .bottom:
            if rows > 0 {
                let indexPath = IndexPath(row: rows - 1, section: sections - 1)
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
            break
        }
    }
}



extension UIView {
    func maskedCorners(corners: UIRectCorner, radius: CGFloat) {
           
                self.clipsToBounds = true
                self.layer.cornerRadius = radius
                var masked = CACornerMask()
                if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
                if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
                if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
                if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
                self.layer.maskedCorners = masked
            }
    
    func dropShadow(scale: Bool = true , height:Int = 3 , shadowRadius:CGFloat = 3) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1, height: height)
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
             
}

extension UIViewController{
    func showActionSheetPopup(actionsTitle:[String], title:String?,message:String,completion:@escaping (Int) -> Void){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 300, width: 300, height: 500)
        alert.view.tintColor = .black
        for (index,actionsTitle) in actionsTitle.enumerated(){
            
            alert.addAction(UIAlertAction(title: actionsTitle, style: UIAlertAction.Style.default, handler: {(UIAlertAction)in
                
                completion(index)
                
            }))}
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    func encodedURL() -> String {
        
        return self.replacingOccurrences(of: " ", with: "%20")
        //return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    
}

func convertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 0.1)?.base64EncodedString() ?? ""
}

func convertBase64StringToImage (imageBase64String:String) -> UIImage {
    let imageData = Data(base64Encoded: imageBase64String)
    let image = UIImage(data: imageData!)
    return image!
}
