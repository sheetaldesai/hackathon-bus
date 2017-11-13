//
//  MapViewController.swift
//  Bus
//
//  Created by Sheetal Desai on 11/9/17.
//  Copyright © 2017 Sheetal Desai. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreData
import Alamofire
import SwiftyJSON

struct Location  {
    var lat: Double
    var long: Double
}


var titles = ["TrafficJam":"Traffic Jam", "OutOfService":"Out of Service", "SubDriver":"Sub Driver"]
var colors = ["TrafficJam":UIColor.blue, "OutOfService":UIColor.red, "SubDriver":UIColor.green]
var pins = [Pin]()
var delayMarkers = [Pin:GMSMarker]()

var stops = [[37.297643,-122.006752],[37.300775,-122.019745],[37.303494, -122.022544],[37.308968, -122.009182],[37.299199, -122.014922]]



class MapViewController: UIViewController,CLLocationManagerDelegate {
  
    
    @IBOutlet weak var trafficClick: UIButton!
    @IBOutlet weak var oosClick: UIButton!
    @IBOutlet weak var subdriverClick: UIButton!
    
    @IBOutlet weak var delay15: UIButton!
    @IBOutlet weak var delay30: UIButton!
    @IBOutlet weak var delay45: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLoc:Location = Location(lat:0, long:0)
    let COORDINATE_OFFSET:Double = 1;
    
    var myRoute:Int32 = 1
    var isParent = false
    
    var mydelay = 0
    var myam:Bool = true
    
    @IBOutlet var delayButtons: [UIButton]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.addSubview(mapView!)
    
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        // Create bus route
        drawBusRoute()
        
        // Create markers for all existing pins in DB
        showPins()
        
        // Make delay buttons invisible if isParent is true.
        for button in delayButtons {
            if (isParent) {
                button.isHidden = true
            }
            else {
                button.isHidden = false
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PinDetails") {
            let pinDetailsController = segue.destination as! PinDetailsViewController
            pinDetailsController.pins = pins
            pinDetailsController.delegate = self
        }
        if (segue.identifier == "scheduleSegue") {
            let scheduleVC = segue.destination as! SVCViewController
            scheduleVC.am = myam
            print(myam)
            print(mydelay)
            scheduleVC.delay = mydelay
        }
    }
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: Double, longitude: Double)->GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = mapView
        print("created marker")
        return marker
    }
    
    
    
    //Mark: - This function gets bust stop data and draws a bus route and also adds markers at each stop.
    func drawBusRoute() {
        var origin = Location(lat:0,long:0)
        var dest = Location(lat:0,long:0)
        for i in 0...stops.count-1 {
            print("i: \(i)")
            if (i==0) {
                createMarker(titleMarker: "Stop#\(i)", iconMarker: UIImage(named: "school")!, latitude: stops[i][0], longitude: stops[i][1])
            }
            else {
                createMarker(titleMarker: "Stop#\(i)", iconMarker: UIImage(named: "bus-stop")!, latitude: stops[i][0], longitude: stops[i][1])
            }
            
            if (i != (stops.count - 1)) {
                print("\(i) \(stops[i])")
                origin = Location(lat:stops[i][0], long:stops[i][1])
                dest = Location(lat:stops[i+1][0], long:stops[i+1][1])
                drawPath(startLocation: origin, endLocation: dest)
            }
            
        }
    }
    
    
    //MARK: - this is function for create direction path, from start location to desination location
    func drawPath(startLocation: Location, endLocation: Location)
    {
        let origin = "\(startLocation.lat),\(startLocation.long)"
        let destination = "\(endLocation.lat),\(endLocation.long)"
        var routes = [JSON]()
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            do {
                let json = try JSON(data: response.data!)
                routes = json["routes"].arrayValue
            } catch {
                print("Error getting json data")
            }
            
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.mapView
            }
            
        }
    }
    
    //MARK: This functions gets all pins from database and creates marker for each pin.
    func showPins() {
        //  Get pins from database
        if let p = Data.fetchPins() {
            pins = p
        }
        
        print("Pins count: \(pins.count)")
        for pin in pins {
            print("PIN lat: \(pin.lattitude) long: \(pin.longitude) Type: \(pin.type)")
            
            createMarker(titleMarker: "\(titles[pin.type!]!) \(time)", iconMarker: GMSMarker.markerImage(with: colors[pin.type!]!), latitude: pin.lattitude, longitude: pin.longitude)
        }
    }
    
    //MARK: traffic buttons IBAction.
    @IBAction func trafficButtonPressed(_ sender: UIButton){
        print("traffic")
        var type:String = String()
        var lat:Double = Double()
        var long:Double = Double()

        
        if sender.tag == 0 {
            type = "TrafficJam"
            lat = currentLoc.lat
            long = currentLoc.long
            trafficClick.backgroundColor = UIColor.lightGray
        }
        else if sender.tag == 1 {
            type = "OutOfService"
            lat = 37.300775 + 0.0006
            long = -122.019745 + 0.0006
            oosClick.backgroundColor = UIColor.lightGray
        }
        else if sender.tag == 2 {
            type="SubDriver"
            lat = 37.303494 - 0.0003
            long = -122.022544 - 0.0003
            subdriverClick.backgroundColor = UIColor.lightGray
        }
        
        var tm = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        //dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: tm)
        print("\(dateString)")
        let marker = createMarker(titleMarker: "\(titles[type]!) \(dateString)", iconMarker: GMSMarker.markerImage(with: colors[type]!), latitude: lat, longitude: long)
        
        
        if let pin = Data.addPinToDB(type: type, route: myRoute, lat: lat, long: long, time: tm) {
            pins.append(pin)
            delayMarkers[pin] = marker
            print("added marker :\(delayMarkers)")
        }
    }
    
    
    @IBAction func delayButtonPressed(_ sender: UIButton) {
        if sender.tag == 15 {
            delay15.backgroundColor = UIColor.lightGray
        }
        if sender.tag == 30 {
            delay30.backgroundColor = UIColor.lightGray
        }
        if sender.tag == 45 {
            delay45.backgroundColor = UIColor.lightGray
        }
        mydelay = sender.tag
        print("delay: \(mydelay)")
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        print(hour)
        if (hour < 14)
        {
            myam = true
        }
        else {
            myam = false
        }
       
        print("delaybuttonPressed \(myam)")
        print("delayButtonPressed \(mydelay)")
        
       
    }
}

//MARK: PinDelegate:deletePin.
extension MapViewController:PinDelegate {
    func deletePin(pin: Pin) {
        let marker = delayMarkers[pin]
        print(delayMarkers)
        marker?.map = nil
        if (Data.deletePin(pin: pin)) {
            print("mapview deletePin")
            delayMarkers.removeValue(forKey: pin)
            let index = pins.index(of: pin)
            pins.remove(at: index!)
        }
        
    }
}

