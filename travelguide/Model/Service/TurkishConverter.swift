//
//  TurkishConverter.swift
//  travelguide
//
//  Created by ulas özalp on 25.06.2022.
//

import Foundation


struct TurkishConverter {
  
    func convertToLatin ( word: String) -> String {
        
        var yazi = word
        yazi = yazi.replacingOccurrences(of: "ş", with: "s")
        yazi = yazi.replacingOccurrences(of: "Ş", with: "S")
        yazi = yazi.replacingOccurrences(of: "ö", with: "o")
        yazi = yazi.replacingOccurrences(of: "Ö", with: "O")
        yazi = yazi.replacingOccurrences(of: "ğ", with: "g")
        yazi = yazi.replacingOccurrences(of: "Ğ", with: "G")
        yazi = yazi.replacingOccurrences(of: "İ", with: "i")
        yazi = yazi.replacingOccurrences(of: "ı", with: "i")

        yazi = yazi.replacingOccurrences(of: "ç", with: "c")
        yazi = yazi.replacingOccurrences(of: "Ç", with: "C")
        yazi = yazi.replacingOccurrences(of: "ü", with: "u")
        yazi = yazi.replacingOccurrences(of: "Ü", with: "U")
        
        return yazi
    }
}
