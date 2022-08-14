//
//  FirstViewController.swift
//  travelguide
//
//  Created by ulas özalp on 18.06.2022.
//

import UIKit

import CoreLocation
import MapKit

class FirstViewController: UIViewController , UITableViewDelegate,
                           CLLocationManagerDelegate,UITableViewDataSource,MKMapViewDelegate, UIGestureRecognizerDelegate,UISearchBarDelegate, UISearchResultsUpdating
{
    
    
    /**
     --> Nöbetçi eczaneyi share etme olmalı, uzun basınca share etsin
     */
    
    
    
    
    let refreshControl = UIRefreshControl() // pulldown
    let getLocation = GetLocation.sharedInstance
    var choosenTitle = ""
    var choosenTitleID : UUID?
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    var choosenTravelTime = String()
    var choosehPhoneNumber = String()
    var eczaneStored = [EczaneVeri]() // tüm eczaneleri gösterir
    var eczaneStoredByCounty = [EczaneVeri]() // ilçeye göre süzülmüş hali
    var eczaneStoredFull = [EczaneVeri]() // URL'den gelen tam veri
   var dateString = String()
    /*** search METODU */
    let searchPharmacyByCounty = UISearchController()
 
    var filteredPharmacy = [EczaneVeri]()
    
   
    @IBOutlet weak var tableView: UITableView!
   
    
    override func viewWillAppear(_ animated: Bool) {
    
        eczaneStored.removeAll()
        eczaneStoredByCounty.removeAll()
        eczaneStoredFull.removeAll()
        view.backgroundColor = UIColor(named: "OnboardingColor")
        
      
        
        initSearchController()
        
        if eczaneStoredFull.count != nil{
           
         
            eczaneStoredFull = (getLocation.eczaneStored).sorted(by:
                                                                    { Double($0.travelTime!)!  < Double($1.travelTime! )! }) // en yakın 1nci sıraya yazdırma
        }
//        if UserDefaults.standard.bool(forKey: "allPharmacyOption")  == true {
            
            eczaneStored = eczaneStoredFull
        
//        }
//        else {
//            eczaneStoredFull = (GetLocation.sharedInstance.eczaneStored).sorted(by: {$0.distance < $1.distance}) // en yakın 1nci sıraya yazdırma
//            print("eczaneStoredFull \(eczaneStoredFull)")
//            print(eczaneStoredFull.count)
//            for eczane in eczaneStoredFull {
//
//                if (eczane.pharmacyCounty == GetLocation.sharedInstance.county) {
//                    eczaneStoredByCounty.append(eczane)
//                    eczaneStoredByCounty = eczaneStoredByCounty.sorted(by: {$0.distance < $1.distance}) // en yakın 1nci sıraya yazdırma
//                    print(GetLocation.sharedInstance.county)
//
//                }
//
//               eczaneStored = eczaneStoredByCounty
//            }
//        }
   
        
        let longPressGesture: MyLongGestureRecongnizer = MyLongGestureRecongnizer (target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        tableView.backgroundColor = UIColor(named: "OnboardingColor")
        tableView.delegate = self
        tableView.dataSource = self
       
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        //let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText)//, scopeButton: scopeButton)
        
    }
    // https://www.youtube.com/watch?v=DAHG0orOxKo
    func filterForSearchTextAndScopeButton ( searchText: String ){ //, scopeButton : String = "All"){
//        if (scopeButton != "Favorites") {
            filteredPharmacy = eczaneStored.filter
            { pharmacy in
                
                
                
//                   let  scopeMatch = (scopeButton == "All")
                    if ( searchPharmacyByCounty.searchBar.text != "")
                    {
                        let searchTextMatch = pharmacy.pharmacyCounty.lowercased().contains(searchText.lowercased())
                        return searchTextMatch //&& scopeMatch
                    }
                    
                    else
                    {
                        
                        return true
                    }
                }
        self.tableView.reloadData()
//        }else
//        { print ("bookmark")
//
//            filteredPharmacy = eczaneStored.filter
//
//            { pharmacy in
//
//
//                let  scopeMatch = (scopeButton == "Favorites" )
//                    if ( searchPharmacyByCounty.searchBar.text != "" )
//                    {
//                        let searchTextMatch =  pharmacy.pharmacyCounty.lowercased().contains(searchText.lowercased() )
//
//                        return searchTextMatch && scopeMatch
//                    }
//
//                    else
//                    {
//                        // bookmarkları döndürmek için
//
//                        return scopeMatch
//                    }
//                }
//
//
//c
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if ( searchPharmacyByCounty.isActive){
            choosenTitle = filteredPharmacy[indexPath.row].pharmacyName
            choosenLatitude = filteredPharmacy[indexPath.row].pharmacyLatitude
            choosenLongitude = filteredPharmacy[indexPath.row].pharmacyLongitude
            choosenTravelTime = filteredPharmacy[indexPath.row].travelTime ?? "0"
            choosehPhoneNumber = filteredPharmacy[indexPath.row].phoneNumber
            
            performSegue(withIdentifier: "toChoosenLocation", sender: nil)
        
       
        }else {
            choosenTitle = eczaneStored[indexPath.row].pharmacyName
            choosenLatitude = eczaneStored[indexPath.row].pharmacyLatitude
            choosenLongitude = eczaneStored[indexPath.row].pharmacyLongitude
            choosenTravelTime = eczaneStored[indexPath.row].travelTime ?? "0"
            choosehPhoneNumber = eczaneStored[indexPath.row].phoneNumber
            
            performSegue(withIdentifier: "toChoosenLocation", sender: nil)
        
       
        }
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
            if segue.identifier == "toChoosenLocation" {
                let destinationVC = segue.destination as! ChoosenLocationViewViewController
                destinationVC.selectedTitle = choosenTitle
                destinationVC.annotationTitle = choosenTitle
                destinationVC.annotationLatitude = choosenLatitude
                destinationVC.annotationLongitude = choosenLongitude
                destinationVC.annotationTravelTime = choosenTravelTime
                destinationVC.annotationPhoneNumber = choosehPhoneNumber
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("eczaneStoredFull --> \(eczaneStoredFull.count)")
        print("eczaneStored --> \(eczaneStored.count)")
        print("eczaneStoredByCounty --> \(eczaneStoredByCounty.count)")
        if (searchPharmacyByCounty.isActive){
            return filteredPharmacy.count
        }
        
        return eczaneStored.count
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
            header.textLabel?.textColor = UIColor.init(named: "SpesificColor")
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            header.textLabel?.frame = header.bounds
            header.textLabel?.textAlignment = .left
     
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let headerTitles = "  \(dateString) NÖBETÇİ ECZANELER"
    
        return headerTitles
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundColor = UIColor(named: "OnboardingColor")
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       
      
     
        tableView.rowHeight = 100
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellModel
        cell.pharmacyNameText.font = UIFont.boldSystemFont(ofSize: 21.0)
        cell.pharmacyNameText.textColor = UIColor.init(named: "ColorForListView")
        cell.phoneNumberText.textColor = UIColor.init(named: "ColorForListView")
        cell.distanceText.textColor = UIColor.init(named: "ColorForListView")
        cell.timeText.textColor = UIColor.init(named: "ColorForListView")
        cell.countyText.textColor = UIColor.init(named: "ColorForListView")
        cell.backgroundColor = UIColor(named: "OnboardingColor")
       
        if (searchPharmacyByCounty.isActive) {
//            let filteredIndex = filteredPharmacy.firstIndex(where: { $0.pharmacyName.hasPrefix(eczaneStored[indexPath.row].pharmacyName)
//             })
            cell.pharmacyNameText.text = filteredPharmacy[indexPath.row].pharmacyName
            cell.phoneNumberText.text = filteredPharmacy[indexPath.row].phoneNumber
            cell.countyText.text = filteredPharmacy[indexPath.row].pharmacyCounty
            cell.timeText.text = filteredPharmacy[indexPath.row].travelTime! + " dak."
            cell.distanceText.text = String(format: "%.1f", filteredPharmacy[indexPath.row].distance as! CVarArg) + " km"
           
        }else {
            cell.pharmacyNameText.text = eczaneStored[indexPath.row].pharmacyName
        cell.phoneNumberText.text = eczaneStored[indexPath.row].phoneNumber
        cell.countyText.text = eczaneStored[indexPath.row].pharmacyCounty
        cell.timeText.text = eczaneStored[indexPath.row].travelTime! + " dak."
        cell.distanceText.text = String(format: "%.1f", eczaneStored[indexPath.row].distance as! CVarArg) + " km"
        }


        return cell
                                                         }
    override func viewDidLoad() {
       
         
      
    
        let dateFormatter : DateFormatter = DateFormatter()
        //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "dd-MMM-YYYY"
        let date = Date()
        dateString = dateFormatter.string(from: date)
       if let navigationBar = self.navigationController?.navigationBar {
//            let firstFrame = CGRect(x:navigationBar.frame.width/2, y: navigationBar.frame.height, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
//
//            let firstLabel = UILabel(frame: firstFrame)
//            firstLabel.alignmentRect(forFrame: firstFrame)
//            firstLabel.text = dateString
//            firstLabel.textAlignment = .right
            //firstLabel.layer.borderWidth = 1.0
           // firstLabel.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 0, alpha: 1)

//            firstLabel.font = UIFont(name: "Arial", size: 18)
//            firstLabel.textColor =  UIColor.init(named: "SpesificColor")
        //  navigationBar.addSubview(firstLabel)
        
        navigationBar.backgroundColor = UIColor(named: "OnboardingColor")
            
        
        }
    }
    @objc func longPress(_ longPressGestureRecognizer : MyLongGestureRecongnizer){
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            // Make the activityViewContoller which shows the share-view
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
           
            if let indexPath = tableView.indexPathForRow(at: touchPoint){
                
                
               
                let title = "NöbEc ➡️ \(eczaneStored[indexPath.row].pharmacyName)"
                let icon = UIImage(named: "pharmacyRedLogo")
                let url = ("https://maps.apple.com/?daddr=\(eczaneStored[indexPath.row].pharmacyLatitude),\(eczaneStored[indexPath.row].pharmacyLongitude)")
                let textToShare: [Any] = [
                    MyActivityItemSource( title: title, text: url, icon: icon )
                ]
              
                let activityViewController = UIActivityViewController(activityItems: textToShare ,applicationActivities: nil)
               
                /*
                 Share menu if user's Ipad is active
                 */
                if  ((activityViewController.popoverPresentationController) != nil){
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    activityViewController.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.midX, y: self.view.bounds.midY, width: 0,height: 0)
                }
                // Show the share-view
                self.present(activityViewController, animated: true, completion: nil)
            }
            }
       
    
            }
    
    func listRenew()-> [EczaneVeri] {
        
        
        let index : Int
        var dist : Double?
        var trav : String?
        var new = [EczaneVeri]()
        eczaneStored = getLocation.eczaneStored
        for index in 0...eczaneStored.count - 1
        {
            
            
            self.findDistanceForPharmacyOnDuty(endLocation: CLLocationCoordinate2DMake(eczaneStored[index].pharmacyLatitude, eczaneStored[index].pharmacyLongitude))
            { distance, travelTime in
                dist = distance
                trav = travelTime
            }
           
            
            let newEczaneStored = (EczaneVeri(pharmacyLatitude: eczaneStored[index].pharmacyLatitude, pharmacyLongitude: eczaneStored[index].pharmacyLongitude, pharmacyName: eczaneStored[index].pharmacyName, distance: dist, travelTime: trav, pharmacyCounty: eczaneStored[index].pharmacyCounty, phoneNumber: eczaneStored[index].phoneNumber, pharmacyAddress: eczaneStored[index].pharmacyAddress))
            new.append(newEczaneStored)
        }
       new = (new).sorted(by: {$0.distance ?? 0.0 < $1.distance ??  0.0})
       return new
        
    }
       
                        
   
    func   findDistanceForPharmacyOnDuty(endLocation : CLLocationCoordinate2D , completion : @escaping (_ distance: Double?,_ travelTime: String?) -> (Void)){
        
    let group = DispatchGroup()
        group.enter()
        print("location bilgisi \(getLocation.location)")
        
     
        var dist : Double? = 0.0
        var traTime : String? = "0"
          
            getDistance(sourceLocation: getLocation.location, endLocation: endLocation)
           
       
        { distance, travelTime, error  in
                
              
            guard let distance = distance else {
               return  print("nil geldi")
                
            }
            dist = (distance)
            traTime = (travelTime!)
            group.leave()
        }
        
        group.notify(queue: .main){
            
          completion(dist,traTime)
        }
       
          
        }

    func getDistance (sourceLocation : CLLocationCoordinate2D, endLocation : CLLocationCoordinate2D,  completion: @escaping (_ distance: Double?,_ travelTime : String?,_ error : Error?) -> (Void))
    {
  
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
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections ( request: request)
    
            directions.calculate { (response, error) in
                
                if let error = error {
                    
                    print("Distance directions error destination \n \(error.localizedDescription)")
                    return
                }
                if let route = response?.routes {
                    let sortedRoutes = route.sorted(by: { $0.distance < $1.distance}) // en küçüğe göre sort ediyor
                    let shortestRoute = sortedRoutes.first // sonra o dizinin ilk elemanını alıyor, böylece en kısa mesafeyi buluş oluyor
                    msf = shortestRoute!.distance/1000
                    travelTime = String(format: "%.0f",shortestRoute!.expectedTravelTime/60)
                    
                }
                completion  (msf,travelTime, error)
            
        }
    }
    func initSearchController(){
        searchPharmacyByCounty.loadViewIfNeeded()
        searchPharmacyByCounty.searchResultsUpdater = self
        searchPharmacyByCounty.obscuresBackgroundDuringPresentation = false
        searchPharmacyByCounty.searchBar.enablesReturnKeyAutomatically = false
        searchPharmacyByCounty.searchBar.returnKeyType = UIReturnKeyType.done
        
        definesPresentationContext = true
        
        //searchPlant.searchBar.placeholder = "ara"
        searchPharmacyByCounty.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "İlçe seçimi...", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "ColorForListView")])
       //searchBar içindeki yazarken renk tanımı
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        searchPharmacyByCounty.searchBar.tintColor = UIColor(named: "ColorForListView")
        searchPharmacyByCounty.searchBar.searchTextField.textColor = .green
     
     
        searchPharmacyByCounty.searchBar.barStyle = .black
        navigationItem.searchController = searchPharmacyByCounty
        navigationItem.hidesSearchBarWhenScrolling = false
      //  searchPharmacyByCounty.searchBar.scopeButtonTitles = ["All","Favorites"]
        searchPharmacyByCounty.searchBar.delegate = self
        
    }
   
        }
    
