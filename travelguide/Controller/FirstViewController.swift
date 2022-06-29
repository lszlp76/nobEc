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
    var values = [Double]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        eczaneStored = GetLocation.sharedInstance.eczaneStored
        
        tableView.delegate = self
        tableView.dataSource = self
       
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        choosenTitle = eczaneStored[indexPath.row].pharmacyName
        choosenLatitude = eczaneStored[indexPath.row].pharmacyLatitude
        choosenLongitude = eczaneStored[indexPath.row].pharmacyLongitude
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedTitle = choosenTitle
            destinationVC.annotationTitle = choosenTitle
            destinationVC.annotationLatitude = choosenLatitude
            destinationVC.annotationLongitude = choosenLongitude
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eczaneStored.count//pharmacyOnDutyName.count
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell()
       
        cell.textLabel?.text = eczaneStored[indexPath.row].pharmacyName + "   --->  " + String(eczaneStored[indexPath.row].distance)
       
        return cell
    }
    
    
    
}

