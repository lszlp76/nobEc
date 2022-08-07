//
//  ViewController.swift
//  travelguide
//
//  Created by ulas özalp on 18.06.2022.
//

import UIKit
import MapKit
import CoreLocation
import Network



class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate ,UITextFieldDelegate,UIGestureRecognizerDelegate, UITabBarControllerDelegate
{
    @IBOutlet weak var saveButton: UIButton!
    /*
     @IBAction func ShowButtonClicked(_ sender: Any) {
     //self.getDirections(loc1: self.location)
     self.performSegue(withIdentifier: "toListViewController", sender: nil)
     
     // }
     */
    private var demandTutorial = false
    private var didPerformGeocode = false
    var connectionManager = CheckInternetConnection()
    @IBOutlet weak var updateView: UIView!
    @IBAction func updateBUtton(_ sender: Any) {
    }
    @IBOutlet weak var mapView: MKMapView!
    
    var nearPharmacyTab : UIImageView!
    var pharmacyDutyListTab : UIImageView!
    var settingsTab: UIImageView!
    var locateButton : UIImageView!
    var circle = MKCircle()
    var circle2 = MKCircle()
    var  didTutorialEnd = Bool()
    //to get user's position use location manager
    var allPharmacyOption = Bool()
    var locationManager = CLLocationManager()
    var userLocation:CLLocation!
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
    let annotation = MKPointAnnotation()
    var pharmacyOnDutyList : PharmacyListViewModel!
    let anno = MKPointAnnotation();
    var newNearByPharmacies = [PharmacyNearByAnnotation]()
    
    let stackView = UIStackView()
    let stackViewUp = UIStackView()
    let updateLocationButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    var openingTime = Date()
    var didUpdateLocationDemanded = Bool()
    var firstOpen = Bool()
    @IBOutlet weak var update: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("ulas")
       
        guard  connectionManager.isNetworkAvailable()  else {
            print("no connection to internet")
            CheckGPSSignal().alert(title: " İnternet Bağlantısı", message: "Bağlantı yok ⚠️")
            
            return
            
        }
        
        if CLLocationManager.locationServicesEnabled() == false {
        
            CheckGPSSignal().alert(title: "Konum", message: "Konum bilgisi yok ⚠️")
            
        }
        
        guard userLocation != nil else {
            CheckGPSSignal().alert(title: "Konum Bilgisi", message: "Konumuzda herhangi bir veri yok ⚠️")
            return
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear çalıştır")
        
        mapView?.delegate = self
        if userDefault.getValueForSwitch(keyName: "tutorial")! ||
            !(userDefault.getValueForSwitch(keyName: "firstUsage")! )  { tutorialActivate() }
        
        //        guard  connectionManager.isNetworkAvailable()  else {
        //            print("no connection to şnternet")
        //            showSimpleAlert(title: "İnternet Bağlantısı", message: "Bağlantı yok!")
        //           return
        //        }
        if didPerformGeocode == true
        {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidLoad çalıştır")
        
        self.tabBarController?.delegate = self
        
        // 1. Choose a date
        openingTime = Date.now
    didUpdateLocationDemanded = false
        firstOpen = true
        print(openingTime)
        
        if userDefault.getValueForSwitch(keyName: "tutorial")! ||
            !(userDefault.getValueForSwitch(keyName: "firstUsage")! ) {
            
            print("tutorial value : \(userDefault.getValueForSwitch(keyName: "tutorial"))")
            print("firstUsage value : \(userDefault.getValueForSwitch(keyName: "firstUsage"))")
            
            demandTutorial = true
            
        }
        self.tabBarController?.tabBar.tintColor = UIColor(named: "SpesificColor")
        
        
        updateLocationButton.setImage(UIImage(named: "locate"), for: .normal)
        updateLocationButton.tintColor =  UIColor(named: "SpesificColor")
        updateLocationButton.addTarget(self, action: #selector(updateLocationButtonClicked), for: .touchUpInside)
        
        mapView.addSubview(updateLocationButton)
        updateLocationButton.topAnchor.constraint(equalTo: mapView.topAnchor,constant: 0).isActive = true
        
        
        
        
        let notificationCenter : NotificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.turnOnAllPharmacyOption), name: .allPharmacy , object: nil)
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            
            
            locationManager.startUpdatingLocation()
        }else {
            
            CheckGPSSignal().alert(title: "Konum", message: "Konum bilgisi yok ⚠️")
            
            
         
            
        }
        
