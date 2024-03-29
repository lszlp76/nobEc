//
//  ChoosenLocationViewViewController.swift
//  travelguide
//
//  Created by ulas özalp on 29.06.2022.
//

import UIKit
import MapKit
class ChoosenLocationViewViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate ,UIGestureRecognizerDelegate{
    var annotationTitle = ""
    var annotationSubtitle = ""
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    var annotationTravelTime = String()
    var annotationPhoneNumber = String()
    var userLocation = CLLocation()
    var selectedTitle = ""
    var selectedTitleID: UUID?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
      
        let  locaManager = LocationManager.shared
        let selectedCoordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
//
     locaManager.getUserLocation { [self] location in

           self.userLocation = CLLocation (latitude: location.coordinate.latitude,longitude: location.coordinate.longitude)
       
         let annotation = PharmacyNearByAnnotation(title: annotationTitle, subtitle: annotationSubtitle, travelTime: annotationTravelTime, distance: 0.0, coordinate: selectedCoordinate, isOnDuty: true)
     //
                       annotation.title = annotationTitle
              annotation.subtitle = annotationPhoneNumber
     //        annotation.coordinate = selectedCoordinate
             let annos = [annotation]
              mapView.delegate = self
             self.mapView.addAnnotations(annos)
            
             //zoomlamak için
             mapView.selectAnnotation(mapView.annotations[0], animated: true)
         
         let userLocationAnnotation = MKPointAnnotation()
         print(userLocation)
         userLocationAnnotation.coordinate = userLocation.coordinate
         userLocationAnnotation.title = "Buradasınız"
         self.mapView.addAnnotation(userLocationAnnotation)

     
     
         self.mapView.showRouteOnMap(pickupCoordinate: self.userLocation.coordinate, destinationCoordinate: selectedCoordinate)
     }
//
//
      
//        print(annotationTitle,annotationLatitude,annotationLongitude)
   
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        let region = MKCoordinateRegion(center: selectedCoordinate, span: span)
        
