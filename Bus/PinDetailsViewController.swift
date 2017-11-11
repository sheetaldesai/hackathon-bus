//
//  PinDetailsViewController.swift
//  Bus
//
//  Created by Sheetal Desai on 11/10/17.
//  Copyright © 2017 Sheetal Desai. All rights reserved.
//

import UIKit
import CoreData

class PinDetailsViewController: UIViewController {

    var pins = [Pin]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var pinTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPins()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func fetchPins() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        do {
            let results = try (managedObjectContext.fetch(request))
            
            pins = results as! [Pin]
            print("Got results count \(results.count)")
        } catch {
            print("\(error)")
        }
        
    }
    

}

extension PinDetailsViewController: UITableViewDataSource, UITabBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pins.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinTableCell", for: indexPath)
        
        cell.textLabel?.text = pins[indexPath.row].type
        cell.detailTextLabel?.text = "ABC"
        print("type: \(pins[indexPath.row])")
        return cell
    }

}