        //---> şehir bilgisi yok hala
       //getDataFromLocal()
        
        
        /***Tutorial Kısmı****/
        /*
         İlk defa kullanırken ve ayarlardan isterse açılacak
         */
        
        
        
        //1 - locatin manager üzerinden şehiri bul
        //2 - JSON file üzerinden şehire göre veriyi al.
        
        mapView?.delegate = self
        //mapView.showsUserLocation = true
        
        //haritada basılan bir noktada eczane arama
        let choosenLocationTap =  UILongPressGestureRecognizer ( target: self, action: #selector(findNearPharmacy(gestureRecognizer: )))
        choosenLocationTap.delegate = self
        choosenLocationTap.minimumPressDuration = 2
        mapView.addGestureRecognizer(choosenLocationTap)
        
       DispatchQueue.main.async {
            print("bitti")    }
        
    }
    @objc func findNearPharmacy(gestureRecognizer : UIGestureRecognizer) {
        //1 basıldığını kontrol et
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: self.mapView) //2 basılan noktayı view da bul
            let newCoordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView) //3 o noktayı koordinata çevir
            let newLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            let CLLCoordType = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude,
                                                      longitude: newLocation.coordinate.longitude);
            
            
            anno.coordinate = CLLCoordType;
            anno.title = " Yeni nokta"
            self.mapView.addAnnotation(anno);
            
            fetchUserChoosenLocation(location: newLocation)
          
            mapView.centerLocation(newLocation,regionRadius: 3000)
            
        }
    }
    func fetchUserChoosenLocation (location : CLLocation){
        let span = MKCoordinateSpan(latitudeDelta: 0.115, longitudeDelta: 0.115)
        let regionRadius: CLLocationDistance = 1000
       let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        
        
        let request = MKLocalSearch.Request()
        request.region = region
        request.naturalLanguageQuery = "Eczaneler"
        
        let query  = MKLocalSearch(request: request)
        
        query.start { [self] response
            , error in
            guard let response = response else {
                print( error)
                return
            }
            print("yakın eczane sayısı \(response.mapItems.count))")
            
            for item in response.mapItems {
                if let name = item.name,let phoneNumber = item.phoneNumber  , let location = item.placemark.location {
                    
                    
                    
                    let localPharmacies = (PharmacyNearByAnnotation(title: item.name, subtitle: item.phoneNumber, travelTime:"⏩", distance: 0.0, coordinate: location.coordinate))
                    print(item.phoneNumber)
                    newNearByPharmacies.append(localPharmacies)
                    addAnnotations(annos: newNearByPharmacies)
                    
                    
                    
                } else {
                    print("hata var")
                }
            }//end loop
            
            
        }
    }
    @objc func updateLocationButtonClicked (){
        /*
         60 sn. ara ile map API'den veri alman lazım , yoksa hata verir
         */
        
        mapView.centerLocation(userLocation)
        let currentTime = Date.now
        print("openning time \(openingTime)")
        print("current time \(currentTime)")
        let diffTime = currentTime.timeIntervalSinceReferenceDate - openingTime.timeIntervalSinceReferenceDate
        if diffTime > 60 {
            mapView.removeAnnotation(anno)
            mapView.removeAnnotations(nearByPharmacies)
            mapView.removeAnnotations(newNearByPharmacies)
            mapView.removeOverlay(circle)
            mapView.removeOverlay(circle2)
            locationManager.startUpdatingLocation()
            
            self.openingTime = currentTime //açılış saatini en son değer yaıyor
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let group = DispatchGroup()
        
        let location = locations.last
        userLocation = locations[0] as CLLocation
        
        mapView.centerLocation(userLocation)
        getLocation.location = location!.coordinate // mevcut konum bilgisi alarak json datadan gelen konumlara göre getdistance içindeki source'a atıyor
        
        guard  location?.coordinate.latitude != 0, location?.coordinate.longitude != 0 else {
            print("00000")
            CheckGPSSignal().alert(title: "Konum Hatası", message: "Konum bilgisi hatalı")
            
           
            return
        }
        
      
        
    group.enter()
        /*
         getCityAndCountyName > async çalıştığı için dispatchgrup a almalısın
         yoksa şehir bilgisini açılışta alamazsın
         
         */
        getCityAndCountyName { [self] sehir, ilce in
            guard let sehir = sehir else {return}
            
            
            self.city = sehir
            self.county = ilce!
            
          
            group.leave()
            
           
        }
        group.notify(queue: .main)
        { [self] in  // notify yapmazsan getdata,fetch in öne geçer
            guard !userDefault.getValueForSwitch(keyName: "tutorial")! else {return}
                    print("Açılış verisi")
                    self.fetchPharmacyLocation(location: CLLocation(latitude: self.getLocation.location.latitude, longitude: getLocation.location.longitude) , pharmacyOnDuty: pharmacyOnDuty)
                    getData(forCity: self.city)
                 firstOpen = false
                    
                
            }
        
            
            
        GetLocation.sharedInstance.connectionGPSExist = true
        
        locationManager.stopUpdatingLocation()
       
        print(self.city)
        
    }
    func getCityAndCountyName(getCity : @escaping (_ sehir: String?,_ ilce: String?)-> Void) {
        let userLocation =  CLLocation(latitude: getLocation.location.latitude, longitude: getLocation.location.longitude)
        print("get city 0")
        GetLocation.sharedInstance.connectionGPSExist = true
        let geoCoder = CLGeocoder()
        var sehir = ""
        var ilce = ""
        geoCoder.reverseGeocodeLocation(userLocation,
                                        completionHandler:
                                            { [self] placemarks, error in
            
            guard let place = placemarks?.first , error == nil else { return}
            
            
            print("getCity çalıştı completion ")
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
    func getData(forCity : String )
    {
        print("getdata 2 ")
        let gp = DispatchGroup()
    
        let url = URL(string: ("https://www.nosyapi.com/apiv2/pharmacyLink?apikey=x58j5AeEFXqvorUFG7X3o5QzGXqcThj8ncFGre0nucdVQYsuZKgfZ8ZKUf8y&city=" + (TurkishConverter().convertToLatin(word: forCity))))
      
        Webservice().downloadPharmacyInCity(url: (url)!) { pharmacyList in
            if let pharmacyList = pharmacyList {
                //3 burada da initilize et
             
                self.pharmacyOnDutyList = PharmacyListViewModel(pharmacy: pharmacyList)
                
                // tableview güncellemesi burada yapılır
                
                print("************WEEEE************")
                    
                print(self.pharmacyOnDutyList.numberOfDutyPharmacies())
                self.findDistanceForPharmacyOnDuty()
//                self.findDistanceForPharmacyOnDuty { eczaneStored in-
//                    self.pharmacyOnDuty = eczaneStored!
//                }
                
            
            }
           
            
        }
       
        
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
        
        // Apple MAp APİ'de 50 istek sınırı var. O nedenle sayının 50 yi geçmemesi lazım.
        print("find pharmacy 3")
        print("Find distance for  -->\(self.pharmacyOnDutyList.numberOfDutyPharmacies() )")
        print("location bilgisi \(getLocation.location)")
        
        if self.getLocation.eczaneStored.count > 0{
            getLocation.eczaneStored.removeAll()
            pharmacyOnDuty.removeAll()
        }
        /*
         asenkron task olduğu için taskın içinde yazılıyor Dikkat !
         */
        let grup = DispatchGroup()
        let  index = Int()
        var eczaneVeri = [EczaneVeri]()
       
        for index in 0...(self.pharmacyOnDutyList.numberOfDutyPharmacies() - 1 ) {
            grup.enter()
            let phar = self.pharmacyOnDutyList.pharmacyAtIndex(index)
            
            getDistance(sourceLocation: getLocation.location, endLocation: CLLocationCoordinate2DMake(
                phar.pharmacyLatitude, phar.pharmacyLongitude))
            
            
            { [self]  distance, travelTime  in
                
                
                if let distance = distance
                    
                    
                {  self.pharmacyOnDuty.append (EczaneVeri(pharmacyLatitude: phar.pharmacyLatitude, pharmacyLongitude: phar.pharmacyLongitude, pharmacyName: phar.pharmacyName,distance: distance ,travelTime: travelTime!,pharmacyCounty: phar.pharmacyCounty, phoneNumber: phar.pharmacyPhoneNumber ?? "Mevcut değil", pharmacyAddress: phar.pharmacyAddress))
                    
                
                    
                }
            
                //completion(eczaneVeri)
                else {
                    self.getLocation.connectionGPSExist  = false
                    //    print("\(String(describing: //)) hata var !")
                    return
                }
                // burada stored çalışıyorne
                self.getLocation.eczaneStored = pharmacyOnDuty
                self.changePinToDutyPharmacy(localPharmacies: self.nearByPharmacies, pharmacyOnDuty: self.getLocation.eczaneStored)
            }
           
          
        }// for end
       
            
           
           
       
//
//        self.getLocation.connectionGPSExist  = true
//
//
//        }
    }
    
    func getDistance (sourceLocation : CLLocationCoordinate2D, endLocation : CLLocationCoordinate2D,  completion: @escaping (_ distance: Double?,_ travelTime : String?) -> (Void))
    {
        let grup = DispatchGroup()
        
        let request = MKDirections.Request()
        
        let source = MKPlacemark( coordinate: sourceLocation)
            
         // //CLLocationCoordinate2D(latitude: 40.2145, longitude: 28.981821))
        // MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.2145, longitude: 28.981821))
        
        var msf : Double?
        var travelTime : String?
        
        let destination = MKPlacemark( coordinate: endLocation)
       // let source = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: source.latitude, longitude: source.longitude))
        request.source =  MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        //  print("request değerleri --> \(request.destination) \(destination.location?.coordinate)")
        request.transportType = MKDirectionsTransportType.automobile
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections ( request: request)
//        DispatchQueue.main.async {
            directions.calculate { (response, error) in
                
                if let error = error {
                    
                    print("Pharmacy --> \(destination.coordinate.latitude ) Distance directions calculation error\n \(error.localizedDescription)")
                     return
                }
                if let route = response?.routes {
                    let sortedRoutes = route.sorted(by: { $0.distance < $1.distance}) // en küçüğe göre sort ediyor
                    let shortestRoute = sortedRoutes.first // sonra o dizinin ilk elemanını alıyor, böylece en kısa mesafeyi buluş oluyor
                    msf = shortestRoute!.distance/1000
                    travelTime = String(format: "%.0f",shortestRoute!.expectedTravelTime/60)
                   // print("Pharmacy ok --> \(destination.title)")
                }
                completion  (msf,travelTime)
            }
//        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            print("height \(mapView.bounds.height)")
            print("width \(mapView.bounds.width)")
        } else {
            print("Portrait")
            print("height \(mapView.bounds.height)")
            print("width \(mapView.bounds.width)")
        }
    }
    
    
    func tutorialActivate(){
        
        //onboarding off burada yapılıyor
        if !(userDefault.getValueForSwitch(keyName: "firstUsage")!){
            UserDefaults().setValueForAllPharmacyOption(value: true, keyName: "firstUsage")
        }
        
        
        demandTutorial = false// tutorial isteğini sonlandırır
        // view dersen tabview olarak alıyor
        let tutorial = ["Bulunduğunuz konuma en yakın eczaneleri harita üzerinde gösterir","Bulunduğunuz şehirdeki, o güne ait nöbetçi eczaneleri listeler","Kullanım ile ilgili ayarlar ","Konumunuzu günceller"]
        
        //        mapView.alpha = 0.5
        //        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        //        //İmageView leri oluşturma
        nearPharmacyTab = UIImageView(frame: CGRect(x: mapView.bounds.width*0.025, y: mapView.bounds.height*0.99, width: mapView.bounds.width, height: 75))
        pharmacyDutyListTab = UIImageView(frame: CGRect(x: mapView.bounds.width*0.12, y: mapView.bounds.height*0.84, width: mapView.bounds.width, height: 75))
        settingsTab = UIImageView(frame: CGRect(x: mapView.bounds.width*0.250, y: mapView.bounds.height*0.84, width: mapView.bounds.width, height: 75))
        locateButton = UIImageView(frame: CGRect(x: 0, y: mapView.bounds.height*0.05, width: mapView.bounds.width, height: 75))
        let boxWidth = mapView.bounds.width*0.90
        print(boxWidth)
        // resimleri yerleştirme
        
        nearPharmacyTab.image = UIImage(named: "leftBottom")
        nearPharmacyTab.tintColor = UIColor(named: "ColorForTabsBallons")
        
        
        pharmacyDutyListTab.image = UIImage(named: "middle")
        pharmacyDutyListTab.tintColor = UIColor(named: "ColorForTabsBallons")
        settingsTab.image = UIImage(named: "rightbottom")
        settingsTab.tintColor = UIColor(named: "ColorForTabsBallons")
        locateButton.image = UIImage(named: "upperleft")
        locateButton.tintColor = UIColor(named: "ColorForTabsBallons")
        
        
        var nearPharmacyLabelText = UILabel(frame: CGRect(x: mapView.bounds.width*0.025, y: 0, width: mapView.bounds.width*0.94, height: 90))
        let pharmacyDutyListTabLabelText = UILabel(frame: CGRect(x: mapView.bounds.width*0.045, y: 0, width: boxWidth, height: 90))
        let settingsTabLabelText = UILabel(frame: CGRect(x: mapView.bounds.width*0.045, y: 0, width: boxWidth, height: 90))
        let locateButtonLabelText = UILabel(frame: CGRect(x: 50, y: 25, width: boxWidth, height: 90))
        
        
        nearPharmacyLabelText.text = tutorial[0]
        nearPharmacyLabelText.contentMode = .center
        nearPharmacyLabelText.numberOfLines = 0
        nearPharmacyLabelText.textAlignment = .left
        nearPharmacyLabelText.setMargins(10)
        nearPharmacyLabelText.textColor = UIColor(named: "TutorialColors")
        //  nearPharmacyLabelText.layer.borderWidth = 2
        //
        
        pharmacyDutyListTabLabelText.text = tutorial[1]
        pharmacyDutyListTabLabelText.contentMode = .scaleAspectFill
        pharmacyDutyListTabLabelText.numberOfLines = 0
        pharmacyDutyListTabLabelText.textAlignment = .center
        pharmacyDutyListTabLabelText.textColor = UIColor(named: "TutorialColors")
        pharmacyDutyListTabLabelText.setMargins(15)
        
        settingsTabLabelText.text = tutorial[2]
        settingsTabLabelText.contentMode = .scaleAspectFit
        settingsTabLabelText.numberOfLines = 0
        settingsTabLabelText.textAlignment = .center
        settingsTabLabelText.textColor = UIColor(named: "TutorialColors")
        settingsTabLabelText.setMargins(15)
        
        locateButtonLabelText.text = tutorial[3]
        locateButtonLabelText.contentMode = .scaleAspectFill
        locateButtonLabelText.numberOfLines = 0
        locateButtonLabelText.textAlignment = .center
        locateButtonLabelText.textColor = UIColor(named: "TutorialColors")
        locateButtonLabelText.setMargins(15)
        //        locateButtonLabelText.layer.borderWidth = 2
        
        nearPharmacyTab.addSubview(nearPharmacyLabelText)
        pharmacyDutyListTab.addSubview(pharmacyDutyListTabLabelText)
        settingsTab.addSubview(settingsTabLabelText)
        locateButton.addSubview(locateButtonLabelText)
        
        let nearPharmacytutorialImage = MyTapGesture(target: self, action: #selector(self.tappedImage))
        nearPharmacytutorialImage.title = "near"
        let pharmacyDutyListTabtutorialImage = MyTapGesture(target: self, action: #selector(self.tappedImage))
        pharmacyDutyListTabtutorialImage.title = "phar"
        let settingsTabtutorialImage = MyTapGesture(target: self, action: #selector(self.tappedImage))
        settingsTabtutorialImage.title = "sett"
        let locateButtontutorialImage = MyTapGesture (target: self, action: #selector(self.tappedImage))
        locateButtontutorialImage.title = "loca"
        
        nearPharmacytutorialImage.delegate = self
        pharmacyDutyListTabtutorialImage.delegate = self
        settingsTabtutorialImage.delegate = self
        locateButtontutorialImage.delegate = self
        
        
        nearPharmacyTab.addGestureRecognizer(nearPharmacytutorialImage)
        pharmacyDutyListTab.addGestureRecognizer(pharmacyDutyListTabtutorialImage)
        settingsTab.addGestureRecognizer(settingsTabtutorialImage)
        locateButton.addGestureRecognizer(locateButtontutorialImage)
        
        nearPharmacyTab.isUserInteractionEnabled = true
        pharmacyDutyListTab.isUserInteractionEnabled = true
        settingsTab.isUserInteractionEnabled = true
        locateButton.isUserInteractionEnabled = true
        
        nearPharmacyTab.isHidden = false
        settingsTab.isHidden = true
        locateButton.isHidden = true
        pharmacyDutyListTab.isHidden = true
        
        stackView.layoutMargins = .init(top: 0,
                                        left: 0,
                                        bottom: 0,
                                        right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing   = 16.0
        //stackView.layer.borderWidth = 2
        //stackView.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackViewUp.isLayoutMarginsRelativeArrangement = true
        stackViewUp.axis  = NSLayoutConstraint.Axis.horizontal
        
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackViewUp.axis = .horizontal
        stackViewUp.alignment = .center
        stackViewUp.spacing   = 0.0
        //stackViewUp.layer.borderWidth = 2
        //stackViewUp.layer.borderColor = CGColor(red: 255, green:255, blue: 0, alpha: 1)
        stackViewUp.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(nearPharmacyTab)
        stackView.addArrangedSubview(pharmacyDutyListTab)
        stackView.addArrangedSubview(settingsTab)
        
        
        stackView.isHidden = false
        
        stackViewUp.addArrangedSubview((locateButton))
        //
        
        // constraint labels
        self.view.addSubview(stackViewUp)
        
        stackViewUp.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 0).isActive = true
        stackViewUp.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: 0).isActive = true
        stackViewUp.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20).isActive = true
        stackViewUp.isHidden = false
        //tepeden 35 aşaıda olsun
        
        self.view.addSubview(stackView)
        
        //Constraints
        
        stackView.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 0).isActive = true
        
        
        showAnimate()
        
        
        /****************/
        
    }
    @objc func tappedImage (sender: MyTapGesture){
        
        var senderTitle = String()
        senderTitle = sender.title
        switch senderTitle {
        case "near":
            nearPharmacyTab.isHidden = true
            pharmacyDutyListTab.isHidden = false
            settingsTab.isHidden = true
            locateButton.isHidden = true
            break
        case "phar":
            nearPharmacyTab.isHidden = true
            pharmacyDutyListTab.isHidden = true
            settingsTab.isHidden = false
            locateButton.isHidden = true
            break
        case "sett":
            nearPharmacyTab.isHidden = true
            pharmacyDutyListTab.isHidden = true
            settingsTab.isHidden = true
            locateButton.isHidden = false
            break
        case "loca":
            nearPharmacyTab.isHidden = true
            pharmacyDutyListTab.isHidden = true
            settingsTab.isHidden = true
            locateButton.isHidden = true
            demandTutorial = true
            userDefault.setValueForAllPharmacyOption(value: false, keyName: "tutorial")

            stackViewUp.isHidden = true
            stackView.isHidden = true
            removeAnimate()
            
            
            break
        default:
            nearPharmacyTab.isHidden = false
            pharmacyDutyListTab.isHidden = true
            settingsTab.isHidden = true
            locateButton.isHidden = true
            
        }
    }
    
    func showAnimate()
    {
        
        //tabbar butonlarını kapat
        self.updateLocationButton.isEnabled = false
        self.tabBarController?.tabBar.items![1].isEnabled = false
        
        self.tabBarController?.tabBar.items![2].isEnabled = false
       
        self.mapView.isUserInteractionEnabled = false
        //animasyonu başlat
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.mapView.alpha = CGFloat(0.7)
          //  self.view.backgroundColor = UIColor.white.withAlphaComponent(1)
            
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        //tabbar butonlarını aktif et
        self.updateLocationButton.isEnabled = true
        self.tabBarController?.tabBar.items![1].isEnabled = true
        self.tabBarController?.tabBar.items![2].isEnabled = true
        self.mapView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.mapView.alpha = CGFloat(1)
            self.tabBarController?.tabBar.backgroundColor = UIColor(named: "OnboardingColor")
            //self.view.backgroundColor = UIColor.  white.withAlphaComponent(1)
            
        })
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
                    
                    
                    
               //     self.findDistanceForPharmacyOnDuty()
                    
                    
                }
            }
            
        }
      
        
    }
    /// web Api üzerinden veri çekme metodu
    /// - Parameter forCity: String
    func   findDistanceForPharmacyOnDuty(endLocation : CLLocationCoordinate2D , completion : @escaping (_ distance: Double?,_ travelTime: String?) -> (Void)){
        
        //    let group = DispatchGroup()
        //        group.enter()
        print("location bilgisi \(getLocation.location)")
        
        
        var dist : Double? = 0.0
        var traTime : String? = "0"
        
        getDistance(sourceLocation: getLocation.location, endLocation: endLocation)
        
        
        { distance, travelTime  in
            
            
            guard let distance = distance else {
                return  print("nil geldi")
                
            }
            dist = (distance)
            traTime = (travelTime!)
            //            group.leave()
        }
        
        //        group.notify(queue: .main){
        
        completion(dist,traTime)
        //        }
        //
        
    }
    
    
    func showSimpleAlert(title: String?,message: String?) {
        let alert = UIAlertController(title: title, message: message,         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        //            alert.addAction(UIAlertAction(title: "Sign out",
        //                                          style: UIAlertAction.Style.default,
        //                                          handler: {(_: UIAlertAction!) in
        //                                            //Sign out action
        //            }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    ///  User locatina göre yakınlardaki eczaneleri bulan fonksiyon.Bulduğu eczaneleri harita üzerine annotation olarak işler
    /// - Parameters:
    ///   - location: mevcut user location
    ///   - regionRadius: <#regionRadius description#>
    ///   - request.naturalLanguageQuery = "Eczaneler"   buradaki anahtar kelimeye göre arama yapar
    ///   - localPharmacies -> PharmacyNearByAnnotation objesidir. Daha sonra annotation olarak kullanabilmek için içine bulduğu eczanenin verilerini atar.
    func fetchPharmacyLocation(location : CLLocation,regionRadius : CLLocationDistance = 100000, pharmacyOnDuty : [EczaneVeri] ) {
        
        let group = DispatchGroup()
         
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
        
        query.start { [self] response
            , error in
            guard let response = response else {
                print( error)
                return
            }
            var travelTimeAnno = ""
            var distanceAnno = 0.0
//            group.enter()
            print("yakındaki eczane sayısı \(response.mapItems.count)")
            
            
            var itemLimit = 0  //==> en fazla 10 tane al
          
            for item in response.mapItems {
                guard itemLimit != 10 else {return} //==> en fazla 10 tane al
                if let name = item.name,let phoneNumber = item.phoneNumber  , let location = item.placemark.location {
                    
                    getDistance(sourceLocation: GetLocation.sharedInstance.location ,endLocation: location.coordinate)
                    { distance, travelTime in
                        if let travelTime = travelTime {
                            travelTimeAnno = travelTime
                            distanceAnno = distance!
                            //                                                print("\(name) --> \(distanceAnno)")
                        }
                        if let error = error {
                            print("yakındaki eczaneleri oluşutururken hata \(error.localizedDescription)")
                        }
                        let localPharmacies = (PharmacyNearByAnnotation(title: item.name, subtitle: item.phoneNumber, travelTime: travelTimeAnno + " dak.", distance: distanceAnno, coordinate: location.coordinate))
                        nearByPharmacies.append(localPharmacies)
                        addAnnotations(annos: nearByPharmacies)
                      }
                 }
                else {
                    print("hata var")
                }
                itemLimit += 1
                
            }//end loop
            print("Yakındaki eczane sayısı \(nearByPharmacies.count)")
//            group.leave()
//            group.notify(queue: .main){
//
//            }
//
            
        }
        
    }
    func   addNearestPharmacyToMap(){
        
       
        let bestPharmacyOption = (getLocation.eczaneStored).sorted(by:
                                                                { Double($0.travelTime!)!  < Double($1.travelTime! )! })
        let bestToShow = bestPharmacyOption.first
        
        let bestToShowAnnotation = PharmacyNearByAnnotation (title: bestToShow?.pharmacyName, subtitle: bestToShow?.phoneNumber, travelTime: bestToShow?.travelTime, distance: bestToShow?.distance, coordinate: CLLocationCoordinate2D(latitude: bestToShow!.pharmacyLatitude, longitude: bestToShow!.pharmacyLongitude))
        
        self.mapView.addAnnotation(bestToShowAnnotation)
        
        
           
            
        
    }
    func addAnnotations(annos : [PharmacyNearByAnnotation]){
        self.mapView?.addAnnotations(annos)
        
    }
    func addSingleAnnotation (coords: CLLocation ){
        let CLLCoordType = CLLocationCoordinate2D(latitude: coords.coordinate.latitude,
                                                  longitude: coords.coordinate.longitude);
        
        let anno = MKPointAnnotation();
        anno.coordinate = CLLCoordType;
        anno.title = "Buradasınız"
        self.mapView.addAnnotation(anno);
        
    }
    func changePinToDutyPharmacy(localPharmacies: [PharmacyNearByAnnotation], pharmacyOnDuty: [EczaneVeri]){
        for pharmacy in localPharmacies{
            for duty in pharmacyOnDuty {
                if  pharmacy.title == duty.pharmacyName{
                    
                    let newCenter = pharmacy.coordinate
                  circle = MKCircle(center: newCenter, radius: 100)
                    mapView.addOverlay(circle)
                }
                
            }
        }
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self){
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.green.withAlphaComponent(0.2)
            circleRenderer.strokeColor = UIColor.white
            circleRenderer.lineWidth = 1
           // circleRenderer.alpha = 0.7
            
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //MKAnnotationview döndürmek ister
        
        
        let phoneButton = PhoneCallButton(type: .custom)
        let button = CarButton(type: .custom)
        
        guard let annotation = annotation as? PharmacyNearByAnnotation else {
            let reuseId = "pin"
            let pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.markerTintColor = UIColor.red
            pinView.largeContentTitle = "Buradasınız"
            pinView.glyphTintColor = .blue
            return pinView
        }
        
        let reuseId = "MyAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        pinView = MKMarkerAnnotationView(annotation: annotation , reuseIdentifier: reuseId)
        pinView?.canShowCallout = true // baloncukla bilrlikte ekstra bilgi gösterir
        pinView?.glyphTintColor = .blue
        pinView?.glyphImage = UIImage(named: "pharmacyLogo.png")
        pinView?.markerTintColor = UIColor.white
        DispatchQueue.global().async { [self] in
            for duty in self.pharmacyOnDuty {
                if duty.pharmacyName == pinView?.annotation?.title
                {
                    pinView?.glyphTintColor = .red
                    circle2 = MKCircle(center: (pinView?.annotation!.coordinate)!, radius: 100)
                    DispatchQueue.main.async {
                        mapView.addOverlay(circle2)
                    }
                    
                }
            }
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
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
        if CLLocationManager.locationServicesEnabled() == false
        {
            CheckGPSSignal().alert(title: "Konum", message: "Konum bilgisi yok ⚠️")
            
            
         
            
        }
           
    }
    
    @objc func turnOnAllPharmacyOption (){
        
        if userDefault.getValueForSwitch(keyName: "tutorial") == true {
            demandTutorial = true
            
            
        }else {
            demandTutorial = false
            
        }
    }
    
    @objc func chooseLocation(gestureRecognizer:UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == .began
        {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            choosenLatitude = touchedCoordinates.latitude
            choosenLongtitude = touchedCoordinates.longitude
            
           
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
class MyTapGesture: UITapGestureRecognizer {
    var title = String()
}
extension UILabel {
    func setMargins(_ margin: CGFloat = 10) {
        if let textString = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
