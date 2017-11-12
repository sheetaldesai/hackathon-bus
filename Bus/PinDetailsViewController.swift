//
//  PinDetailsViewController.swift
//  Bus
//
//  Created by Sheetal Desai on 11/10/17.
//  Copyright © 2017 Sheetal Desai. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps

class PinDetailsViewController: UIViewController {

    var pins = [Pin]()
    var delegate:PinDelegate?
    
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var pinTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pinTable.dataSource = self
        pinTable.delegate = self
        // Do any additional setup after loading the view.
    }



}

extension PinDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cont \(pins.count)")
        return pins.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinTableCell", for: indexPath)
        
        cell.textLabel?.text = pins[indexPath.row].type
        cell.detailTextLabel?.text = "ABC"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("pindetails: remove pin")
        let pin = pins[indexPath.row]
        pins.remove(at: indexPath.row)
        delegate?.deletePin(pin: pin)
        tableView.reloadData()
    }

}
