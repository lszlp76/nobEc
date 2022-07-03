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
    /*
    @IBAction func ShowButtonClicked(_ sender: Any) {
        
        
        //self.getDirections(loc1: self.location)
        self.performSegue(withIdentifier: "toListViewController", sender: nil)
        
   // }
     */
    @IBOutlet weak var updateView: UIView!
    @IBAction func updateBUtton(_ sender: Any) {
    }
    @IBOutlet weak var mapView: MKMapView!
    //to get user's position use location manager
    var allPharmacyOption = Bool()
    var locationManager = CLLocationManager()
    let userDefault = UserDefaults.standard
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
    var tekrar = 0
     // GPS bağlantısı varlık kontrolu
    let getLocation = GetLocation.sharedInstance
    
    @IBOutlet weak var update: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        print("Key --> \(userDefault.bool(forKey: "allPharmacyOption"))")

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        let notificationCenter : NotificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.turnOnAllPharmacyOption), name: .allPharmacy , object: nil)
        
   
        
        
        print("Key --> \(userDefault.bool(forKey: "allPharmacyOption"))")

        
        mapView?.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() //use gps when app is running
        locationManager.distanceFilter = 100000
        locationManager.startUpdatingLocation()
       //locationManager.requestLocation()
       
        // find user's position
        // infoplist altında izinleri ayarla
        //uzun basıcı hareket algılayıcı
        print("mesafe \(view.bounds.width)")
        let updateLocationButton = UIButton(frame: CGRect(x: view.bounds.width-50, y: 0, width: 50, height: 50))
        updateLocationButton.setImage(UIImage(named: "location.png"), for: .normal)
       updateLocationButton.tintColor = .red
        updateLocationButton.addTarget(self, action: #selector(updateLocationButtonClicked), for: .touchUpInside)
        mapView.addSubview(updateLocationButton)
        updateLocationButton.rightAnchor.constraint(equalTo: mapView.rightAnchor).isActive = true
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
       
        
        
        
        gestureRecognizer.minimumPressDuration = 3
        mapView?.addGestureRecognizer(gestureRecognizer)
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
        
        //turnOnAllPharmacyOption()
        
    }
    @objc func updateLocationButtonClicked (){
        locationManager.distanceFilter = 100000
        locationManager.startUpdatingLocation()
        didPerformGeocode = false
      
        
    }
   
    @objc func turnOnAllPharmacyOption (){
        
        if userDefault.getValueForSwitch(keyName: "allPharmacyOption") == true {
            allPharmacyOption = true
            GetLocation.sharedInstance.allPharmacy = allPharmacyOption
        print( "allPharmacyOption is ON")
          
            userDefault.setValueForAllPharmacyOption(value: true, keyName: "allPharmacyOption")
         // findPharmacyOnDuty(city: city, county: county)
        }else {
            allPharmacyOption = false
            
            print( "allPharmacyOption is Off")
            GetLocation.sharedInstance.allPharmacy = allPharmacyOption
            
            userDefault.setValueForAllPharmacyOption(value: false, keyName: "allPharmacyOption")
          
            //findPharmacyOnDuty(city: city, county: county)
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
      
            print(error)
       
    }
    
    /**
     
     ALTTAKİ ÇÖZÜM ÖNEMLİ !!
     COMPLETİON HANDLERİN UYGULANDIĞINA BAKIP TEKRARI ENGELLİYOR
     
     */
    
    private var didPerformGeocode = false
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // stop u buraya koyarsan birden fazla taramayı engellersin
      
    
        guard let location = locations.first , location.horizontalAccuracy >= 0
        else
        {
         return
        }
        guard !didPerformGeocode else {
            return
        }
        didPerformGeocode = true
        locationManager.stopUpdatingLocation()
        
        
            if self.selectedTitle == ""{
                
                self.location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude:locations[0].coordinate.longitude )
            
               
                GetLocation.sharedInstance.location = self.location
                let myLocation : CLLocation = locations[0]
                locationManager.stopUpdatingLocation()
                CLGeocoder().reverseGeocodeLocation(myLocation,
                                                    completionHandler:
                                                        { [self](placemarks, error) in
                    
                    if ((error) != nil)  {
                      
                        let unitAlert = UIAlertController (title:"Konum Hatası",message: "Herhangi bir ağa bağlı değilsiniz.\nAğa bağlandıktan sonra uygulamayı tekrar açabilirsiniz", preferredStyle: .alert)
                        unitAlert.addAction(UIAlertAction (title: "OK", style: .default,handler: { UIAlertAction in
                            
                            
                         getLocation.connectionGPSExist  = false // bağlantı yok
                            
                            return
                        }))
                        self.present(unitAlert,animated: true,completion: nil)
                        print("Error-->: \(String(describing: error))") }
                    else {
                        
                        
                            let p = CLPlacemark(placemark: (placemarks?[0] as CLPlacemark?)!)
                           
                            if ((p.administrativeArea) != nil) {
                                self.city = p.administrativeArea!
                                
                            }
                            if ((p.subAdministrativeArea) != nil) {
                                self.county = p.subAdministrativeArea!
                                getLocation.county = county
                               self.findPharmacyOnDuty(city: self.city, county: self.county)
                            }
                        //haritada göstermek
                        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                        
                        let region = MKCoordinateRegion(center: self.location, span: span)
                        
                        self.mapView?.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = self.location
                        annotation.title = " Buradasınız "
                        self.mapView?.addAnnotation(annotation)
                        mapView?.selectAnnotation(mapView.annotations[0], animated: true)
                        self.getLocation.connectionGPSExist = true //bağlantı var
                                            }   // end else no error
                }       // end CLGeocoder reverseGeocodeLocation
                )       // end CLGeocoder
                
            }
          

        
    }
    
    
    func didUpdateFirstVC(pharmacy: [PharmacyFoundedData]){
        
       
        getLocation.eczaneStored.removeAll()
      
            for phar in pharmacy   {
                /*
                 asenkron task olduğu için taskın içinde yazılıyor Dikkat !
                 */
                
                pharmacyFinderManager.getDistance(endLocation: CLLocationCoordinate2DMake(phar.pharmacyLatitude, phar.pharmacyLongitude))
                {  distance, travelTime, error in
                    
                    if let distance = distance
                        
                    { let eczaneStored = EczaneVeri(pharmacyLatitude: phar.pharmacyLatitude, pharmacyLongitude: phar.pharmacyLongitude, pharmacyName: phar.pharmacyName,distance: distance ,travelTime: travelTime!,pharmacyCounty: phar.pharmacyCounty, phoneNumber: phar.pharmacyPhoneNumber ?? "Mevcut değil")
                        
                        self.getLocation.eczaneStored.append(eczaneStored)
                        
                        self.getLocation.connectionGPSExist  = true
                        print("bu \(self.getLocation.eczaneStored)")
                    }
                    
                    else {
                        self.getLocation.connectionGPSExist  = false
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
            _ = segue.destination as! FirstViewController
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
           // pinView?.image = UIImage(named:"pin-50.png")
            pinView?.tintColor = UIColor.blue
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
          
            pinView?.rightCalloutAccessoryView = button
            
           
            //mapView.selectAnnotation(mapView.annotations[0], animated: true)
            // callout içindeki buton basıldı ğında callOutAccesoryControltapped çalışır
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



