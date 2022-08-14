//
//  PharmacyView.swift
//  travelguide
//
//  Created by ulas özalp on 13.08.2022.
//

import Foundation
import MapKit

class PharmacyMarkerView: MKMarkerAnnotationView {
    
  override var annotation: MKAnnotation? {
    willSet {
      // 1
      guard let pharmacyMarker = newValue as? PharmacyNearByAnnotation else {
        return
      }
        
       canShowCallout = true
       
        //markerTintColor = pharmacyMarker.markerTintColor
        image = pharmacyMarker.image
        largeContentTitle = pharmacyMarker.title
        self.glyphText = ""
        self.glyphTintColor = UIColor.clear
        self.markerTintColor = UIColor.clear
        
        
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
          
          return resizeAnnotationImage(image: UIImage(named: "pharmacyRedLogo")!)//UIImage(named: "pharmacyRedLogo")!
          // 60 x 60 ideal ölçü resim boyunda MKAnnotationView kullanırsan.
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
    private func resizeAnnotationImage (image : UIImage) -> UIImage {
        
        // resimi assete kayıt ederken Orijinal olarak işaretle. yoksa görüntü alamazsın
        let size = CGSize(width: 70, height: 70)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        return resizedImage!

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
        
    }
  }
    
}
