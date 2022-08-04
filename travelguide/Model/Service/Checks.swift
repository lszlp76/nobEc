//
//  Checks.swift
//  travelguide
//
//  Created by ulas özalp on 2.08.2022.
//

import Foundation
import UIKit


class CheckGPSSignal {
    func showAlertController () -> UIViewController{
        
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil){
            topController = topController?.presentedViewController
        }
        return topController!
        
    }

    func alert(title : String, message :String){
        let alert = UIAlertController( title: title, message: message , preferredStyle: .alert)
        let cancelAction : UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
        { action -> Void in
            
        }
        alert.addAction(cancelAction)
      
        showAlertController().present(alert, animated: true, completion: nil)
        
    }
    func presentViewController( alert : UIAlertController, animated flag : Bool, completion : (()-> Void)?) -> Void{
        UIApplication.shared.keyWindow?.window?.rootViewController!.present(alert,animated: flag,completion: completion)
    }
    
}


//if (someLocation.horizontalAccuracy < 0)
//{
//   // No Signal
//}
//else if (someLocation.horizontalAccuracy > 163)
//{
//   // Poor Signal
//}
//else if (someLocation.horizontalAccuracy > 48)
//{
//   // Average Signal
//}
//else
//{
//   // Full Signal
//}
