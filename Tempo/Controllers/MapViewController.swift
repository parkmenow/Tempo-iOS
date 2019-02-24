//
//  MapViewController.swift
//  Tempo
//
//  Created by bharath on 2019/02/22.
//  Copyright © 2019 shitian.ni. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON


class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var ActivityIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    var destinationCoordinate: GMSMarker!
    var mapView: GMSMapView!
    var riderID = 0
    var taxiRouteLines = [GMSPolyline]()
    var taxiID = 0
    var selectedRouteID = 0
    var fare = 0
    var confirmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        
        locationManagerInit()
        getNearbyTaxis()
        setNavbar()
        
    }
    
    func setNavbar(){
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutUser))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        self.navigationItem.title = globalData.user.Name
    }
    
    
    func locationManagerInit(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        
        
    }
    
    
    func getNearbyTaxis(){
        let currentLoc = getUserLocation()
        let url = "https://tempobackend.herokuapp.com/api/v1/nearbytaxis?latitude=\(currentLoc.latitude)&longitude=\(currentLoc.longitude)"
        get(url: url, successHandler: getNearbyTaxisHandler)
    }
    
    func getNearbyTaxisHandler (_ response: String) -> Void{
        let data = response.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                for json in jsonArray{
                    let marker = GMSMarker()
                    print("latitude:",json["latitude"]!)
                    let latitude = CLLocationDegrees((json["latitude"] as! NSString).floatValue)
                    let longitude = CLLocationDegrees((json["longitude"] as! NSString).floatValue)
                    marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    marker.title = "taxi location"
                    marker.map = mapView
                    marker.icon = UIImage(named: "taxi")!.withRenderingMode(.alwaysTemplate)
                    marker.tracksViewChanges = true
                    print("Added taxi")
                }
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getRoute(){
        let currentLoc = getUserLocation()
        let url = "https://tempobackend.herokuapp.com/api/v1/getRoute?src=\(currentLoc.latitude),\(currentLoc.longitude)&dest=\(destinationCoordinate.position.latitude),\(destinationCoordinate.position.longitude)"
        print("url:",url)
        return get(url: url, successHandler: getRouteResponseHandler)
    }
    
    func confirmRoute(distance: Int, duration: Int, fare: Int) {
        OperationQueue.main.addOperation({
            self.confirmButton.removeFromSuperview()
            self.confirmButton = UIButton()
            self.confirmButton.backgroundColor = UIColor.white
            self.confirmButton.setTitle("distance: \(distance)\n duration: \(duration)\n fare: \(fare)\n\n Tap to confirm route", for: [])
            self.confirmButton.titleLabel!.lineBreakMode = .byWordWrapping
            // you probably want to center it
            self.confirmButton.titleLabel!.textAlignment = .center
            
            self.confirmButton.setTitleColor(UIColor.blue, for: [])
            //        let buttonCoordinate = CGRect(x: 10, y: 10, width: 300, height: 300)
            self.confirmButton.frame = CGRect(x: self.view.frame.width/2-150, y: self.view.frame.height-150, width: 300, height: 150)
            self.confirmButton.addTarget(self, action: #selector(MapViewController.confirmRoutePressed(_:)), for: .touchUpInside)
            
            self.view.addSubview(self.confirmButton)
        })
    }
    
    @objc func confirmRoutePressed(_ sender: UIButton!){
        let alertController = UIAlertController(title: "Confirm", message: "Do you want to take this route", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            let rideResponse = self.getRide()
            print(rideResponse)
            self.confirmButton.removeFromSuperview()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            self.confirmButton.removeFromSuperview()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

//MARK:- Get Taxi
    func getRide(){
        let url = "https://tempobackend.herokuapp.com/api/v1/ride?routeid=\(self.selectedRouteID)"
        print("url:",url)
        return get(url: url, successHandler: getRideResponseHandler)
    }
    
    func getRideResponseHandler (_ response: String) -> Void{
        let data = response.data(using: .utf8)!
        do {
            if let taxiDict = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
            {
                self.confirmTaxi(taxi: taxiDict)
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
    }

    func confirmTaxi(taxi: Dictionary<String,Any>) {
        OperationQueue.main.addOperation({
            self.confirmButton.removeFromSuperview()
            self.confirmButton = UIButton()
            self.confirmButton.backgroundColor = UIColor.white
            
            var s: String = ""
            
            for (key,value) in taxi {
                print("\(key) : \(value)")
                s.append(contentsOf: "\(key) : \(value)\n")
            }
            
            self.confirmButton.setTitle("taxi info:\n\(s) \n\n Tap to confirm taxi", for: [])
            self.taxiID = taxi["ID"] as! Int
            self.confirmButton.titleLabel!.lineBreakMode = .byWordWrapping
            // you probably want to center it
            self.confirmButton.titleLabel!.textAlignment = .center
            self.confirmButton.setTitleColor(UIColor.blue, for: [])
            self.confirmButton.frame = CGRect(x: self.view.frame.width/2-150, y: self.view.frame.height-300, width: 300, height: 300)
            self.confirmButton.addTarget(self, action: #selector(MapViewController.confirmTaxiPressed(_:)), for: .touchUpInside)
            self.view.addSubview(self.confirmButton)
        })
    }
    
    @objc func confirmTaxiPressed(_ sender: UIButton!){
        let alertController = UIAlertController(title: "Confirm", message: "Do you want to take this taxi", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            let bookResponse = self.book()
            print(bookResponse)
            self.confirmButton.removeFromSuperview()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            self.confirmButton.removeFromSuperview()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    func book(){
        let url = "https://tempobackend.herokuapp.com/api/v1/bookingConfirmation/?riderid=\(riderID)&routeid=\(selectedRouteID)&taxiid=\(self.taxiID)"
        post(url: url, params: "", successHandler: bookingHandler)
    }
    
    func bookingHandler (_ response: String) -> Void{
        print("postTestHandler: ",response)
        
        DispatchQueue.main.async {
            //CALL next payment view controller
            
            let booki = parseBooking(json: response.data(using: .utf8)!)
            print("Parsed json as : ")
            print(booki)
            
            let fareyen : Float = Float(self.fare) * 110.71
            
            self.callPaymentViewController(user: String(self.riderID), route: String(self.selectedRouteID), price: fareyen, taxiID: String(self.taxiID),with: booki )
        }
    }
//MARK:- Call to Payment View Controller
    func callPaymentViewController(user: String, route : String , price : Float, taxiID taxi: String, with booking: Booking ){

        let vc = PaymentViewController(nibName: "PaymentViewController", bundle: nil)
        vc.user = user
        vc.taxi = taxi
        vc.cost = String(price)
        vc.booking = booking
        vc.fare = price
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let time = String(hour) + ":" + String(minutes)
        vc.bookTime = time
//            self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func getRouteResponseHandler (_ response_: String) -> Void{
        let response = "[" + response_ + "]"
        let data = response.data(using: .utf8)!
        do {
            if let jsons = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                var distance = 0
                var duration = 0
                
                for json in jsons{
                    let googlePaths = json["GooglePath"] as! NSArray
                    for googlePath in googlePaths{
                        let googlePathDict = googlePath as! Dictionary<String,Any>
                        let route = googlePathDict["Path"]
                        self.selectedRouteID = googlePathDict["RouteID"] as! Int
                        plotRoute(route: route as! String)
                    }
                    distance = json["Distance"] as! Int
                    duration = json["Duration"] as! Int
                    fare = json["Fare"] as! Int
                }
                self.confirmRoute(distance: distance, duration: duration, fare: fare)
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
    }

    func plotRoute(route: String){
        OperationQueue.main.addOperation({
            let points = route
            let path = GMSPath.init(fromEncodedPath: points )
            let taxiRouteLine = GMSPolyline.init(path: path)
            taxiRouteLine.strokeWidth = 3
            taxiRouteLine.map = self.mapView
            self.taxiRouteLines.append(taxiRouteLine)
        })
    }

    func getTestHandler (_ response: String) -> Void{
        print(response)
        DispatchQueue.main.async {
            let textView = UITextView(frame: CGRect(x: 120.0, y: 190.0, width: 350.0, height: 300.0))
            textView.textAlignment = NSTextAlignment.center
            textView.textColor = UIColor.black
            textView.backgroundColor = UIColor.white
            textView.text = response
            self.view.addSubview(textView)
        }
    }
    
    func reloadUserAndNearbyTaxi(){
        loadUserLocation()
        getNearbyTaxis()
    }
    
    func postTestHandler (_ response: String) -> Void{
        print("postTestHandler: ",response)
        DispatchQueue.main.async {
            let textView = UITextView(frame: CGRect(x: 120.0, y: 190.0, width: 350.0, height: 300.0))
            textView.textAlignment = NSTextAlignment.center
            textView.textColor = UIColor.black
            textView.backgroundColor = UIColor.white
            textView.text = response
            self.view.addSubview(textView)
        }
    }
    
    func getUserLocation() -> CLLocationCoordinate2D{
        if locationManager.location != nil{
            return locationManager.location!.coordinate
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    func get(url : String, successHandler: @escaping (_ response: String) -> Void) {
        let url = NSURL(string: url)
        let request = NSMutableURLRequest(url: url! as URL);
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            //in case of error
            if error != nil {
                return
            }
            let responseString : String = String(data: data!, encoding: String.Encoding.utf8)!
            successHandler(responseString)
        }
        task.resume();
    }
    
    func post(url : String, params : String, successHandler: @escaping (_ response: String) -> Void) {
        let url = NSURL(string: url)
        let params = String(params);
        let request = NSMutableURLRequest(url: url! as URL);
        request.httpMethod = "POST"
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            //in case of error
            if error != nil {
                return
            }
            let responseString : String = String(data: data!, encoding: String.Encoding.utf8)!
            successHandler(responseString)
        }
        task.resume();
    }

    func loadUserLocation(){
        let currentLoc = getUserLocation()
        let camera = GMSCameraPosition.camera(withLatitude: currentLoc.latitude, longitude: currentLoc.longitude, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.delegate = self as GMSMapViewDelegate
        self.view = mapView
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        let user = UIImage(named: "user")!.withRenderingMode(.alwaysTemplate)
        marker.tracksViewChanges = true
        marker.icon = user
        marker.position = CLLocationCoordinate2D(latitude: currentLoc.latitude, longitude: currentLoc.longitude)
        marker.title = "Your location"
        marker.map = mapView
    }
    
    override func loadView() {
        loadUserLocation()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if destinationCoordinate == nil {
            print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
            let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            destinationCoordinate = GMSMarker(position: position)
            destinationCoordinate.title = "Destination"
            destinationCoordinate.map = mapView
        } else {
            destinationCoordinate.map = nil
            destinationCoordinate = nil
            
            for routeLine in self.taxiRouteLines{
                routeLine.map = nil
            }
            self.taxiRouteLines.removeAll()
            
            if self.confirmButton != nil{
                self.confirmButton.removeFromSuperview()
            }
            self.confirmButton = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker tapped")
        confirmButton = UIButton()
        confirmButton.backgroundColor = UIColor.white
        confirmButton.setTitle("Tap to confirm destination", for: [])
        confirmButton.setTitleColor(UIColor.blue, for: [])
        //        let buttonCoordinate = CGRect(x: 10, y: 10, width: 300, height: 300)
        confirmButton.frame = CGRect(x: self.view.frame.width/2-150, y: self.view.frame.height-100, width: 300, height: 100)
        confirmButton.addTarget(self, action: #selector(MapViewController.destinationCheckButtonPressed(_:)), for: .touchUpInside)
        
        self.view.addSubview(confirmButton)
        return false
    }
    
    @objc func destinationCheckButtonPressed(_ sender: UIButton!) {
        let alertController = UIAlertController(title: "Confirm", message: "Do you want to set this point as destination", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            let routeResponse = self.getRoute()
            print(routeResponse)
            //            self.confirmButton.removeFromSuperview()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            self.confirmButton.removeFromSuperview()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @objc func logoutUser(){
        print("Logout clicked")
        globalData.authToken = ""
        globalData.user = UserDashboard()
        self.navigationController?.viewControllers.removeLast(1)
    }
}

