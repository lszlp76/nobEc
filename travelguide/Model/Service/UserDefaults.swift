//
//  UserDefaults.swift
//  travelguide
//
//  Created by ulas özalp on 30.06.2022.
//

import Foundation
extension UserDefaults {
    /*
     USer defaults ta anahtar nokta set etme işlemini doğrudan değil bir değişkene atayarak yap
     aksi durumda o değeri tutmuyor. let olarak değil var olarak yazdırman lazım
     */
    func setValueForAllPharmacyOption(value : Bool, keyName: String){
        if value != nil{
            
                var m = UserDefaults.standard.set(value, forKey: keyName)
           
           
                return
            }
        else {
           UserDefaults.standard.removeObject(forKey: keyName)
             }
    }
    
    func getValueForSwitch(keyName: String) -> Bool? {
        return UserDefaults.standard.bool(forKey: keyName)
    }
    
    
}
