//
//  Webservice.swift
//  travelguide
//
//  Created by ulas özalp on 21.07.2022.
//

import Foundation

class Webservice {
    
    func downloadPharmacyInCity(url : URL, completion: @escaping (ResponseJson?)->()){
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }else if let data = data {
            
                let pharmacyList = try? JSONDecoder().decode(ResponseJson.self,from :data)
              //  print(pharmacyList)
                if let pharmacyList = pharmacyList {
                    completion(pharmacyList)
                }
            }
        }.resume()
    }
}
class LocalService {
    func getPharmacyListFromLocalJsonFile (completion: @escaping (ResponseJson?)->()) {
        // Dosya adını gir
        var resourceJSONName = String()
        resourceJSONName = "tumbursa"
        
        //yolu göster. Bundle atarak
        
        let bundlePath = Bundle.main.path(forResource: resourceJSONName, ofType: "json")
        
        let URL = URL(fileURLWithPath: bundlePath!)
        
        do {
            let datas = try Data(contentsOf: URL)
            
            let pharmacyList = try? JSONDecoder().decode(ResponseJson.self, from: datas)
            completion(pharmacyList)
            
        }catch {
            
        }
    }
}
