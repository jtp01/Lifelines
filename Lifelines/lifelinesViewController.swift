//
//  ViewController.swift
//  Lifelines
//
//  Created by Jason Puwardi on 27/04/22.
//

import UIKit



class lifelinesViewController: UIViewController {


    @IBOutlet weak var lifelinesTableView: UITableView!
    
    var items: [Lifelines]?
    
    //Accessing Managed Object in Persistent Container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Load the view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lifelinesTableView.delegate = self
        lifelinesTableView.dataSource = self
        lifelinesTableView.dragDelegate = self
        lifelinesTableView.dragInteractionEnabled = true
        
        fetchLifelines()
        
    }
    
    //Prepare for next view controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var nextVC = segue.destination as? activityViewController
        nextVC?.receiveLifelines = tableView(<#T##tableView: UITableView##UITableView#>, didSelectRowAt: <#T##IndexPath#>)
        
    }
    
    //Fetch the data from database.
    func fetchLifelines() {
        do {
            self.items = try context.fetch(Lifelines.fetchRequest())
            DispatchQueue.main.async {
                self.lifelinesTableView.reloadData()
            }
            
        }
        catch {
            
        }
    }
    
    //Create activityGroups Array
    var groups = ["Choose One", "Work", "Study", "Others"]
    
    //Add button shows an alert to set the data
  
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        let lifelinesAlert = UIAlertController(title: "Deadline", message: "Set your deadlines here.", preferredStyle: .alert)
        
        //name insert
        lifelinesAlert.addTextField()
       
        
        //save button action
        let saveButton = UIAlertAction(title: "Add", style: .default) {
            (action) in
            let titleDeadline = lifelinesAlert.textFields![0]
            
            let newDeadline = Lifelines(context: self.context)
            newDeadline.activityTitle = titleDeadline.text
            newDeadline.activityDate = Date()
            newDeadline.activityGroups = self.groups[0]
            
            do {
                try self.context.save()
            }
            catch {
                print (error)
            }
            
            self.fetchLifelines()
            
        }
        
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) {
            (action) in
            lifelinesAlert.dismiss(animated: true)
        }
        
        // button added
        lifelinesAlert.addAction(saveButton)
        lifelinesAlert.addAction(cancelButton)
        
        //show alert
        self.present(lifelinesAlert, animated: true)
        
        
    }
    
    @objc func datePickerValueChanged (sender: UIDatePicker) {
        
    }
    

}

//table view delegate and data source
extension lifelinesViewController: UITableViewDelegate, UITableViewDataSource  {
    
    //receive how many rows from core data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    //cell data index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lifelines = tableView.dequeueReusableCell(withIdentifier: "LifelinesCell", for: indexPath) as! lifelinesTableViewCell
        let deadlines = self.items![indexPath.row]
        let currentDate = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day,.month], from: currentDate)
        let currDate: Int = components.day ?? 0
        let currMonth: Int = components.month ?? 0
        
        let deadlineComponents = calendar.dateComponents([.day, .month], from: deadlines.activityDate ?? Date())
        let deadlineDate: Int = deadlineComponents.day ?? 0
        let deadlineMonth: Int = deadlineComponents.month ?? 0
        
        var countdown: Int = 0
        
        if deadlineDate == currDate{
            lifelines.activityDeadlineLbl.text = "Today!"
        } else if deadlineMonth == currMonth {
            countdown = deadlineDate - currDate
            lifelines.activityDeadlineLbl.text = String(countdown) + "days left"
        } else if deadlineMonth > currMonth {
            countdown = deadlineMonth - currMonth
            lifelines.activityDeadlineLbl.text = String(countdown) + "days left"
        }
        
        lifelines.activityTitleLbl.text = deadlines.activityTitle
        
        
        return lifelines
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deadlinesToEdit = self.items?[indexPath.row]
        performSegue(withIdentifier: "lifelinesToTasks", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.items!.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deadlinesToEdit = self.items![indexPath.row]

        
        // gak jadi pakai tombol swipe edit untuk pop up alert
//        let editAction = UIContextualAction(style: .normal, title: "Edit") {
//            (editAction, view, completionHandler) in
//            let alert = UIAlertController(title: "Edit Deadline Names", message: "What do you want to call your deadline now? Please write an appropriate name.", preferredStyle: .alert)
//            alert.addTextField()
//
//
//            let textField = alert.textFields![0]
//            textField.text = deadlinesToEdit.activityTitle
//
//            let saveButton = UIAlertAction(title: "Add", style: .default) {
//                (action) in
//                let textField = alert.textFields![0]
//                deadlinesToEdit.activityTitle = textField.text
//
//                do {
//                    try self.context.save()
//                } catch {
//
//                }
//                self.fetchLifelines()
//            }
//
//            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) {
//                (action) in
//                alert.dismiss(animated: true)
//            }
//        }
    
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (deleteAction, view, completionHandler) in
            self.context.delete(deadlinesToEdit)
            
            do {
                try self.context.save()
            } catch {
                
            }
            
            self.fetchLifelines()
        }
        
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
}

extension lifelinesViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = self.items![indexPath.row]
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let move = self.items![sourceIndexPath.row]
        self.items?.remove(at: sourceIndexPath.row)
        self.items?.insert(move, at: sourceIndexPath.row)
    }
    
}
