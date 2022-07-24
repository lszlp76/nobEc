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
    private var didPerformGeocode = false
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
    var connectionDemand  = 0
    
    var myAnnotation = MyAnnotation(title: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), subtitle: "", travelTime: "")
    
    let eczaneStored = EczaneVeri.init
    var pharmacyOnDuty = [EczaneVeri]()
    var annotaitonsCoordinates = [CLLocation]()
    var nearByPharmacies = [PharmacyNearByAnnotation]()
    
    var pharmacyOnDutyList : PharmacyListViewModel!
    @IBOutlet weak var update: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter : NotificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.turnOnAllPharmacyOption), name: .allPharmacy , object: nil)
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            
            
            locationManager.startUpdatingLocation()
        }else {
            let unitAlert = UIAlertController (title:"Konum Hatası",message: "Çok sayıda talep yaptınız.\nBiraz bekledikten sonra deneyin", preferredStyle: .alert)
            unitAlert.addAction(UIAlertAction (title: "OK", style: .default,handler: { UIAlertAction in
                
                
                // bağlantı yok
                
                return
            }))
            
        }
        
//getData(forCity: "bursa")   //---> şehir bilgisi yok hala
        getDataFromLocal()
        
        
        let updateLocationButton = UIButton(frame: CGRect(x: view.bounds.width-50, y: 0, width: 50, height: 50))
        updateLocationButton.setImage(UIImage(named: "locate"), for: .normal)
        updateLocationButton.tintColor = .red
        updateLocationButton.addTarget(self, action: #selector(updateLocationButtonClicked), for: .touchUpInside)
        mapView.addSubview(updateLocationButton)
        updateLocationButton.rightAnchor.constraint(equalTo: mapView.rightAnchor).isActive = true
       
      //1 - locatin manager üzerinden şehiri bul
    //2 - JSON file üzerinden şehire göre veriyi al.
        
        mapView?.delegate = self
       // mapView.showsUserLocation = true
        
        
        DispatchQueue.global().async {
            print("şehir \(self.city)")
        }
    }
    
    /// Test için local jsonüzerinden çalışmak için
    func getDataFromLocal (){
        LocalService().getPharmacyListFromLocalJsonFile { pharmacyList in
            if let pharmacyList = pharmacyList {
            //3 burada da initilize et
           
                self.pharmacyOnDutyList = PharmacyListViewModel(pharmacy: pharmacyList)
                DispatchQueue.main.async {
                    // tableview güncellemesi burada yapılır
                  
                    print("************WEEEE************")
                    print(self.pharmacyOnDutyList.numberOfDutyPharmacies())
                    
                    self.findDistanceForPharmacyOnDuty()
                
               }
            }
            }
        
    }
    /// web Api üzerinden veri çekme metodu
    /// - Parameter forCity: String
    func getData(forCity : String){
        
        let url = URL(string: ("https://www.nosyapi.com/apiv2/pharmacyLink?apikey=x58j5AeEFXqvorUFG7X3o5QzGXqcThj8ncFGre0nucdVQYsuZKgfZ8ZKUf8y&city=" + (forCity)))
        
        Webservice().downloadPharmacyInCity(url: url!) { pharmacyList in
            if let pharmacyList = pharmacyList {
            //3 burada da initilize et
           
                self.pharmacyOnDutyList = PharmacyListViewModel(pharmacy: pharmacyList)
               
            DispatchQueue.main.async {
                // tableview güncellemesi burada yapılır
              
                print("************WEEEE************")
                print(self.pharmacyOnDutyList.numberOfDutyPharmacies())
                
                self.findDistanceForPharmacyOnDuty()
            
           }
        }
        }
        
    }
        
    
    
    
    func getCityAndCountyName(getCity : @escaping (_ sehir: String?,_ ilce: String?)-> Void) {
        let userLocation =  CLLocation(latitude: getLocation.location.latitude, longitude: getLocation.location.longitude)
        
        GetLocation.sharedInstance.connectionGPSExist = true
        let geoCoder = CLGeocoder()
        var sehir = ""
        var ilce = ""
        geoCoder.reverseGeocodeLocation(userLocation,
                                        completionHandler:
                                            { [self] placemarks, error in
            
            guard let place = placemarks?.first , error == nil else { return}
            
            
            print("getCity çalıştı ")
            sehir = place.administrativeArea!
             ilce = place.subAdministrativeArea!
                
          getCity(sehir,ilce)
            
        })
       
        addSingleAnnotation(coords: CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude))
