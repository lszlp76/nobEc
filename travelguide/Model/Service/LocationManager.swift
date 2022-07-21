//
//  LocationManager.swift
//  travelguide
//
//  Created by ulas özalp on 5.07.2022.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager : NSObject , CLLocationManagerDelegate {
    
    static let shared = LocationManager ()
    let locationManager = CLLocationManager()
    var completion: ((CLLocation)-> Void)?
    var pharmacyFinderManager = PharmacyFinder()
 
    
    public func getUserLocation (completion: @escaping ((CLLocation)-> Void)){
    
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
       
        locationManager.startUpdatingLocation()
       
        
        
    }
    
   public func resolveLocationName(with location : CLLocation,
                                   completion:  @escaping ((String,String) -> Void))   {
                let geoCoder = CLGeocoder()
                                                    geoCoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
                                                        
                                                        guard let place = placemarks?.first , error == nil else { return}
                                                        
                                                        var  city = ""
                                                        var  county = ""
                                                        if let sehir = place.administrativeArea {
                                                            city = sehir
                                                        }
                                                        if let ilce = place.subAdministrativeArea {
                                                            county = ilce
                                                        }
                                                        
                                                        completion(city,county)
                                                        GetLocation.sharedInstance.connectionGPSExist = true
                                                        
                                                      self.pharmacyFinderManager.fetchPharmacy(cityName: city, countyName: county)
                                                    }
      
    }
/**
 bulunduğun noktanın yakınlarında eczane arar
 */
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        
        guard let location = locations.first else { return }
        
        completion?(location)
        
       manager.stopUpdatingLocation()
        
    }
    
   
}
