//
//  FirstViewController.swift
//  travelguide
//
//  Created by ulas özalp on 18.06.2022.
//

import UIKit

import CoreLocation
import MapKit

class FirstViewController: UIViewController , UITableViewDelegate,
                           CLLocationManagerDelegate,UITableViewDataSource,MKMapViewDelegate, UIGestureRecognizerDelegate{
    /**
     --> Nöbetçi eczaneyi share etme olmalı, uzun basınca share etsin
     */
    
    
    
    
    let refreshControl = UIRefreshControl() // pulldown
    let getLocation = GetLocation.sharedInstance
    var choosenTitle = ""
    var choosenTitleID : UUID?
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    var choosenTravelTime = String()
    var choosehPhoneNumber = String()
    var eczaneStored = [EczaneVeri]() // tüm eczaneleri gösterir
    var eczaneStoredByCounty = [EczaneVeri]() // ilçeye göre süzülmüş hali
    var eczaneStoredFull = [EczaneVeri]() // URL'den gelen tam veri
    
    @IBOutlet weak var tableView: UITableView!
   
    
    override func viewWillAppear(_ animated: Bool) {
    
        eczaneStored.removeAll()
        eczaneStoredByCounty.removeAll()
        eczaneStoredFull.removeAll()
       
       
        if eczaneStoredFull.count != nil{
           
         
            eczaneStoredFull = (getLocation.eczaneStored).sorted(by:
                                                                    { Double($0.travelTime!)!  < Double($1.travelTime! )! }) // en yakın 1nci sıraya yazdırma
        }
//        if UserDefaults.standard.bool(forKey: "allPharmacyOption")  == true {
            
            eczaneStored = eczaneStoredFull
        
//        }
//        else {
//            eczaneStoredFull = (GetLocation.sharedInstance.eczaneStored).sorted(by: {$0.distance < $1.distance}) // en yakın 1nci sıraya yazdırma
//            print("eczaneStoredFull \(eczaneStoredFull)")
//            print(eczaneStoredFull.count)
//            for eczane in eczaneStoredFull {
//
//                if (eczane.pharmacyCounty == GetLocation.sharedInstance.county) {
//                    eczaneStoredByCounty.append(eczane)
//                    eczaneStoredByCounty = eczaneStoredByCounty.sorted(by: {$0.distance < $1.distance}) // en yakın 1nci sıraya yazdırma
//                    print(GetLocation.sharedInstance.county)
//
//                }
//
//               eczaneStored = eczaneStoredByCounty
//            }
//        }
        
        
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
       
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        choosenTitle = eczaneStored[indexPath.row].pharmacyName
        choosenLatitude = eczaneStored[indexPath.row].pharmacyLatitude
        choosenLongitude = eczaneStored[indexPath.row].pharmacyLongitude
        choosenTravelTime = eczaneStored[indexPath.row].travelTime ?? "0"
        choosehPhoneNumber = eczaneStored[indexPath.row].phoneNumber
        
        performSegue(withIdentifier: "toChoosenLocation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChoosenLocation" {
            let destinationVC = segue.destination as! ChoosenLocationViewViewController
            destinationVC.selectedTitle = choosenTitle
            destinationVC.annotationTitle = choosenTitle
            destinationVC.annotationLatitude = choosenLatitude
            destinationVC.annotationLongitude = choosenLongitude
            destinationVC.annotationTravelTime = choosenTravelTime
            destinationVC.annotationPhoneNumber = choosehPhoneNumber
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("eczaneStoredFull --> \(eczaneStoredFull.count)")
        print("eczaneStored --> \(eczaneStored.count)")
        print("eczaneStoredByCounty --> \(eczaneStoredByCounty.count)")
        
        
        return eczaneStored.count
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
            header.textLabel?.textColor = UIColor.init(named: "SpesificColor")
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            header.textLabel?.frame = header.bounds
            header.textLabel?.textAlignment = .left
     
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let headerTitles = " NÖBETÇİ ECZANELER"
    
        return headerTitles
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
       // let cell = UITableViewCell()
        //cell.textLabel?.text = eczaneStored[indexPath.row].pharmacyName + "   --->  " + String(eczaneStored[indexPath.row].distance)
        tableView.rowHeight = 100
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellModel
        cell.pharmacyNameText.text = eczaneStored[indexPath.row].pharmacyName
        cell.pharmacyNameText.font = UIFont.boldSystemFont(ofSize: 21.0)
        cell.phoneNumberText.text = eczaneStored[indexPath.row].phoneNumber
         cell.countyText.text = eczaneStored[indexPath.row].pharmacyCounty
        cell.timeText.text = eczaneStored[indexPath.row].travelTime! + " dak."
        cell.distanceText.text = String(format: "%.1f", eczaneStored[indexPath.row].distance as! CVarArg) + " km"
        cell.pharmacyNameText.textColor = UIColor.init(named: "ColorForListView")
        cell.phoneNumberText.textColor = UIColor.init(named: "ColorForListView")
        cell.distanceText.textColor = UIColor.init(named: "ColorForListView")
        cell.timeText.textColor = UIColor.init(named: "ColorForListView")
        cell.countyText.textColor = UIColor.init(named: "ColorForListView")
        
//        /**
//         distance yazdırma
//
//         */
//
//         findDistanceForPharmacyOnDuty(endLocation: CLLocationCoordinate2DMake(eczaneStored[indexPath.row].pharmacyLatitude, eczaneStored[indexPath.row].pharmacyLongitude)) { distance, travelTime in
//             cell.distanceText.text = String(format: "%.1f", distance!) + " km"
//             cell.timeText.text = travelTime! + " dak."
//
//
//            }
//
        
        return cell
                                                         }
    override func viewDidLoad() {
       
         
      
    
        let dateFormatter : DateFormatter = DateFormatter()
        //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "dd-MMM-YYYY"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        if let navigationBar = self.navigationController?.navigationBar {
            let firstFrame = CGRect(x:navigationBar.frame.width/2, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            
            let firstLabel = UILabel(frame: firstFrame)
            firstLabel.alignmentRect(forFrame: firstFrame)
            firstLabel.text = dateString
            firstLabel.textAlignment = .right
            //firstLabel.layer.borderWidth = 1.0
           // firstLabel.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 0, alpha: 1)

            firstLabel.font = UIFont(name: "Arial", size: 18)
            firstLabel.textColor =  UIColor.init(named: "SpesificColor")
            
            navigationBar.addSubview(firstLabel)
            
        
        }
    }
    @objc func longPress(_ longPressGestureRecognizer : UILongPressGestureRecognizer){
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            // Make the activityViewContoller which shows the share-view
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
           
            if let indexPath = tableView.indexPathForRow(at: touchPoint){
                let url = ("https://maps.apple.com/?daddr=\(eczaneStored[indexPath.row].pharmacyLatitude),\(eczaneStored[indexPath.row].pharmacyLongitude)")
                
                print("-->\(url)")
                // let url = "http://maps.apple.com/maps?saddr=\(from.latitude),\(from.longitude)&daddr=\(to.latitude),\(to.longitude)"
                
                let itemToSend = ["\(eczaneStored[indexPath.row].pharmacyName)", url] as [Any]
                
               
                let activityViewController = UIActivityViewController(activityItems: itemToSend ,applicationActivities: nil)
               
                /*
                 Share menu if user's Ipad is active
                 */
                if  ((activityViewController.popoverPresentationController) != nil){
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    activityViewController.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.midX, y: self.view.bounds.midY, width: 0,height: 0)
                }
                // Show the share-view
                self.present(activityViewController, animated: true, completion: nil)
            }
            }
       
    
            }
    
    func listRenew()-> [EczaneVeri] {
        
        
        let index : Int
        var dist : Double?
        var trav : String?
        var new = [EczaneVeri]()
        eczaneStored = getLocation.eczaneStored
        for index in 0...eczaneStored.count - 1
        {
            
            
            self.findDistanceForPharmacyOnDuty(endLocation: CLLocationCoordinate2DMake(eczaneStored[index].pharmacyLatitude, eczaneStored[index].pharmacyLongitude))
            { distance, travelTime in
                dist = distance
                trav = travelTime
            }
           
            
            let newEczaneStored = (EczaneVeri(pharmacyLatitude: eczaneStored[index].pharmacyLatitude, pharmacyLongitude: eczaneStored[index].pharmacyLongitude, pharmacyName: eczaneStored[index].pharmacyName, distance: dist, travelTime: trav, pharmacyCounty: eczaneStored[index].pharmacyCounty, phoneNumber: eczaneStored[index].phoneNumber, pharmacyAddress: eczaneStored[index].pharmacyAddress))
            new.append(newEczaneStored)
        }
       new = (new).sorted(by: {$0.distance ?? 0.0 < $1.distance ??  0.0})
       return new
        
    }
       
                        
   
    func   findDistanceForPharmacyOnDuty(endLocation : CLLocationCoordinate2D , completion : @escaping (_ distance: Double?,_ travelTime: String?) -> (Void)){
        
    let group = DispatchGroup()
        group.enter()
        print("location bilgisi \(getLocation.location)")
        
     
        var dist : Double? = 0.0
        var traTime : String? = "0"
          
            getDistance(sourceLocation: getLocation.location, endLocation: endLocation)
           
       
        { distance, travelTime, error  in
                
              
            guard let distance = distance else {
               return  print("nil geldi")
                
            }
            dist = (distance)
            traTime = (travelTime!)
            group.leave()
        }
        
        group.notify(queue: .main){
            
          completion(dist,traTime)
        }
       
          
        }

    func getDistance (sourceLocation : CLLocationCoordinate2D, endLocation : CLLocationCoordinate2D,  completion: @escaping (_ distance: Double?,_ travelTime : String?,_ error : Error?) -> (Void))
    {
  
        let request = MKDirections.Request()
        
        let source = MKPlacemark( coordinate: sourceLocation)//CLLocationCoordinate2D(latitude: 40.2145, longitude: 28.981821))
        // MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.2145, longitude: 28.981821))
        
        var msf : Double?
        var travelTime : String?
        
        let destination = MKPlacemark( coordinate: endLocation)
        
        request.source =  MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        //  print("request değerleri --> \(request.destination) \(destination.location?.coordinate)")
        request.transportType = MKDirectionsTransportType.automobile
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections ( request: request)
    
            directions.calculate { (response, error) in
                
                if let error = error {
                    
                    print("Distance directions error destination \n \(error.localizedDescription)")
                    return
                }
                if let route = response?.routes {
                    let sortedRoutes = route.sorted(by: { $0.distance < $1.distance}) // en küçüğe göre sort ediyor
                    let shortestRoute = sortedRoutes.first // sonra o dizinin ilk elemanını alıyor, böylece en kısa mesafeyi buluş oluyor
                    msf = shortestRoute!.distance/1000
                    travelTime = String(format: "%.0f",shortestRoute!.expectedTravelTime/60)
                    
                }
                completion  (msf,travelTime, error)
            
        }
    }
        }
    
