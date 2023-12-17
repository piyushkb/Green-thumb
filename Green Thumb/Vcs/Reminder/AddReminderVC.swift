 
import UIKit


class AddReminderVC: UIViewController {
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantTitle: UILabel!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var taskText: UITextField!
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var btnSelectTask: UIButton!
    @IBOutlet weak var daily: UIButton!
    @IBOutlet weak var oneTime: UIButton!

    var frequency = false
    let datePicker = UIDatePicker()
    var dateTime = Date()
    let dropDown = DropDown()
    var plantTasks = [
        "Watering",
        "Fertilizing",
        "Pruning",
        "Repotting",
        "Sunlight exposure",
        "Check for pests",
        "Others"
    ]
    
    var image: UIImage? = nil
    var identifiedPlant = "tulip"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    func setupView(){
        self.date.inputView =  datePicker
        self.datePicker.minimumDate = Date()
        self.showDatePicker()
        self.taskView.isHidden = true
        self.plantImage.image = image ?? UIImage(named: "aa")
        self.plantTitle.text = identifiedPlant.capitalized
        
        daily.setImage(UIImage(named: "circle"), for: .normal)
        daily.setImage(UIImage(named: "fillCircle"), for: .selected)
        
        oneTime.setImage(UIImage(named: "circle"), for: .normal)
        oneTime.setImage(UIImage(named: "fillCircle"), for: .selected)
        
        daily.isSelected = false
        oneTime.isSelected = true
    }

    @IBAction func onFrequencyClick(_ sender: UIButton){
        
        if sender == daily{
            daily.isSelected = true
            oneTime.isSelected = false
            frequency = true
        }else{
            daily.isSelected = false
            oneTime.isSelected = true
            frequency = false
        }
        
    }
    
    func scheduleNotification(at date: Date, title: String, body: String, repeatBool: Bool) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeatBool)
        
        let request = UNNotificationRequest(identifier: "YourNotificationIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                
                let frequency = repeatBool ? "Daily" : "One Time"
                
                DispatchQueue.main.async {
                    
                    DatabseHelper.shared.saveReminderData(plantName: self.plantTitle.text ?? "", dateAndTime: self.date.text ?? "", task: self.taskText.text ?? "", frequency: frequency)

                    showOkAlertAnyWhereWithCallBack(message: "Notification scheduled successfully") {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }

               
            }
        }
    }
    
    @IBAction func scheduleNotificationButtonTapped(_ sender: Any) {
        if(date.text!.isEmpty) {
            showAlert(message: "Please select date and time")
            return
        }
        
        if(self.taskText.text!.isEmpty) {
            showAlert(message: "Please select task")
            return
        }
        
        if(self.taskText.text!.isEmpty) {
            showAlert(message: "Please select task")
            return
        }
        
        let date = self.dateTime
        let title = "Green Thumb"
        let body = self.taskText.text ?? ""
        
        scheduleNotification(at: date, title: title, body: body, repeatBool: frequency)
    }
    
}

extension AddReminderVC {
    
    func showDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
        }
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donedatePicker))
        doneButton.tintColor = .black
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker))
        cancelButton.tintColor = .black
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        date.inputAccessoryView = toolbar
        date.inputView = datePicker
        
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        self.dateTime = datePicker.date
        date.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
}

//MARK:- Drop Down Region Methods

extension AddReminderVC{
    
    @IBAction func selectTask(_ sender: Any) {
        self.showDropDownMenu(btnTask: btnSelectTask, dataSource: plantTasks)
    }
    
    func showDropDownMenu(btnTask:UIButton, dataSource:[String]) {
        
        self.view.endEditing(true)
        
        dropDown.anchorView = btnTask
        dropDown.dataSource = dataSource
        dropDown.backgroundColor = .white
        dropDown.textColor = .black
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)! )
        
        self.dropDown.selectionAction = { (index: Int, item: String) in
            self.taskView.isHidden = false
            self.taskText.text = item
            
            if self.taskText.text == "Others"{
                self.taskText.text = ""
                self.taskText.placeholder = "Add task"
            }
        }
        
        dropDown.bounds.size.height = 150
        
        DispatchQueue.main.async {
            self.dropDown.show()
        }
    }
}
