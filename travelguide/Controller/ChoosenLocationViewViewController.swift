//
//  ChoosenLocationViewViewController.swift
//  travelguide
//
//  Created by ulas özalp on 29.06.2022.
//

import UIKit
import MapKit
class ChoosenLocationViewViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var annotationTitle = ""
    var annotationSubtitle = ""
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    var annotationTravelTime = String()
    var annotationPhoneNumber = String()
    
    var selectedTitle = ""
    var selectedTitleID: UUID?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        print(annotationTitle,annotationLatitude,annotationLongitude)
        let annotation = MKPointAnnotation()
        let title = String(annotationTitle + "\n" + annotationPhoneNumber)
        print("başlık \(title)")
        
        annotation.title = annotationTitle
        annotation.subtitle = annotationPhoneNumber
        let selectedCoordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
        annotation.coordinate = selectedCoordinate
        self.mapView.addAnnotation(annotation)
        //zoomlamak için
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        let region = MKCoordinateRegion(center: selectedCoordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    /*
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     let annotationIdentifier = "MyCustomAnnotation"
     guard !annotation.isKind(of: MKUserLocation.self) else {
     return nil
     }
     
     var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
     if annotationView == nil {
     annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
     if case let annotationView as CustomAnnotationView = annotationView {
     annotationView.isEnabled = true
     annotationView.canShowCallout = false
     annotationView.label = UILabel(frame: CGRect(x: -5.5, y: 11.0, width: 22.0, height: 16.5))
     if let label = annotationView.label {
     label.font = UIFont(name: "HelveticaNeue", size: 16.0)
     label.textAlignment = .center
     label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
     label.adjustsFontSizeToFitWidth = true
     annotationView.addSubview(label)
     }
     }
     }
     
     if case let annotationView as CustomAnnotationView = annotationView {
     annotationView.annotation = annotation
     annotationView.image = #imageLiteral(resourceName: "YourPinImage")
     if let title = annotation.title,
     let label = annotationView.label {
     label.text = title
     }
     }
     
     return annotationView
     
     
     
     
     }
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //MKAnnotationview döndürmek ister
        
        let phoneButton = PhoneCallButton(type: .custom)
        
        
        if annotation is MKUserLocation {
             // kullanıcı yerini pin le göstermek istemezsen
        }
        let reuseId = "MyAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true// baloncukla bilrlikte ekstra bilgi gösterir
            pinView?.autoresizesSubviews = true
            pinView?.tintColor = UIColor.purple
            // let button1 = UIButton(type: UIButton.ButtonType.detailDisclosure)
            
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
            
            button.addTarget(self, action: #selector(goToPharmacy), for: .touchUpInside)
            
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
            // labelView.center = CGPoint(x: view.center.x, y: view.center.y)
            //önce butonu label view un üstüne ekle
            
            
            button.addSubview(labelView)
            
            view.addSubview(button)
            viewPhone.addSubview(phoneButton)
            
            //  pinView!.detailCalloutAccessoryView = self.configureDetailView(annotationView: pinView!)
            pinView?.leftCalloutAccessoryView = view
            pinView?.rightCalloutAccessoryView = viewPhone
            
            //pinView?.addSubview(labelView)
            //pinView?.addSubview(view)
            // pinView?.addSubview(labelViewPhoneNumber)
            //pinView?.addSubview(labelViewPhoneNumber)
            //   labelViewPhoneNumber.leadingAnchor.constraint(equalTo: phoneButton.trailingAnchor, constant: 10).isActive = true
            
            /*10
             labelView.bottomAnchor.constraint(equalTo: pinView!.bottomAnchor).isActive = true
             labelView.leftAnchor.constraint(equalTo: pinView!.leftAnchor, constant: 5).isActive = true
             labelView.rightAnchor.constraint(equalTo: pinView!.rightAnchor, constant: -5).isActive = true
             
             
             
             */
            
            
            // callout içindeki buton basıldığında callOutAccesoryControltapped çalışır
            /*
             ancak burada button yerine view atadık, o nedenle çalışmıyor, adDtarget ile düzelttik.
             */
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    @objc func callPhoneNumber (sender: PhoneCallButton) {
        
        if let phoneCallURL = URL(string: "tel://\(sender.phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
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
    @objc func goToPharmacy() {
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
    
    
}
