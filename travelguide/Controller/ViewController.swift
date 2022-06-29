//
//  ViewController.swift
//  travelguide
//
//  Created by ulas özalp on 18.06.2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate ,UITextFieldDelegate
{
    
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func ShowButtonClicked(_ sender: Any) {
        
        
        //self.getDirections(loc1: self.location)
        self.performSegue(withIdentifier: "toListViewController", sender: nil)
        
    }
    
    @IBOutlet weak var mapView: MKMapView!
    //to get user's position use location manager
    var locationManager = CLLocationManager()
    var choosenLatitude = Double()
    var choosenLongtitude = Double()
    var selectedTitle = ""
    var selectedTitleID: UUID?
    var annotationTitle = ""
    var annotationSubtitle = ""
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    var turkishConverter = TurkishConverter() //json içindeki tğrkçe karakterleri latin harflerine çeviren fonksiyon
    var city = String() // bulunulan il
    var county = String() // bulunulan ilçe
    var pharmacyFinderManager = PharmacyFinder()
    var location = CLLocationCoordinate2D()
    var connectionGPSExist = Bool() // GPS bağlantısı varlık kontrolu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() //use gps when app is running
        
        locationManager.startUpdatingLocation()
        // find user's position
        // infoplist altında izinleri ayarla
        //uzun basıcı hareket algılayıcı
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
        if selectedTitle != ""{
            print(annotationTitle,annotationLatitude,annotationLongitude)
            let annotation = MKPointAnnotation()
            annotation.title = annotationTitle
            let selectedCoordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
            annotation.coordinate = selectedCoordinate
            self.mapView.addAnnotation(annotation)
            //zoomlamak için
            
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            
            let region = MKCoordinateRegion(center: selectedCoordinate, span: span)
            
            mapView.setRegion(region, animated: true)
        }
        
        
    }
    
    @objc func chooseLocation(gestureRecognizer:UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == .began
        {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            choosenLatitude = touchedCoordinates.latitude
            choosenLongtitude = touchedCoordinates.longitude
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            self.mapView.addAnnotation(annotation)
        }
        
    }
    //location un alınması
 
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error) != nil {
            print(error)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // stop u buraya koyarsan birden fazla taramayı engellersin
        if selectedTitle == ""{
          
            location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude:locations[0].coordinate.longitude )
            
           
            GetLocation.sharedInstance.location = location
            let myLocation : CLLocation = locations[0]
            CLGeocoder().reverseGeocodeLocation(myLocation,
                                                completionHandler:
                                                    { [self](placemarks, error) in
                
                if ((error) != nil)  {
                    
                    let unitAlert = UIAlertController (title:"Konum Hatası",message: "Herhangi bir ağa bağlı değilsiniz.\nAğa bağlandıktan sonra uygulamayı tekrar açabilirsiniz", preferredStyle: .alert)
                    unitAlert.addAction(UIAlertAction (title: "OK", style: .default,handler: { UIAlertAction in
                        
                        
                        self.connectionGPSExist  = false // bağlantı yok
                        
                        return
                    }))
                    self.present(unitAlert,animated: true,completion: nil)
                    print("Error-->: \(String(describing: error))") }
                else {
                    
                    DispatchQueue.main.async {
                        let p = CLPlacemark(placemark: (placemarks?[0] as CLPlacemark?)!)
                        self.locationManager.stopUpdatingLocation()
                        if ((p.administrativeArea) != nil) {
                            self.city = p.administrativeArea!
                        }
                        if ((p.subAdministrativeArea) != nil) {
                            self.county = p.subAdministrativeArea!
                            self.findPharmacyOnDuty(city: self.city, county: self.county)
                        }
                        
                        
                    }
                    //haritada göstermek
                    let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    
                    let region = MKCoordinateRegion(center: self.location, span: span)
                    
                    self.mapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = self.location
                    annotation.title = " Buradasınız "
                    self.mapView.addAnnotation(annotation)
                    mapView.selectAnnotation(mapView.annotations[0], animated: true)
                    self.connectionGPSExist = true //bağlantı var
                    print("jjjj \(GetLocation.sharedInstance.eczaneStored)")
                }   // end else no error
            }       // end CLGeocoder reverseGeocodeLocation
            )       // end CLGeocoder
            
        }
        
    }
    
    
    func didUpdateFirstVC(pharmacy: [PharmacyFoundedData]){
        
        let getLocation = GetLocation.sharedInstance
        getLocation.eczaneStored.removeAll()
       
        for phar in pharmacy   {
            
            /*
             asenkron task olduğu için taskın içinde yazılıyor Dikkat !
             */
            
            pharmacyFinderManager.getDistance(endLocation: CLLocationCoordinate2DMake(phar.pharmacyLatitude, phar.pharmacyLongitude))
            {  distance, travelTime, error in
                
                if let distance = distance
                    
                { let eczaneStored = EczaneVeri(pharmacyLatitude: phar.pharmacyLatitude, pharmacyLongitude: phar.pharmacyLongitude, pharmacyName: phar.pharmacyName,distance: distance ,travelTime: travelTime!)
                    
                    getLocation.eczaneStored.append(eczaneStored)
                    
                    
                }
                else {
                    let unitAlert = UIAlertController (title:"Konum Hatası",message: "Herhangi bir ağa bağlı değilsiniz.\nAğa bağlandıktan sonra uygulamayı tekrar açabilirsiniz", preferredStyle: .alert)
                    unitAlert.addAction(UIAlertAction (title: "OK", style: .default,handler: { UIAlertAction in
                        
                        
                        self.connectionGPSExist  = false // bağlantı yok
                        
                        return
                    }))
                    self.present(unitAlert,animated: true,completion: nil)
                    print("\(String(describing: error)) hata var !")
                    return
                }
            }
            
        }
        
    }
    
    /*
     navigasyon yapmak için annotationları özelleştirmek lazım
     bunun için alttaki fonksyon kullanılır
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toListViewController" {
            let destinationVC = segue.destination as! FirstViewController
            // İhtiyaç halinde taşıma yapılır
            
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //MKAnnotationview döndürmek ister
        
        
    
        if annotation is MKUserLocation {
            return nil // kullanıcı yerini pin le göstermek istemezsen
        }
        let reuseId = "MyAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true // baloncukla bilrlikte ekstra bilgi gösterir
            pinView?.tintColor = UIColor.green
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            // callout içindeki buton basıldığında callOutAccesoryControltapped çalışır
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // listeden seçili yer var ise bu çalışsın
        if selectedTitle != "" {
            
            let  requestLocation = CLLocation(latitude: annotationLatitude, longitude: annotationLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let newPlacemark = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: newPlacemark)
                        item.name = self.annotationTitle
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                        
                    }
                }
            }
        }
    }
    func findPharmacyOnDuty (city: String , county : String){
        // buradan pharcmacyfindeer üzerinden konuma göre JSOn dosyasını pars ederek, eczane listesini oluşturur
        // önce burası çalışır, burası locationmanager üzerinden tetiklenir.
        self.pharmacyFinderManager.fetchPharmacy(cityName: turkishConverter.convertToLatin(word: city), countyName: turkishConverter.convertToLatin(word: county))
        
        
    }
}



