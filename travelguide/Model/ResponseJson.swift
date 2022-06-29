//
//  ResponseJson.swift
//  travelguide
//
//  Created by ulas özalp on 25.06.2022.
//

import Foundation
struct ResponseJson : Decodable {
    struct ResponseJsonData : Decodable {
        /*
         optional olması gerekiyor, cunki json dosyada boş değer olabilir.
         */
        let EczaneAdi : String
        let Adresi : String?
        let Semt : String?
        let YolTarifi : String?
        let Telefon : String?
        let Telefon2 : String?
        let Sehir : String
        let ilce : String
        let latitude : Double
        let longitude : Double
        
    }
    let status : String
    let message : String
    let rowCount : Int
    let data : [ResponseJsonData]
    
}


