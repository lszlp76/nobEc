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
        super.viewDidLoad()
        eczaneStored.removeAll()
        eczaneStoredByCounty.removeAll()
        eczaneStoredFull.removeAll()
       
        if eczaneStoredFull.count != nil{
        eczaneStoredFull = (GetLocation.sharedInstance.eczaneStored).sorted(by: {$0.distance < $1.distance}) // en yakın 1nci sıraya yazdırma
        }
        if UserDefaults.standard.bool(forKey: "allPharmacyOption")  == true {
            
            eczaneStored = eczaneStoredFull
            
        }
        else {
            eczaneStoredFull = (GetLocation.sharedInstance.eczaneStored).sorted(by: {$0.distance < $1.distance}) // en yakın 1nci sıraya yazdırma
            print("eczaneStoredFull \(eczaneStoredFull)")
            print(eczaneStoredFull.count)
            for eczane in eczaneStoredFull {
               
                if (eczane.pharmacyCounty == GetLocation.sharedInstance.county) {
                    eczaneStoredByCounty.append(eczane)
                    eczaneStoredByCounty = eczaneStoredByCounty.sorted(by: {$0.distance < $1.distance}) // en yakın 1nci sıraya yazdırma
                    print(GetLocation.sharedInstance.county)
                 
                }
                
               eczaneStored = eczaneStoredByCounty 
            }
                
                
          
        }
        
        
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
        print("yeni eczane --> \(eczaneStoredByCounty)")
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        choosenTitle = eczaneStored[indexPath.row].pharmacyName
        choosenLatitude = eczaneStored[indexPath.row].pharmacyLatitude
        choosenLongitude = eczaneStored[indexPath.row].pharmacyLongitude
        choosenTravelTime = eczaneStored[indexPath.row].travelTime
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
            header.textLabel?.textColor = UIColor.blue
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            header.textLabel?.frame = header.bounds
            header.textLabel?.textAlignment = .center
     
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter : DateFormatter = DateFormatter()
        //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "dd-MMM-YY"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let headerTitles =  dateString + " NÖBETÇİ ECZANELER" 
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
        cell.distanceText.text = String(format: "%.1f",eczaneStored[indexPath.row].distance) + " km"
        cell.timeText.text = eczaneStored[indexPath.row].travelTime + " dak."
        cell.countyText.text = eczaneStored[indexPath.row].pharmacyCounty
        return cell
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
        }
    
