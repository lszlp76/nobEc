//
//  PharmacyView.swift
//  travelguide
//
//  Created by ulas özalp on 13.08.2022.
//

import Foundation
import MapKit

class PharmacyMarkerView: MKMarkerAnnotationView {
    var dene : String?
  override var annotation: MKAnnotation? {
    willSet {
      // 1
      guard let pharmacyMarker = newValue as? PharmacyNearByAnnotation else {
        return
      }
       canShowCallout = true
     
        markerTintColor = pharmacyMarker.markerTintColor
        
       
        if let letter = pharmacyMarker.title?.first {
        glyphText = String(letter)
        }
    }
  }
    
}
class PharmacyNearByAnnotation: NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var travelTime: String?
    var distance: Double?
    var subtitle : String?
    var isOnDuty : Bool?
    
    var markerTintColor: UIColor  {
      switch isOnDuty {
      case true:
        return .red
      case false :
          return .green
      default:
        return .green
      }
    }
    var image: UIImage {

      switch isOnDuty {
      case true :
          
          return UIImage(named: "pharmacyRedLogo")!
          // 60 x 60 ideal ölçü resim boyunda
      case false :
        return UIImage(named: "pharmacyBlueLogo")!
      default:
          return #imageLiteral(resourceName : "pharmacy")
      }
      
    }
    init(title: String?,subtitle: String?, travelTime: String?, distance:Double?,coordinate:CLLocationCoordinate2D,isOnDuty : Bool?) {
        self.coordinate = coordinate
        self.title = title
        self.travelTime = travelTime
        self.distance = distance
        self.subtitle = subtitle
        self.isOnDuty = isOnDuty
        
        super.init()
        
        
    }

}
class PharmacyView: MKAnnotationView {
    
  override var annotation: MKAnnotation? {
      
    willSet {
      guard let pharmacy = newValue as? PharmacyNearByAnnotation else {
        return
      }
        
        canShowCallout = true
        tintColor = pharmacy.markerTintColor
        image = pharmacy.image
        largeContentTitle = "ulas"
    }
  }
    
}
