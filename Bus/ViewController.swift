//
//  ViewController.swift
//  Bus
//
//  Created by Sheetal Desai on 11/9/17.
//  Copyright © 2017 Sheetal Desai. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreData

struct Location  {
    var lat: Double
    var long: Double
}

var titles = ["TrafficJam":"Traffic Jam", "OutOfService":"Out of Service", "SubDriver":"Sub Driver"]
var colors = ["TrafficJam":UIColor.blue, "OutOfService":UIColor.red, "SubDriver":UIColor.green]


class ViewController: UIViewController,CLLocationManagerDelegate {
  
//animation==Hello
    
    
    
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLoc:Location = Location(lat:0, long:0)
    let COORDINATE_OFFSET:Double = 1;
    var pins = [Pin]()
    var myRoute:Int32 = 1
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(mapView!)

        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        fetchPins()
        print("Pins count: \(pins.count)")
        for pin in pins {
            print("PIN lat: \(pin.lattitude) long: \(pin.longitude) Type: \(pin.type)")
//            let dateFormatterPrint = DateFormatter()
//            dateFormatterPrint.dateFormat = "yyyy-MM-DD hh:mm:ss"
//
//            let time = dateFormatterPrint.string(from: pin.time!)
//            print("time: \(time)")
            createMarker(titleMarker: "\(titles[pin.type!]!) \(time)", iconMarker: GMSMarker.markerImage(with: colors[pin.type!]!), latitude: pin.lattitude, longitude: pin.longitude)
        }
        
        
    }

    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        currentLoc.lat = (location?.coordinate.latitude)!
        currentLoc.long = (location?.coordinate.longitude)!
        print("Camera Lat: \(currentLoc.lat) Camera Long: \(currentLoc.long)")
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        
        mapView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: Double, longitude: Double) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = mapView
        print("created marker")
    }
    
    func addPinToDB(type:String, route:Int32, lat:Double, long:Double, time:Date) {
        let pin = NSEntityDescription.insertNewObject(forEntityName: "Pin", into: managedObjectContext) as! Pin
        pin.lattitude = lat
        pin.longitude = long
        pin.route = myRoute
        pin.type = type
        pin.time = time
        pins.append(pin)
        do {
            try managedObjectContext.save()
            print("added pin to db")
        } catch {
            print("\(error)")
        }

    }
    
    func fetchPins() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        do {
            let results = try (managedObjectContext.fetch(request))
            print("Got results")
            pins = results as! [Pin]
        } catch {
            print("\(error)")
        }

    }
    
    @IBAction func trafficButtonPressed(_ sender: UIButton){
        print("traffic")
        
        var type:String = String()
        var lat:Double = Double()
        var long:Double = Double()

        
        if sender.tag == 0 {
            type = "TrafficJam"
            lat = currentLoc.lat
            long = currentLoc.long
        }
        else if sender.tag == 1 {
            type = "OutOfService"
            lat = currentLoc.lat + 0.0006
            long = currentLoc.long + 0.0006
        }
        else if sender.tag == 2 {
            type="SubDriver"
            lat = currentLoc.lat - 0.0003
            long = currentLoc.long - 0.0003
        }
//        print(time)
        createMarker(titleMarker: "\(titles[type]!) \(time)", iconMarker: GMSMarker.markerImage(with: colors[type]!), latitude: lat, longitude: long)
        addPinToDB(type: type, route: myRoute, lat: lat, long: long, time: Date())
        
    }
    
    
}

