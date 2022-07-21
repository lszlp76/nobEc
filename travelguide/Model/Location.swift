//
//  Location.swift
//  travelguide
//
//  Created by ulas özalp on 25.06.2022.
//

import Foundation
import CoreLocation
import MapKit

class GetLocation  {
    
    static let sharedInstance = GetLocation()
    
    var pharmacyLatitude = [Double]()
    var pharmacyLongitude = [Double]()
    var pharmacyName = [String]()
    var distance = [Double]()
    var location = CLLocationCoordinate2D()
    var eczaneStored = [EczaneVeri]()
    var allPharmacy = Bool()
    var connectionGPSExist = Bool()
    var county = String()
    var pharmacyForOpening = [PharmacyFoundedData]()
    var travelTime = String()
    
    private  init(){
        
    }
   
}
class MyAnnotation: NSObject,MKAnnotation {
    
var title : String?
var subTit : String?
var coordinate : CLLocationCoordinate2D
    var travelTime : String?

    init(title:String,coordinate : CLLocationCoordinate2D,subtitle:String,travelTime:String){

    self.title = title;
    self.coordinate = coordinate;
    self.subTit = subtitle;
    self.travelTime? = travelTime

}
    
    
}

