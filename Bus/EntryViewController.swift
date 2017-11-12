//
//  EntryViewController.swift
//  Bus
//
//  Created by Sheetal Desai on 11/10/17.
//  Copyright © 2017 Sheetal Desai. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {
    
    @IBOutlet weak var tableRoute: UITableView!

//animmation=======title
    @IBOutlet weak var eLabel: UILabel!
    @IBOutlet weak var oLabel: UILabel!
    
    
    @IBOutlet weak var drib: UIImageView!
    @IBOutlet weak var b: UIImageView!
    @IBOutlet weak var ble: UIImageView!
    
    //tablecell routeoption:
    let route = ["Route A", "Route B", "Route C", "Route D"]
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drib.image = #imageLiteral(resourceName: "plot")
        b.image = #imageLiteral(resourceName: "simage")
        ble.image = #imageLiteral(resourceName: "tots")
     
        
        winkHello()
        
//animation=======================
//        snowDribbbleBalls(image: #imageLiteral(resourceName: "whitebus"))
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


//====animation for title============
    
    func setStartPositions() {
        let xOffset = b.frame.width/2
        drib.transform = CGAffineTransform(translationX: xOffset, y:0)
        let y = -(b.frame.origin.y + b.frame.height + 50)
        b.transform = CGAffineTransform(translationX: 0, y:y).scaledBy(x:0.7, y:2)
        ble.transform = CGAffineTransform(translationX: -xOffset-7, y:0)
    }

    func separateWords() {
        UIView.animate(withDuration: 0.4, delay: 2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.drib.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
            self.ble.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        }) { (success) in
            self.showB()
        }
    }

    func showB() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: -10, options: [.curveEaseOut], animations: {
            self.b.transform = .identity
        }) { (success) in
            self.connectWord()
        }
    }

    func connectWord() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: -10, options: [], animations: {
            self.drib.transform = .identity
            self.ble.transform = .identity
        }) { (success) in
            self.winkHello()
        }
    }
    
    func winkHello(){
        UIView.animate(withDuration: 0.9, animations: {
            self.eLabel.transform = CGAffineTransform(scaleX: 1,y: 0.2)
            self.oLabel.transform = CGAffineTransform(scaleX: 1,y: 0.2)
        }) { (success) in
            UIView.animate(withDuration: 0.9, animations: {
                self.eLabel.transform = .identity
                self.oLabel.transform = .identity
            }) { (success) in

            }
        }
    }

    
}

extension EntryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return an integer that indicates how many rows (cells) to draw
        return route.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath)
        
        cell.textLabel?.text = self.route[indexPath.row]
        return cell
    }
    
    
    
}

