//
//  ScheduleViewController.swift
//  Alamofire
//
//  Created by Sheetal Desai on 11/12/17.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    var delay = 0
    var am = true
    

    @IBOutlet weak var scheduleTable: UITableView!
    
    var schedule = [[1,8.05,2.35,0],[2,8.20,2.50,0],[3,8.35,3.05,0],[4,8.50,3.15,0]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTable.dataSource = self
        scheduleTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ScheduleViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduleTable.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleCell
        cell.lblRoute.text = String("#\(Int(schedule[indexPath.row][0]))")
        cell.lblAM.text = String(schedule[indexPath.row][1])
        cell.lblPM.text = String(schedule[indexPath.row][2])
        if am {
            cell.lblETA.text = String(schedule[indexPath.row][1])
            cell.lblETA.text = String(schedule[indexPath.row][1] + Double(delay))
        }
        else {
            cell.lblETA.text = String(schedule[indexPath.row][2])
            cell.lblETA.text = String(schedule[indexPath.row][2] + Double(delay))
        }
        
        return cell
    }
    
    
}