//        let pin = MKPointAnnotation()
//        pin.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//        pin.title = "Buradasınız"
//
//        self.mapView.addAnnotation(pin)
//
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let group = DispatchGroup()
        
        let location = locations.last
        let userLocation:CLLocation = locations[0] as CLLocation
        
        mapView.centerLocation(userLocation)
        getLocation.location = location!.coordinate // mevcut konum bilgisi alarak json datadan gelen konumlara göre getdistance içindeki source'a atıyor
        
        guard  location?.coordinate.latitude != 0, location?.coordinate.longitude != 0 else {
            let unitAlert = UIAlertController (title:"Konum Hatası",message: "Çok sayıda talep yaptınız.\nBiraz bekledikten sonra deneyin", preferredStyle: .alert)
            unitAlert.addAction(UIAlertAction (title: "OK", style: .default,handler: { UIAlertAction in


                 // bağlantı yok

                return
            }))
            self.present(unitAlert,animated: true,completion: nil)
           return
        }
        
        guard !didPerformGeocode else {
            return
        }
        didPerformGeocode = true
       
//        group.enter()
        getCityAndCountyName { [self] sehir, ilce in
            guard let sehir = sehir else {return}
          
            self.city = sehir
            self.county = ilce!
            pharmacyFinderManager.fetchPharmacy(cityName: sehir, countyName: ilce!)
//            group.leave()
        }
//        group.enter()
        print("kk")
        print(getLocation.todaysDutyPhars.count)
//        fetchPharmacyLocation(location: userLocation)
//        group.leave()
//
//        group.enter()
       
        self.fetchPharmacyLocation(location: CLLocation(latitude: self.getLocation.location.latitude, longitude: getLocation.location.longitude) , pharmacyOnDuty: pharmacyOnDuty)
        GetLocation.sharedInstance.connectionGPSExist = true
//        group.leave()
//
        locationManager.stopUpdatingLocation()
//        group.notify(queue: .main) { [self] in
//
            print(self.city)
            //getData(forCity: <#T##String#>) sonradan gelcek her şey bitince
            
