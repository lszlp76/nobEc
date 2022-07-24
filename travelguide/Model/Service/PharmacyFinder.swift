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
    var allPharmacy = Bool()
    var distanceArray : [MKRoute]?
    mutating func fetchPharmacy(cityName: String,countyName: String){
        print("JSON için fetch pharmacy çalıştı")
        var urlString = String()
        
        print("allPharmacy değeri \(GetLocation.sharedInstance.allPharmacy)")
        allPharmacy = GetLocation.sharedInstance.allPharmacy
        GetLocation.sharedInstance.county = countyName
        urlString = "\(pharmacyURL)&city=\(cityName)"
        var ph = [PharmacyFoundedData]()//(pharmacyLatitude: 0.0, pharmacyLongitude: 0.0, pharmacyName: "")]
        var phWithDetail = [PharmacyData]()
        var phCounty = [PharmacyFoundedData]()
        let ViewControllerVC = ViewController()
        
        
//performRequestFromLocalJson(urlString: urlString) //local json ile çalışmak için
//        
//        /*
//         json web result denemesi
//         */
//        
//        performRequest(urlString: urlString) { result in
//
//print("JSON okuma başladı")
//            switch result {
//            case .failure(let error ):
//                print(error.localizedDescription)
//
//            case .success(let JSONData):
//                if let JSONData = JSONData {
//                    print(JSONData)

//                    for result in JSONData.pharmacy.data {
//                        ph.append(PharmacyFoundedData(pharmacyLatitude: result.latitude, pharmacyLongitude: result.longitude, pharmacyName: result.EczaneAdi!, pharmacyCounty: result.ilce!, pharmacyPhoneNumber: result.Telefon, pharmacyAddress: result.Adresi))
//                        /*Sadece ilçedeki eczaneler
//                         bunları açılışta kullanmak için alıyor
//                         */
//                        if result.ilce == GetLocation.sharedInstance.county
//                        {GetLocation.sharedInstance.pharmacyForOpening.append(PharmacyFoundedData(pharmacyLatitude: result.latitude, pharmacyLongitude: result.longitude, pharmacyName: result.EczaneAdi!, pharmacyCounty: result.ilce!, pharmacyPhoneNumber: result.Telefon, pharmacyAddress: result.Adresi))
//                        }
//                    }
//                    print("JSON'da veri geldi \(ph.count)")
//                    GetLocation.sharedInstance.todaysDutyPhars = ph
                   // ViewControllerVC.didUpdateFirstVC(pharmacy: ph)
//                }
//            }
//        }
//
  }
//
    func performRequest(urlString: String , completion:  @escaping  (Result<PharmacyData?,ResponseJSONError>) -> ()){
        //1.create URL
        DispatchQueue.main.async {
            
        if let url = URL(string: urlString){
            //2.create a url Session
            let session = URLSession(configuration: .default)
            //3.give the session a task
            let task = session.dataTask(with: url)
            { data, response, error in
                
                if error != nil {
                    print (error as Any)
                    
                    completion(.failure(.badURL))
                    return
                    
                }
                
                if let safeData = data {
    //                let dataString = String(data: safeData, encoding: .utf8)
    //
    //                print(dataString)
                    do{
                        let phFounded = parseJSON(pharymacyData: safeData)
               //completion önüne ve arkasına işlem koyma
                        completion(.success(phFounded))
                      
                    }catch {
                        print("error \(error.localizedDescription)")
                        completion(.failure(.noDATA))
                    }
                    
                }
                
            }//data end
            
            //4.start the task
            task.resume()
        }
        }
    }
   
}



func performRequestFromLocalJson(urlString: String) {
    /*
     BU kod json üzerinden çalımak için . API'yi denemesini azaltmak amacıyla kullanılıyor. App storea giderken
     devre dışında kalacak
     */
    var ph = [PharmacyFoundedData]()
    var resourceJSONName = String()
    resourceJSONName = "tumbursa"
    
    /*
     if allPharmacy {
     resourceJSONName = "tumbursa"
     }else {
     resourceJSONName = "eczane"
     }
     */
    let bundlePath = Bundle.main.path(forResource: resourceJSONName, ofType: "json")
    
    let URL = URL(fileURLWithPath: bundlePath!)
    
    do {
        
        let datas = try Data(contentsOf: URL)
        // let results = try JSONDecoder().decode(ResponseJson.self , from : datas)
        
        if let phFounded = parseJSON (pharymacyData: datas){
            
            for result in phFounded.pharmacy.data{
                ph.append(PharmacyFoundedData(pharmacyLatitude: result.latitude, pharmacyLongitude: result.longitude, pharmacyName: result.EczaneAdi!, pharmacyCounty: result.ilce!, pharmacyPhoneNumber: result.Telefon, pharmacyAddress: result.Adresi))
                /*Sadece ilçedeki eczaneler
                 bunları açılışta kullanmak için alıyor
                 */
                if result.ilce == GetLocation.sharedInstance.county
                {GetLocation.sharedInstance.pharmacyForOpening.append(PharmacyFoundedData(pharmacyLatitude: result.latitude, pharmacyLongitude: result.longitude, pharmacyName: result.EczaneAdi!, pharmacyCounty: result.ilce!, pharmacyPhoneNumber: result.Telefon, pharmacyAddress: result.Adresi))
                }
            }
            print("ph --> \(ph.count)")
            
           
            let ViewControllerVC = ViewController()
            
          //  ViewControllerVC.didUpdateFirstVC(pharmacy: ph)
            
        }
        
        
    }catch {
        print(error)
        
        
    }
}
/*
 Mesafeler ve süreleri alan fonksiyon. Esas işi bu yapıyor. pharmacyManager'in içinde alınıyor.
 */
