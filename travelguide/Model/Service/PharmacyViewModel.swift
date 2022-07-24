//
//  PharmacyViewModel.swift
//  travelguide
//
//  Created by ulas özalp on 21.07.2022.
//

import Foundation


struct PharmacyListViewModel {
    
    let pharmacy : ResponseJson
    
    var data : [ResponseJson.ResponseJsonData]{
        pharmacy.data
    }
    func numberOfDutyPharmacies () -> Int {
        return data.count
    }
    func pharmacyAtIndex(_ index: Int) -> PharymacyViewModel {
        
        let pharmacy = data[index]
        return PharymacyViewModel.init(pharmacyOnDuty: pharmacy)
    }
}


struct PharymacyViewModel {
    let pharmacyOnDuty : ResponseJson.ResponseJsonData?
   
   
    var pharmacyName : String {
        return (self.pharmacyOnDuty?.EczaneAdi)!
    }
    
    var pharmacyLatitude : Double {
        return (self.pharmacyOnDuty?.latitude)!
    }
    var pharmacyLongitude  : Double {
        return (self.pharmacyOnDuty?.longitude)!
    }
    var pharmacyCounty  : String {
        return (self.pharmacyOnDuty?.ilce)!
    }
    
    var pharmacyPhoneNumber : String? {
        return self.pharmacyOnDuty?.Telefon
    }
    var pharmacyAddress : String? {
        return self.pharmacyOnDuty?.Adresi
    }
    
    
}
