//
//  Data.swift
//  Bus
//
//  Created by Sheetal Desai on 11/11/17.
//  Copyright © 2017 Sheetal Desai. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Data {
    static let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    class func fetchPins() ->[Pin]? {
        var pins:[Pin]?
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        do {
            let results = try (managedObjectContext.fetch(request))
            print("Got results")
            pins = results as! [Pin]
        } catch {
            print("\(error)")
        }
        return pins
    }
    
    static func addPinToDB(type:String, route:Int32, lat:Double, long:Double, time:Date) -> Pin? {
        
        let pin = NSEntityDescription.insertNewObject(forEntityName: "Pin", into: managedObjectContext) as! Pin
        
        pin.lattitude = lat
        pin.longitude = long
        pin.route = 1
        pin.type = type
        pin.time = time
        do {
            try managedObjectContext.save()
            print("added pin to db")
            return pin
        } catch {
            print("\(error)")
            return nil
        }
    }
    
    static func deletePin(pin:Pin) -> Bool {
        print("Data: deletePin")
        managedObjectContext.delete(pin)
        do {
            try managedObjectContext.save()
            print("Successfully deleted pin")
            return true
        } catch {
            print("\(error)")
            return false
        }
    }
}