        mapView.setRegion(region, animated: true)
       
       
    }
    @objc func findNearPharmacy(gestureRecognizer : UIGestureRecognizer) {
        let title = "NöbEc ➡️ \(annotationTitle)"
        let icon = UIImage(named: "pharmacyRedLogo")
        let text = ("https://maps.apple.com/?daddr=\(annotationLatitude),\(annotationLongitude)")

                // set up activity view controller
                let textToShare: [Any] = [
                    MyActivityItemSource( title: title, text: text, icon: icon )
                ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        if  ((activityViewController.popoverPresentationController) != nil){
                          activityViewController.popoverPresentationController?.sourceView = self.view
                          activityViewController.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.midX, y: self.view.bounds.midY, width: 0,height: 0)
                      }
          self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //MKAnnotationview döndürmek ister
        
        let phoneButton = PhoneCallButton(type: .custom)
        
        
        if annotation is MKPointAnnotation
        {
            let reuseId = "pin"
            let pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.markerTintColor = UIColor.yellow
            pinView.glyphTintColor = .blue
            return pinView
        }
        let reuseId = "MyAnnotation"
        var pinView :PharmacyView
        if let dequeudView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        {
            dequeudView.annotation = annotation
            pinView = dequeudView as! PharmacyView
        }
        else {
            pinView = PharmacyView (annotation: annotation, reuseIdentifier: reuseId)
            let smallSquare = CGSize(width: 50, height: 30)
            let view = UIView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 50, height: 50)))
            let labelView = UILabel(frame: CGRect(origin: CGPoint(x: 0.0, y: 30.0), size: CGSize(width: 50, height: 20)))
            let button = UIButton(frame: CGRect(origin: CGPoint(x: 00.0, y:0.0), size: smallSquare))
                   //        UIButton(type : UIButton.ButtonType.detailDisclosure)
            
            
            
            let viewPhone = UIView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 50, height: 50)))
            //  let labelViewPhoneNumber = UILabel(frame: CGRect(origin: CGPoint(x: 00.0, y: 30.0), size: CGSize(width: 80, height: 20)))
            
            phoneButton.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 50, height: 50))
            viewPhone.backgroundColor = .blue
            phoneButton.setBackgroundImage(UIImage(systemName: "phone"), for: .normal)
            button.setBackgroundImage(UIImage(systemName: "car"), for: .normal)
            //     button.addTarget(self, action: #selector(ViewController.getDirections), forControlEvents: .TouchUpInside)
            
            
            button.tintColor = .white
            button.backgroundColor = .blue
            
            button.addTarget(self, action: #selector(gotoPharmacy(sender: )), for: .touchUpInside)
            
            phoneButton.tintColor = .white
            phoneButton.backgroundColor = .blue
            phoneButton.phoneNumber = annotationPhoneNumber
            phoneButton.addTarget(self, action: #selector(callPhoneNumber(sender:)), for: .touchUpInside)
            view.backgroundColor = .orange
            viewPhone.backgroundColor = .orange
            labelView.text = (annotationTravelTime) + " dak."
            labelView.font = UIFont(name: "arial", size: 14)
            labelView.textColor = .white
            labelView.textAlignment = .center
            labelView.backgroundColor = .blue
           
            button.addSubview(labelView)
            
            view.addSubview(button)
            viewPhone.addSubview(phoneButton)
     
            pinView.leftCalloutAccessoryView = view
            pinView.rightCalloutAccessoryView = viewPhone
          
            let choosenLocationTap =  UILongPressGestureRecognizer ( target: self, action: #selector(findNearPharmacy(gestureRecognizer: )))
            choosenLocationTap.delegate = self
            choosenLocationTap.minimumPressDuration = 1
            pinView.addGestureRecognizer(choosenLocationTap)
           
        }
        
        return pinView
    }
    
    @objc func callPhoneNumber (sender: PhoneCallButton) {
        print("tel://\(sender.phoneNumber)")
        if let phoneCallURL = URL(string: "tel://\(sender.phoneNumber)") {
        //if let phoneCallURL = URL(string: "www.google.com") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler:  { error in
                    
                    if error != nil {
                        print("telefon \(error)")
                        return
                    }
                  
                })
            }
        }
    }
    /**Annotation view penceresinin genişliğini V:[snapshotView(200)] içindeki değer kadar yapar.
     */
    func configureDetailView(annotationView: MKAnnotationView) -> UIView {
        let snapshotView = UIView()
        let views = ["snapshotView": snapshotView]
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(20)]", options: [], metrics: nil, views: views))
        //do your work
        return snapshotView
    }
    @objc func gotoPharmacy(sender: CarButton) {
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
    /**
     alt taraf kullanılmayacak. BUton yerine view atadığın için callOutcalşmıyor, addTaget ile yapmak durumunda kalıyorsun
     
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
     */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.fillColor = UIColor.yellow
        renderer.lineWidth = 10.0
        return renderer
    }
    
}
extension MKMapView {

  func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
    let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
    let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
    
    let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
    
    let sourceAnnotation = MKPointAnnotation()
    
    if let location = sourcePlacemark.location {
        sourceAnnotation.coordinate = location.coordinate
    }
    
    let destinationAnnotation = MKPointAnnotation()
    
    if let location = destinationPlacemark.location {
        destinationAnnotation.coordinate = location.coordinate
    }
    
    self.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
    
    let directionRequest = MKDirections.Request()
    directionRequest.source = sourceMapItem
    directionRequest.destination = destinationMapItem
      directionRequest.requestsAlternateRoutes = true
    directionRequest.transportType = .automobile
    
    // Calculate the direction
    let directions = MKDirections(request: directionRequest)
    
    directions.calculate {
        (response, error) -> Void in
        
        guard let response = response else {
            if let error = error {
                print("Error: \(error)")
            }
            
            return
        }
         let route = response.routes
            let sortedRoutes = route.sorted(by: { $0.distance < $1.distance}) // en küçüğe göre sort ediyor
            let shortestRoute = sortedRoutes.first // sonra o dizinin ilk elemanını alıyor, böylece en kısa mesafeyi buluş oluyor
            
        
        self.addOverlay((shortestRoute?.polyline) as! MKOverlay, level: MKOverlayLevel.aboveRoads)
        let rect = shortestRoute!.polyline.boundingMapRect
        self.setRegion(MKCoordinateRegion(rect), animated: true)
    }
}}