func getDistance (sourceLocation : CLLocationCoordinate2D, endLocation : CLLocationCoordinate2D,  completion: @escaping (_ distance: Double?,_ travelTime : String?
                                                                                                                         , _ error : Error?) -> (Void))
{
    
    
    // NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    
    let request = MKDirections.Request()
    //GetLocation.sharedInstance.location
    let source = MKPlacemark( coordinate: sourceLocation)//CLLocationCoordinate2D(latitude: 40.2145, longitude: 28.981821))
    // MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.2145, longitude: 28.981821))
    
    var msf : Double?
    var travelTime : String?
    
    let destination = MKPlacemark( coordinate: endLocation)
    
    request.source =  MKMapItem(placemark: source)
    request.destination = MKMapItem(placemark: destination)
    request.transportType = MKDirectionsTransportType.automobile
    request.requestsAlternateRoutes = false
    
    let directions = MKDirections ( request: request)
    
    
    directions.calculate { (response, error) in
        
        if let route = response?.routes{
            
            let sortedRoutes = route.sorted(by: { $0.distance < $1.distance}) // en küçüğe göre sort ediyor
            let shortestRoute = sortedRoutes.first // sonra o dizinin ilk elemanını alıyor, böylece en kısa mesafeyi buluş oluyor
            msf = shortestRoute!.distance/1000
            travelTime = String(format: "%.0f",shortestRoute!.expectedTravelTime/60)
            
        }
        
        // en karışık kod bu fonskiyon. asenkron çalıştırma örneği . completion handler olayı
        completion  (msf,travelTime, error)
        
    }
    
    return
    
}

func alertMessaage(){
    
}




func performRequest(urlString: String , completion:  @escaping  (Result<PharmacyData?,ResponseJSONError>) -> ()){
    //1.create URL
    DispatchQueue.main.async {
        
    if let url = URL(string: urlString){
        //2.create a url Session
        let session = URLSession(configuration: .default)
        //3.give the session a task
        let task = session.dataTask(with: url)
        { data, response, error in
            
            if error != nil {
                print (error as Any)
                
                completion(.failure(.badURL))
                return
                
            }
            
            if let safeData = data {
//                let dataString = String(data: safeData, encoding: .utf8)
//
//                print(dataString)
                do{
                    let phFounded = parseJSON(pharymacyData: safeData)
           //completion önüne ve arkasına işlem koyma
                    completion(.success(phFounded))
                  
                }catch {
                    print("error \(error.localizedDescription)")
                    completion(.failure(.noDATA))
                }
                
            }
            
        }//data end
        
        //4.start the task
        task.resume()
    }
    }
}

func handle (data: Data?, response: URLResponse?, error: Error?){
    
    
}

func parseJSON (pharymacyData: Data) -> PharmacyData? {
    let decoder = JSONDecoder()
    //var array:[String]=[]
    var ph :PharmacyData//(pharmacyLatitude: 0.0, pharmacyLongitude: 0.0, pharmacyName: "")]
    var phCounty = [PharmacyFoundedData]()
    do{
        let decodedData =
        try decoder.decode(ResponseJson.self, from: pharymacyData)
    
        ph = (PharmacyData(pharmacy: decodedData))
         return ph
    }catch {
        print(error)
        return nil
    }
    
}

func isConnectionGPSOK() -> Bool {
    let locationManager = CLLocationManager()
    
    if CLLocationManager.locationServicesEnabled()
    { switch CLLocationManager.authorizationStatus() {
        
    case .denied,.restricted,.notDetermined:
        print ("NOK connections")
        return false
        break
    case .authorized,.authorizedWhenInUse, .authorizedAlways :
        print("Connection OK")
        return true
        break
    default:
        print("Connection OK")
        return true
    }
    }
    else
    {
        print (" okok")
        
    }
    return false
}

enum ResponseJSONError : Error {
    case badURL
    case noDATA
}

