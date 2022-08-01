//
//  PharmacyFoundedData.swift
//  travelguide
//
//  Created by ulas özalp on 25.06.2022.
//

import Foundation
import MapKit
/**
  *A description field*
  - important: This is
    a way to get the
    readers attention for
    something.
 
  - returns: Nothing
 
  *Another description field*
  - version: 1.0
 */


struct PharmacyFoundedData {
    
    
        let pharmacyLatitude : Double
        let pharmacyLongitude : Double
        let pharmacyName : String
    let pharmacyCounty : String
    let pharmacyPhoneNumber : String?
    let pharmacyAddress : String?
    
}

struct EczaneVeri {
    /* parameter llamaCount: The number of llamas in the managed herd.
     */
    let pharmacyLatitude : Double
    let pharmacyLongitude : Double
    let pharmacyName : String
    var distance : Double?
    let travelTime :String?
    let pharmacyCounty : String
    let phoneNumber : String
    let pharmacyAddress : String?
}

struct PharmacyItem : Identifiable {
    var id = UUID().uuidString
    var mapItem: MKMapItem
    
}
