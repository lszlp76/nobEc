//
//  PharmacyFinder.swift
//  travelguide
//
//  Created by ulas özalp on 22.06.2022.
//

import Foundation

struct Pharmacy {
    var distance = [Double]()
    
}

struct PharmacyFinder {
    
    let pharmacyURL  = "https://www.nosyapi.com/apiv2/pharmacyLink?apikey=x58j5AeEFXqvorUFG7X3o5QzGXqcThj8ncFGre0nucdVQYsuZKgfZ8ZKUf8y"
    //
    /*
     bunlar user dan gelecek
     city=bursa&county=mudanya"
     */
    
   func fetchPharmacy(cityName: String,countyName: String){
        let urlString = "\(pharmacyURL)&city=\(cityName)&county=\(countyName)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
   func performRequest(urlString: String){
        //1.create URL
        
        if let url = URL(string: urlString){
            //2.create a url Session
            let session = URLSession(configuration: .default)
            //3.give the session a task
            let task = session.dataTask(with: url)
                                            { data, response, error in
                if error != nil {
                    
                    
                    
                    print (error as Any)
                    return
                    
                }
                
                if let safeData = data {
                  //  let dataString = String(data: safeData, encoding: .utf8)
                    
                    //print(dataString)
                    DispatchQueue.main.async {
                        if let phFounded = self.parseJSON (pharymacyData: safeData){
                            let ViewControllerVC = ViewController()
                            
                            ViewControllerVC.didUpdateFirstVC(pharmacy: phFounded)
                            
                        }
                    }
                    
                }
            }
            //4.start the task
            task.resume()
            }
        
        }
                                            
    func handle (data: Data?, response: URLResponse?, error: Error?){
        
       
            }
     
    func parseJSON (pharymacyData: Data) -> [PharmacyFoundedData]? {
        let decoder = JSONDecoder()
        //var array:[String]=[]
        var ph = [PharmacyFoundedData]()//(pharmacyLatitude: 0.0, pharmacyLongitude: 0.0, pharmacyName: "")]
        do{
        let decodedData =
            try decoder.decode(ResponseJson.self, from: pharymacyData)
       
             for result in decodedData.data {
                
                 ph.append(PharmacyFoundedData(pharmacyLatitude: result.latitude, pharmacyLongitude: result.longitude, pharmacyName: result.EczaneAdi))
                
            
            }
           return ph
        }catch {
            print(error)
            return nil
        }
       
    }

}

