//
//  SVCViewController.swift
//  Bus
//
//  Created by Yukie Hirano on 11/12/17.
//  Copyright © 2017 Sheetal Desai. All rights reserved.
//

import UIKit

class SVCViewController: UIViewController {

    var delay = 0
    var am = true
    
    var schedule = [[1,8.05,2.35,0],[2,8.20,2.50,0],[3,8.35,3.05,0],[4,8.50,3.15,0]]

    @IBOutlet weak var stable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        stable.dataSource = self
        stable.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SVCViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var delayHr = Double(delay)/Double(100)
        let cell = stable.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! sTableViewCell
        
        cell.lblroute.text = String("#\(Int(schedule[indexPath.row][0]))")
        
        cell.lblAm.text = String(schedule[indexPath.row][1])
        
        cell.lblPm.text = String(schedule[indexPath.row][2])
        print("SVC \(am) \(delay)")
        if (am){
            print("am is true")
            print(schedule[indexPath.row][1])
            print(schedule[indexPath.row][1] + Double(delay))
            cell.lblEta.text = String(schedule[indexPath.row][1])
            cell.lblEta.text = String(schedule[indexPath.row][1] + delayHr)
        }
        else {
            cell.lblEta.text = String(schedule[indexPath.row][2])
            cell.lblEta.text = String(schedule[indexPath.row][2] + delayHr)
        }
        
        return cell
    }
    
    
}





