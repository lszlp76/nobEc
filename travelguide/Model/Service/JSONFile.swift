//
//  JSONFile.swift
//  travelguide
//
//  Created by ulas özalp on 21.07.2022.
//

import Foundation
struct JSONFile : Decodable {
    
    let data : [PharmacyDatas]
    struct PharmacyDatas : Decodable {
        
        let EczaneAdi : String?
        let Adresi : String?
        let Semt : String?
        let YolTarifi : String?
        let Telefon : String?
        let Telefon2 : String?
        let Sehir : String?
        let ilce : String?
        let latitude : Double
        let longitude : Double
    }
    
}
//struct PharmacyViewModel {
//    // pharmacyData bir JSONFile.PharmacyData objesi olsun
//    let pharmacyData : JSONFile
//   
//    var datas : [JSONFile.PharmacyDatas] {
//        return pharmacyData.data
//    }
//    
//    func numberOfPharmacies () -> Int {
//        return pharmacyData.data.count
//    }
//    
//    
//    
//    // amaç viewController içinde gösterime uygu hale getirmek. Örneğin tableview içinde kullanılması gibi
//    
//}
