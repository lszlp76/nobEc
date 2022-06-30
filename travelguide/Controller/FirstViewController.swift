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
                           CLLocationManagerDelegate,UITableViewDataSource,MKMapViewDelegate{
    let refreshControl = UIRefreshControl() // pulldown
    
    var choosenTitle = ""
    var choosenTitleID : UUID?
    var choosenLatitude = Double()
    var choosenLongitude = Double()

    var eczaneStored = [EczaneVeri]()
    
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        eczaneStored = (GetLocation.sharedInstance.eczaneStored).sorted(by: {$0.distance < $1.distance}) // en yakın 1nci sıraya yazdırma
   
        print(eczaneStored)
        tableView.delegate = self
        tableView.dataSource = self
       print("ok")
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        choosenTitle = eczaneStored[indexPath.row].pharmacyName
        choosenLatitude = eczaneStored[indexPath.row].pharmacyLatitude
        choosenLongitude = eczaneStored[indexPath.row].pharmacyLongitude
        performSegue(withIdentifier: "toChoosenLocation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChoosenLocation" {
            let destinationVC = segue.destination as! ChoosenLocationViewViewController
            destinationVC.selectedTitle = choosenTitle
            destinationVC.annotationTitle = choosenTitle
            destinationVC.annotationLatitude = choosenLatitude
            destinationVC.annotationLongitude = choosenLongitude
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eczaneStored.count
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       // let cell = UITableViewCell()
        //cell.textLabel?.text = eczaneStored[indexPath.row].pharmacyName + "   --->  " + String(eczaneStored[indexPath.row].distance)
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellModel
        cell.pharmacyNameText.text = eczaneStored[indexPath.row].pharmacyName
        cell.distanceText.text = String(eczaneStored[indexPath.row].distance) + " km"
        cell.timeText.text = eczaneStored[indexPath.row].travelTime + " dak."
        cell.textLabel?.text = eczaneStored[indexPath.row].pharmacyCounty
        return cell
    }
    
    
    
}

