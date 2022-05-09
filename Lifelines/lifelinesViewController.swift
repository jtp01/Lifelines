//
//  ViewController.swift
//  Lifelines
//
//  Created by Jason Puwardi on 27/04/22.
//

import UIKit



class lifelinesViewController: UIViewController {


    @IBOutlet weak var lifelinesTableView: UITableView!
    
    //unwind segue
    @IBAction func unwindToLifelines(_ seg: UIStoryboardSegue) {
        
    }
    
    //global variables
    var items: [Lifelines]?
    var lifelineIndex: Int?
    
    //Accessing Managed Object in Persistent Container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Load the view
    override func viewDidLoad() {
        super.viewDidLoad()
        lifelinesTableView.delegate = self
        lifelinesTableView.dataSource = self
        lifelinesTableView.dragDelegate = self
        lifelinesTableView.dragInteractionEnabled = true
        
        fetchLifelines()
        
    }
    
    //Fetch the data from database.
    func fetchLifelines() {
        do {
            self.items = try context.fetch(Lifelines.fetchRequest())
            
            //reload the table view
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
            
            //set the data to...
            newDeadline.activityTitle = titleDeadline.text
            newDeadline.activityDate = Date()
            newDeadline.activityGroups = self.groups[0]
            
            //save the data to core data
            do {
                try self.context.save()
            }
            catch {
                print (error)
            }
            
            //fetch the data and reload the table view
            self.fetchLifelines()
            
        }
        
        //cancel alert
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) {
            (action) in
            lifelinesAlert.dismiss(animated: true)
        }
        
        //add 2 button
        lifelinesAlert.addAction(saveButton)
        lifelinesAlert.addAction(cancelButton)
        
        //show alert
        self.present(lifelinesAlert, animated: true)
        
        
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
       
        //set the deadline remaining time
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
        
        //logic to show how much time left
        if deadlineDate == currDate{
            lifelines.activityDeadlineLbl.text = "Today!"
        } else if deadlineMonth == currMonth {
            countdown = deadlineDate - currDate
            lifelines.activityDeadlineLbl.text = String(countdown) + "days left"
        } else if deadlineMonth > currMonth {
            countdown = deadlineMonth - currMonth
            lifelines.activityDeadlineLbl.text = String(countdown) + "days left"
        }
        
        //assign name to titlelabel in table cell
        lifelines.activityTitleLbl.text = deadlines.activityTitle
        
        //return the table cell
        return lifelines
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lifelineIndex = indexPath.row
        performSegue(withIdentifier: "lifelinesToTasks", sender: self)
        
    }
    
    //Prepare for next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lifelinesToTasks" {
            
            
            let selectedLifeline = self.items![lifelineIndex ?? 0]
            
            //prepare data for passing
            if let vc = segue.destination as? activityViewController {
                vc.topTitle = selectedLifeline.activityTitle ?? "Failed"
            }
        }
    }
    
    //swipe action for delete data
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
       //decide what row to delete
        let deadlinesToEdit = self.items![indexPath.row]
    
        //create the action button and what it does
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (deleteAction, view, completionHandler) in
            self.context.delete(deadlinesToEdit)
            
            //save data
            do {
                try self.context.save()
            } catch {
                
            }
            
            //re-fetch data
            self.fetchLifelines()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
}

//drag and drop delegate
extension lifelinesViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = self.items![indexPath.row]
        return [dragItem]
    }
    
    //move the row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let move = self.items![sourceIndexPath.row]
        self.items?.remove(at: sourceIndexPath.row)
        self.items?.insert(move, at: sourceIndexPath.row)
    }
    
}
