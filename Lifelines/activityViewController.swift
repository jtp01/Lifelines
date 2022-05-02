//
//  activityViewController.swift
//  Lifelines
//
//  Created by Jason Puwardi on 27/04/22.
//

import UIKit

class activityViewController: UIViewController {
    
    //passed data from prev screen
    var topTitle: String?

    //outlets
    @IBOutlet weak var deadlineTitle: UINavigationItem!
    @IBOutlet weak var notAButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
   
    //unwind segue
    @IBAction func backButtonActivity(_ sender: Any) {
        performSegue(withIdentifier: "backToLifelines", sender: self)
    }
    
  
    
    //load view
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        
        //textfield into date picker
        dateTextField.inputView = datePicker
        dateTextField.text = formatDate(date: Date())
        
        //passed data into title
        self.title = topTitle
        
    }
    
    //date picker show format
    @objc func dateChange (datePicker: UIDatePicker){
        dateTextField.text = formatDate(date: datePicker.date)
    }
    func formatDate (date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        return formatter.string(from: date)
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
