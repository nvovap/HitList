//
//  ViewController.swift
//  HitList
//
//  Created by nvovap on 11/3/16.
//  Copyright © 2016 nvovap. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //var names = [String]()
    var people = [NSManagedObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\"The List\""
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Namae", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) -> Void in
            let textField = alert.textFields?.first
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let managerObject = appDelegate.persistentContainer.viewContext
            
            
            //let person = NSEntityDescription.entity(forEntityName: "Person", in: managerObject)
            
            let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: managerObject)
            
            person.setValue(textField!.text!, forKey: "name")
            
            self.people.append(person)
            self.tableView.reloadData()
            
            do {
                try managerObject.save()
            } catch let error as NSError {
                print("Could not save \(error.localizedDescription), \(error.userInfo)")
            }
            
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(UIAlertAction) -> Void in
            
        })
        
        alert.addTextField { (text: UITextField) in
            
        }
        
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
        
    }

}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let person = people[indexPath.row]
        
        cell.textLabel?.text = person.value(forKey: "name") as? String
        
        return cell

    }
}
