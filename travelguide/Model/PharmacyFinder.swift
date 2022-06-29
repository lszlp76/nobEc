//
//  PharmacyFinder.swift
//  travelguide
//
//  Created by ulas özalp on 22.06.2022.
//

import Foundation
import MapKit

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
       //performRequest(urlString: urlString) //gerçek datalarla çalışmak için
       performRequestFromLocalJson(urlString: urlString) //local json ile çalışmak için
    }
    
    func performRequestFromLocalJson(urlString: String) {
           /*
            BU kod json üzerinden çalımak için . API'yi denemesini azaltmak amacıyla kullanılıyor. App storea giderken
            devre dışında kalacak
            */
            let bundlePath = Bundle.main.path(forResource: "eczane", ofType: "json")
          
                    let URL = URL(fileURLWithPath: bundlePath!)
           
            do {
                let datas = try Data(contentsOf: URL)
                let results = try JSONDecoder().decode(ResponseJson.self , from : datas)
                
                if let phFounded = parseJSON (pharymacyData: datas){
                    let ViewControllerVC = ViewController()
                    
                    ViewControllerVC.didUpdateFirstVC(pharmacy: phFounded)
                }
             
                }catch {
                print(error)
              
            }
        }
    /*
     Mesafeler ve süreleri alan fonksiyon. Esas işi bu yapıyor. pharmacyManager'in içinde alınıyor.
     */
    func getDistance (endLocation : CLLocationCoordinate2D,  completion: @escaping (_ distance: Double?,_ travelTime : String?
                                                                                    , _ error : Error?) -> (Void))
    {
        // NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
        
        let request = MKDirections.Request()
        
        let source = MKPlacemark( coordinate: GetLocation.sharedInstance.location)//CLLocationCoordinate2D(latitude: 40.2145, longitude: 28.981821))
        
        
        var msf : Double?
        var travelTime : String?
        let destination = MKPlacemark( coordinate: endLocation)
        request.source =  MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = MKDirectionsTransportType.automobile
        request.requestsAlternateRoutes = false
        let directions = MKDirections ( request: request)
        directions.calculate { (response, error) in
            if let route = response?.routes.first {
                msf = route.distance/1000
                travelTime = String(format: "%.2f",route.expectedTravelTime/60)
                print("zaman --> \(travelTime)")
            }
            // en karışık kod bu fonskiyon. asenkron çalıştırma örneği . completion handler olayı
            completion  (msf,travelTime, error)
            
        }
        return
        
    }

      

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
                        if let phFounded = parseJSON (pharymacyData: safeData){
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


