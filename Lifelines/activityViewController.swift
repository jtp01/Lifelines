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
    var items: [LifelinesTasks]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //outlets
    @IBOutlet weak var deadlineTitle: UINavigationItem!
    @IBOutlet weak var notAButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var taskTableView: UITableView!
    
    //unwind segue
    @IBAction func backButtonActivity(_ sender: Any) {
        performSegue(withIdentifier: "backToLifelines", sender: self)
    }
    
    //load view
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        //passed data into title
        self.title = topTitle
        
        lifelinesTableView.delegate = self
        lifelinesTableView.dataSource = self
        lifelinesTableView.dragDelegate = self
        lifelinesTableView.dragInteractionEnabled = true
        
        fetchTasks()
        
    }
    
    //Fetch the data from database.
    func fetchTasks() {
        do {
            self.items = try context.fetch(LifelinesTasks.fetchRequest())
            
            //reload the table view
            DispatchQueue.main.async {
                self.taskTableView.reloadData()
            }
            
        }
        catch {
            
        }
    }
    
    func createDatePickerTextField() {
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
    
    
    func createUIToolBar() {
            
        let pickerToolbar = UIToolbar()
        pickerToolbar.autoresizingMask = .flexibleHeight
            
            //customize the toolbar
        pickerToolbar.barStyle = .default
        pickerToolbar.barTintColor = UIColor.black
        pickerToolbar.backgroundColor = UIColor.white
        pickerToolbar.isTranslucent = false
            
            //add buttons
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:
            #selector(self.cancelPickerButtonClicked(_:)))
            cancelButton.tintColor = UIColor.white
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
                                            #selector(self.donePickerButtonClicked(_:)))
            doneButton.tintColor = UIColor.white
            
            //add the items to the toolbar
        pickerToolbar.items = [cancelButton, flexSpace, doneButton]
        
        
            
        }

    @objc func cancelPickerButtonClicked(_ button: UIBarButtonItem?) {
        self.dateTextField?.resignFirstResponder()
    }
    @objc func donePickerButtonClicked(_ button: UIBarButtonItem?) {
        dateTextField?.resignFirstResponder()
               let formatter = DateFormatter()
               formatter.dateStyle = .short
               dateTextField?.text = formatter.string(from: datePicker.date)
}



extension activityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tasks = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! activityTableViewCell
        
        tasks.
        
        return tasks
    }
    
}

