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
    var selectedTitle = ""
    var selectedTitleID: UUID?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
