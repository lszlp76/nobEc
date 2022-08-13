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

class MyLongGestureRecongnizer : UILongPressGestureRecognizer {
    var locationLatitude = CLLocationDegrees ()
    var locationLongitude = CLLocationDegrees ()
    var title = String()
}

class CarButton : UIButton {
     var location = CLLocation()
     var pinName = String()
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