//        }
    }
    
    ///  User locatina göre yakınlardaki eczaneleri bulan fonksiyon.Bulduğu eczaneleri harita üzerine annotation olarak işler
    /// - Parameters:
    ///   - location: mevcut user location
    ///   - regionRadius: <#regionRadius description#>
    ///   - request.naturalLanguageQuery = "Eczaneler"   buradaki anahtar kelimeye göre arama yapar
    ///   - localPharmacies -> PharmacyNearByAnnotation objesidir. Daha sonra annotation olarak kullanabilmek için içine bulduğu eczanenin verilerini atar.
    func fetchPharmacyLocation(location : CLLocation,regionRadius : CLLocationDistance = 100000, pharmacyOnDuty : [EczaneVeri] ) {
        
        let group = DispatchGroup()
        print("fetchPharmacyLocation() calıştı\n")
        print("\(pharmacyOnDuty) liste \n *************")
       
        let span = MKCoordinateSpan(latitudeDelta: 0.115, longitudeDelta: 0.115)
        let regionRadius: CLLocationDistance = 1000
        
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        // let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude ), span: span)
        
        
        let request = MKLocalSearch.Request()
        request.region = region
        request.naturalLanguageQuery = "Eczaneler"
        
        let query  = MKLocalSearch(request: request)
        // var locaAnno = PharmacyNearByAnnotation (title: "", subtitle: "", travelTime: "", distance: 0.0, coordinate: CLLocationCoordinate2DMake(0.0, 0.0))
        group.enter()
       
        query.start { [self] response
            , error in
            guard let response = response else {
                print( error)
                return
            }
            var travelTimeAnno = ""
            var distanceAnno = 0.0
           
            for item in response.mapItems {
                if let name = item.name,
                   let location = item.placemark.location {
                    
                    
                    print("\(name)")
                    //                    getDistance(sourceLocation: GetLocation.sharedInstance.location ,endLocation: location.coordinate)
                    //                    { distance, travelTime, error in
                    //                        if let travelTime = travelTime {
                    //                            travelTimeAnno = travelTime
                    //                            distanceAnno = distance!
                    //                        }
                    //                        if let error = error {
                    //                            print("yakındaki eczaneleri oluşutururken hata \(error.localizedDescription)")
                    //                        }
                    //
                    //                    }
                    let localPharmacies = (PharmacyNearByAnnotation(title: item.name, subtitle: item.phoneNumber, travelTime: travelTimeAnno + "➡️", distance: distanceAnno, coordinate: location.coordinate))
                    
                    
                    
                    nearByPharmacies.append(localPharmacies)
//                    self.annotaitonsCoordinates.append(CLLocation(latitude : localPharmacies.coordinate.latitude,longitude: localPharmacies.coordinate.longitude))
                    addAnnotations(coords: CLLocation(latitude : localPharmacies.coordinate.latitude,longitude: localPharmacies.coordinate.longitude),annos: nearByPharmacies)
                }
                
            }//end loop
            group.leave()
        }
       group.notify(queue: .main)
        { [self] in
           print("deneme")
            
          
       // self.mapView?.addAnnotations(nearByPharmacies)
            
            }
                    
//            self.mapView?.addAnnotations(nearByPharmacies)
           
        }
    func addAnnotations(coords: CLLocation ,annos : [PharmacyNearByAnnotation]){
        self.mapView?.addAnnotations(annos)

        }
    func addSingleAnnotation (coords: CLLocation ){
        let CLLCoordType = CLLocationCoordinate2D(latitude: coords.coordinate.latitude,
                                                  longitude: coords.coordinate.longitude);
       
            let anno = MKPointAnnotation();
            anno.coordinate = CLLCoordType;
            self.mapView.addAnnotation(anno);
       
    }
    func changePinToDutyPharmacy(localPharmacies: [PharmacyNearByAnnotation], pharmacyOnDuty: [EczaneVeri]){
        for pharmacy in localPharmacies{
            for duty in pharmacyOnDuty {
                if  pharmacy.title == duty.pharmacyName{
                    
                    let newCenter = pharmacy.coordinate
                    let circle = MKCircle(center: newCenter, radius: 100)
                    mapView.addOverlay(circle)
                }
                
            }
        }
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self){
                let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.red
                circleRenderer.lineWidth = 1
                return circleRenderer
            }
                return MKOverlayRenderer(overlay: overlay)
          
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        //MKAnnotationview döndürmek ister
        print("mapView çalıştı")
       
        print(getLocation.eczaneStored.count)
     
        
        let phoneButton = PhoneCallButton(type: .custom)
        let button = CarButton(type: .custom)
        
        guard let annotation = annotation as? PharmacyNearByAnnotation else {
            let reuseId = "pin"
            let pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.markerTintColor = UIColor.blue
            
            return pinView
        }
        
        let reuseId = "MyAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        pinView = MKMarkerAnnotationView(annotation: annotation , reuseIdentifier: reuseId)
        pinView?.canShowCallout = true // baloncukla bilrlikte ekstra bilgi gösterir
        pinView?.glyphTintColor = .blue
        pinView?.glyphImage = UIImage(named: "pharmacyLogo.png")
        pinView?.markerTintColor = UIColor.white
      
        for duty in pharmacyOnDuty {
            if duty.pharmacyName == pinView?.annotation?.title
            {
                pinView?.glyphTintColor = .red            }
        }
        let smallSquare = CGSize(width: 50, height: 30)
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 50, height: 50)))
        let labelView = UILabel(frame: CGRect(origin: CGPoint(x: 0.0, y: 30.0), size: CGSize(width: 50, height: 20)))
        button.frame =  CGRect(origin: CGPoint(x: 00.0, y:0.0), size: smallSquare)
        
        let viewPhone = UIView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 50, height: 50)))
        //  let labelViewPhoneNumber = UILabel(frame: CGRect(origin: CGPoint(x: 00.0, y: 30.0), size: CGSize(width: 80, height: 20)))
        
        phoneButton.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 50, height: 50))
        viewPhone.backgroundColor = .blue
        phoneButton.setBackgroundImage(UIImage(systemName: "phone"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "car"), for: .normal)
        
        let location = CLLocation(latitude: (pinView?.annotation?.coordinate.latitude)!, longitude: (pinView?.annotation?.coordinate.longitude)!)
        
        button.location = location
        button.pinName = annotation.title!
        button.addTarget(self, action: #selector(goToPharmacy(sender: )), for: .touchUpInside)
        button.tintColor = .white
        button.backgroundColor = .blue
        phoneButton.tintColor = .white
        phoneButton.backgroundColor = .blue
        phoneButton.phoneNumber = annotation.subtitle!
        phoneButton.addTarget(self, action: #selector(callPhoneNumber(sender:)), for: .touchUpInside)
        view.backgroundColor = .orange
        viewPhone.backgroundColor = .orange
        labelView.text = annotation.travelTime!
        labelView.font = UIFont(name: "arial", size: 14)
        labelView.textColor = .white
        labelView.textAlignment = .center
        labelView.backgroundColor = .blue
        button.addSubview(labelView)
        view.addSubview(button)
        viewPhone.addSubview(phoneButton)
        pinView?.leftCalloutAccessoryView = view
        pinView?.rightCalloutAccessoryView = viewPhone
        return pinView
       
    }
    func checkNearPharmacyIsDuty (annotation : PharmacyNearByAnnotation) -> MKMarkerAnnotationView {
        let reuseId = "checkAnno"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        pinView = MKMarkerAnnotationView(annotation: annotation , reuseIdentifier: reuseId)
        
       
        return pinView!
    }
    /// performRequest ten gelen ph adlı JSON objesinin bilgilerine göre her bir datanın
    /// mesafe ve yolculuk süresini hesaplatarak eczaneStored objecsine yazan fonksiyon
    /// - Parameter pharmacy: [PharmacyFoundedData]
    ///  performRequest'ten gelen ph objesi
    ///  - eczaneStored : geçici obje
    ///  self.getLocation.eczaneStored.append(eczaneStored) ile her yerde kullanılacak olan eczane bilgilerini
    ///  yazar.
    func findDistanceForPharmacyOnDuty()
    {
        let group = DispatchGroup()
        
        print("Find distance for  -->\(self.pharmacyOnDutyList.numberOfDutyPharmacies() )")
        GetLocation.sharedInstance.eczaneStored.removeAll()
        // buraya kadar JSON'dan gelenler aynı
        //getLocation.eczaneStored.removeAll(
        
        print("location bilgisi \(getLocation.location)")
        
        guard getLocation.location.latitude != 0 else {
            
           print("location 0 hatası")
           
            return }
        /*
             asenkron task olduğu için taskın içinde yazılıyor Dikkat !
             */
      let  index = Int()
        
       
        for index in 0...(self.pharmacyOnDutyList.numberOfDutyPharmacies() - 1 ) {
            group.enter()
            let phar = self.pharmacyOnDutyList.pharmacyAtIndex(index)
             
            getDistance(sourceLocation: getLocation.location, endLocation: CLLocationCoordinate2DMake(
               phar.pharmacyLatitude, phar.pharmacyLongitude))
           
            
            { [self]  distance, travelTime, error in
                
              
                if let distance = distance
                    
                    
                { let eczaneStored = //JSON'dan gelen eczaneler ile distance ve traveli birleştirip yeni bir oject yaraıtr.Esas veri
                    
                    
                    EczaneVeri(pharmacyLatitude: phar.pharmacyLatitude, pharmacyLongitude: phar.pharmacyLongitude, pharmacyName: phar.pharmacyName,distance: distance ,travelTime: travelTime!,pharmacyCounty: phar.pharmacyCounty, phoneNumber: phar.pharmacyPhoneNumber ?? "Mevcut değil", pharmacyAddress: phar.pharmacyAddress)
                    
                    self.pharmacyOnDuty.append(eczaneStored)
                    self.getLocation.eczaneStored = pharmacyOnDuty
                }
                
                else {
                    self.getLocation.connectionGPSExist  = false
                    print("\(String(describing: error)) hata var !")
                    return
                }
                // burada stored çalışıyorne
                  group.leave()
                
          
        }
        }// for end
       print(index)
        group.notify(queue: .main){ [self] in
        
          self.getLocation.connectionGPSExist  = true
          
            self.changePinToDutyPharmacy(localPharmacies: nearByPharmacies, pharmacyOnDuty: getLocation.eczaneStored)
         
            
            print("pharmacyOnDuty sayı \(pharmacyOnDuty)")
           
        }

    }
    
    func getDistance (sourceLocation : CLLocationCoordinate2D, endLocation : CLLocationCoordinate2D,  completion: @escaping (_ distance: Double?,_ travelTime : String?,_ error : Error?) -> (Void))
    {
//        let grup = DispatchGroup()
        
        let request = MKDirections.Request()
        
        let source = MKPlacemark( coordinate: sourceLocation)//CLLocationCoordinate2D(latitude: 40.2145, longitude: 28.981821))
        // MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.2145, longitude: 28.981821))
        
        var msf : Double?
        var travelTime : String?
        
        let destination = MKPlacemark( coordinate: endLocation)
        
        request.source =  MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        //  print("request değerleri --> \(request.destination) \(destination.location?.coordinate)")
        request.transportType = MKDirectionsTransportType.automobile
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections ( request: request)
//        grup.enter()
            directions.calculate { (response, error) in
                
                if let error = error {
                    
                    print("Distance directions calculation error\n destination")
                    return
                }
                if let route = response?.routes {
                    let sortedRoutes = route.sorted(by: { $0.distance < $1.distance}) // en küçüğe göre sort ediyor
                    let shortestRoute = sortedRoutes.first // sonra o dizinin ilk elemanını alıyor, böylece en kısa mesafeyi buluş oluyor
                    msf = shortestRoute!.distance/1000
                    travelTime = String(format: "%.0f",shortestRoute!.expectedTravelTime/60)
                    
                }
                completion  (msf,travelTime, error)
            
//                grup.leave()
        }
    }
    @objc func updateLocationButtonClicked (){
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: getLocation.location, span: span)
        mapView.setRegion(region, animated: true)
        locationManager.startUpdatingLocation()
        didPerformGeocode = false
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
   
    @objc func turnOnAllPharmacyOption (){
        
        if userDefault.getValueForSwitch(keyName: "allPharmacyOption") == true {
            allPharmacyOption = true
            GetLocation.sharedInstance.allPharmacy = allPharmacyOption
            print( "allPharmacyOption is ON")
            userDefault.setValueForAllPharmacyOption(value: true, keyName: "allPharmacyOption")
        }else {
            allPharmacyOption = false
            print( "allPharmacyOption is Off")
            GetLocation.sharedInstance.allPharmacy = allPharmacyOption
            userDefault.setValueForAllPharmacyOption(value: false, keyName: "allPharmacyOption")
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
    /**
     
     ALTTAKİ ÇÖZÜM ÖNEMLİ !!
     COMPLETİON HANDLERİN UYGULANDIĞINA BAKIP TEKRARI ENGELLİYOR
     
     */

    
    /*
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
     //locationManager.stopUpdatingLocation()
     self.location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude:locations[0].coordinate.longitude )
     GetLocation.sharedInstance.location = self.location
     let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
     let region = MKCoordinateRegion(center: self.location, span: span)
     self.mapView?.setRegion(region, animated: true)
     
     
     }
     */
    /**
     telefon numarası yazdırırken aralarında boşluk olmaması lazım
     aksi durumda sadece karakter olarak alır. o yüzden .replacingOccurrencs kullanarak
     tüm boşluklar kaldırılır.
     //tel://0(224)413-43-46  --> bu çalışır.
     //tel://+90 (224) 249 06 90   --> bu çalışmaz
     */
    @objc func callPhoneNumber (sender: PhoneCallButton) {
        print("tel://\(sender.phoneNumber)")
        
        let phoneNumber = sender.phoneNumber.replacingOccurrences(of: " ", with: "")
        
        if let phoneCall = URL(string: ("tel://"+(phoneNumber) ))
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCall)) {
                application.open(phoneCall, options: [:], completionHandler:  { error in
                    
                    if error != nil {
                        print("telefon \(error)")
                        return
                    }
                    
                })
            }
        }
    }
    @objc func goToPharmacy(sender: CarButton) {
        let   location = sender.location
        print("yola basıldı--> \(location)")
        let  requestLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
            if let placemark = placemarks {
                if placemark.count > 0 {
                    let newPlacemark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlacemark)
                    item.name = sender.pinName
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                    
                }
            }
        }
    }
    
}
private extension MKMapView {
    
    
    /// Verilen bir konum bilgisini göstermek için kullanılır
    /// location : CLLocation olmalı, region yarıçapı 1000 m olarak default ayarlıdır.
    func centerLocation (_ location: CLLocation,
                         regionRadius: CLLocationDistance = 1000 // 1000 m yarıçapında bir alan
    )
    {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.009)
        let region = MKCoordinateRegion(center: location.coordinate, span : span)
        setRegion(region, animated: true)
    }
    
}

