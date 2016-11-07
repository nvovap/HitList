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
    var people = [Person]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managerContext = appDelegate.persistentContainer.viewContext
        
        let featchRequest = NSFetchRequest<Person>(entityName: "Person")
        
        do {
            let person = try managerContext.fetch(featchRequest)
            
           // if let person = person {
                people = person
          //  }
            
        } catch let error as NSError {
            print("Could not featch \(error), \(error.userInfo)")
        }

        
        
    }
    
    
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
            
            let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: managerObject) as! Person
            
            //person.setValue(textField!.text!, forKey: "name")
            
            person.name = textField!.text
            
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
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let person = people[indexPath.row]
        
        cell.textLabel?.text = person.name
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let managerContext = appDelegate.persistentContainer.viewContext
            
            let person = people[indexPath.row]
            
            
            managerContext.delete(person)
            
            
            people.remove(at: indexPath.row)
            
            do {
                try managerContext.save()
            } catch let error {
                print("Could not save: \(error)")
            }
            
            
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
