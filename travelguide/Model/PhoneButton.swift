//
//  PhoneButton.swift
//  travelguide
//
//  Created by ulas özalp on 3.07.2022.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
class PhoneCallButton : UIButton {
    var phoneNumber = String()
    
}

class CarButton : UIButton {
     var location = CLLocation()
     var pinName = String()
}

class PharmacyNearByAnnotation: NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var travelTime: String?
    var distance: Double?
    var subtitle : String?
    
    init(title: String?,subtitle: String?, travelTime: String?, distance:Double?,coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = title
        self.travelTime = travelTime
        self.distance = distance
        self.subtitle = subtitle
        
        super.init()
    }
     
}

class AnnoDeneme : MKPointAnnotation {
  
    internal init(coordinate: CLLocationCoordinate2D, image: UIImage? = nil) {
        
        self.image = image
    }
    
      var image : UIImage?
}


/*
extension MKAnnotation {
    
    func SetTravelTime(travelTime :String, keyValue : String , array: [String : String]){
        var travelTime = travelTime
        var keyValue = self.title
        var array = array
        array[keyValue!!] = travelTime
        print("ass \(array)")
       
    }
    /**
     parameter : keyValue --> annotation.title olmalı
       array [string: string] dizi olmalı
     */
    func GetTravelTime(keyValue : String?, array: [String : String]) -> String? {
        var keyValue = keyValue
        var travelTime = array[keyValue!]
        
        return travelTime
    }
}
*/
