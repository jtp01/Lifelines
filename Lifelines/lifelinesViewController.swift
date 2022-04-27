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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lifelinesTableView.delegate = self
        lifelinesTableView.dataSource = self
        
        fetchLifelines()
        
    }

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
    

}

extension lifelinesViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lifelines = tableView.dequeueReusableCell(withIdentifier: "LifelinesCell", for: indexPath)
        let deadlines = self.items![indexPath.row]
        
        lifelines.textLabel?.text = deadlines.activityTitle
        
        return lifelines
    }
    
    
}
