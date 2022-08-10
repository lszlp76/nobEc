#  <#Title#>

/--> çözüldü !1. fiziksel cihazda liste tekrar ederek geliyor  ----> requestLocation yaparsan çözülüyor. problem startUpdateLocations kendini yenilemesi. --> ÇÖZÜM :
       private var didPerformGeocode = false
     func (....)
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
        
        
2. sık sık gps kesintisi oluyor
/--> çözüldü ! 3. telefon arama pital edilirse app çöküyor
/--> çözüldü ! 4. araç git butonu çalışmıypr
/--> çözüldü ! 5. gps kesilince tekrar çalışmıyor --> güncelleme bayrağı koyuldu. Ikon yeri şekli değişecek
/--> çözüldü ! 6. telefon numarasını değiştirmeyi unutma
/--> çözüldü ! 7. konumları paylaşma koyulacak
/--> çözüldü ! 8.eczanelere ikonkoy
/--> çözüldü ! 9. eczane listesi eklenebilir mi? Nöbetçi olmayanları da göstermek için

/--> çözüldü ! 10. ana sayfaya travel time taşınacak
/--> çözüldü ! 11. tabbar başlıklarını değiştir
/--> çözüldü ! 12. tüm eczaneler seçeneğini tüm nöbetçi eczanler olarak değşitir
https://maps.apple.com/?address=Bah%C3%A7e%20Sk.,%2016225%20Nil%C3%BCfer%20Bursa,%20T%C3%BCrkiye&ll=40.268807,28.945706&q=Konumum&_ext=EiYpWWYLoM8hREAxeXeFfobwPEA51zsx/PUiREBBsXu2DorzPEBQBA%3D%3D


do {
    // 1. Call the method
    let images = try await fetchImages()
    // 2. Fetch images method returns
    
    // 3. Call the resize method
    let resizedImages = try await resizeImages(images)
    // 4. Resize method returns
    
    print("Fetched \(images.count) images.")
} catch {
    print("Fetching images failed with error \(error)")
}
// 5. The calling method exits




  view için    
https://stackoverflow.com/questions/8882402/transparent-view-on-another-transparent-uiview-with-non-transparent-content


https://stackoverflow.com/questions/25203556/returning-data-from-async-call-in-swift-function
Return inside the notify is void it's scope is different than the function , You need a completion

func returnSomeValue(completion:@escaping((String) -> ())) {
    let group = DispatchGroup()
    group.enter()
    service.longTimeTofinish(onFinish: { group.leave() } ) // <-- this function takes long time to finish

    group.notify(queue: .main) {
        completion("Returning some value as example")
    }
}
Or what is more common

func returnSomeValue(completion:@escaping((String) ->())) { 
    service.longTimeTofinish(onFinish: { completion("Returning some value as example") } )  
}



        let constraint = NSLayoutConstraint(
            item: view, attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: view, attribute: NSLayoutConstraint.Attribute.width,
             multiplier: 3, constant: 0.0)
        let backgroundImage = UIImage(named: "back")
        let backgroundImageView = Init(UIImageView(frame: CGRect.zero)) {
            $0.contentMode = .scaleAspectFill
            $0.layer.borderWidth = 3
            $0.addConstraint(constraint)
            $0.image = backgroundImage
            $0.translatesAutoresizingMaskIntoConstraints = false
        }



0x104487aa8

Thread 8 Crashed:
0   travelguide                              0x104fe3f20 ViewController.findDistanceForPharmacyOnDuty() + 98080 (ViewController.swift:445)
1   travelguide                              0x104fe3c68 ViewController.findDistanceForPharmacyOnDuty() + 97384 (ViewController.swift:445)
2   travelguide                              0x104fe39a0 closure #1 in ViewController.getData(forCity:) + 96672 (ViewController.swift:415)
3   travelguide                              0x104fd8bf8 closure #1 in Webservice.downloadPharmacyInCity(url:completion:) + 52216 (Webservice.swift:0)
4   travelguide                              0x104fd8894 thunk for @escaping @callee_guaranteed (@guaranteed Data?, @guaranteed NSURLResponse?, @guaranteed Error?) -> () + 51348 (<compiler-generated>:0)
5   CFNetwork                                0x18142eb6c 0x18140c000 + 142188
6   CFNetwork                                0x18143fd80 0x18140c000 + 212352
7   libdispatch.dylib                        0x1808e7e6c _dispatch_call_block_and_release + 32
8   libdispatch.dylib                        0x1808e9a30 _dispatch_client_callout + 20
9   libdispatch.dylib                        0x1808f1124 _dispatch_lane_serial_drain + 668
10  libdispatch.dylib                        0x1808f1cb4 _dispatch_lane_invoke + 444
11  libdispatch.dylib                        0x1808fc500 _dispatch_workloop_worker_thread + 648
12  libsystem_pthread.dylib                  0x1f0c6d0bc _pthread_wqthread + 288
13  libsystem_pthread.dylib                  0x1f0c6ce5c start_wqthread + 8

