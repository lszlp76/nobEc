//
//  Location.swift
//  travelguide
//
//  Created by ulas özalp on 25.06.2022.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class GetLocation {
    
    static let sharedInstance = GetLocation()
    
    var pharmacyLatitude = [Double]()
    var pharmacyLongitude = [Double]()
    var pharmacyName = [String]()
    var distance = [Double]()
    var location = CLLocationCoordinate2D()
    var eczaneStored = [EczaneVeri]()
    private init(){
        
    }
        
}
class MyAnnotation: NSObject,MKAnnotation {
    
var title : String?
var subTit : String?
var coordinate : CLLocationCoordinate2D

init(title:String,coordinate : CLLocationCoordinate2D,subtitle:String){

    self.title = title;
    self.coordinate = coordinate;
    self.subTit = subtitle;

}
    
    
}

