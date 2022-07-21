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




      
      Sinanoğlu Eczanesi sourceLocation : CLLocationCoordinate2D(latitude: 40.213718409999984, longitude: 28.976757039999985) 
 endLocation: CLLocationCoordinate2D(latitude: 40.212577, longitude: 28.975281))
      
source location : CLLocationCoordinate2D(latitude: 40.213718409999984, longitude: 28.976757039999985) 
 endLocation : CLLocationCoordinate2D(latitude: 40.4209095, longitude: 29.1583118) 

Eczane Derya Gülpınar
Ferzan Eczanesi
Kansu Eczanesi
Barbaros Eczanesi
Lale Eczanesi
Yalvaç Eczanesi
Sinanoğlu Eczanesi
Sevde Nur Eczanesi
Akide Eczanesi
Bursa Başak Eczanesi
Yeni Hayat Eczanesi
Anıtsal Eczanesi
Bursalı Eczanesi
Anadolu Burcu Eczanesi
Nurdan Eczanesi
Bayramdere Boğaz Eczanesi
Petek Eczanesi
Sinanoğlu Eczanesi
İkincibahar Eczanesi
Özlem Tatallar Eczanesi
Ada Eczanesi
Betül Eczanesi
Birsen Eczanesi
Sanat Eczanesi
Beşevler Bulut Eczanesi

2022-07-17 20:01:10.003000+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.003085+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.003111+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.003133+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.003696+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.003752+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.003773+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.003824+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.004225+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.004257+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.004278+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.004298+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.004708+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.004756+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.004821+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.004912+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.005456+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.005499+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.005520+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.005546+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.005872+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.005900+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.005919+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.005938+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.006247+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.006269+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.006288+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.006306+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.006638+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.006668+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.006686+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.006704+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.007066+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.007108+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.007128+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.007146+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.007514+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.007546+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.007565+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.007685+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.008303+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.008347+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.008367+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.008387+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.008711+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.008741+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.008763+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.008785+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.009200+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.009238+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.009260+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.009306+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.010010+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.010058+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.010084+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.010107+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.010476+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.010510+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.010532+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.010555+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.010909+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.010945+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.010972+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.011020+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.011399+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.011436+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.011458+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.011482+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.011900+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.011942+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.011964+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.011985+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.012406+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.012446+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.012469+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.012734+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.013180+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.013222+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.013245+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.013267+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.013654+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.013688+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.013710+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.013733+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.014092+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.014125+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.014148+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.014173+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.014590+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.014628+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.014652+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.014701+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.015326+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.015373+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.015396+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.015419+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.015798+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.015833+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.015856+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
2022-07-17 20:01:10.015876+0300 travelguide[20576:1361102] [UserSession] maps short session requested but session sharing is not enabled
 destination
 destination
 destination
 destination
 destination
 destination
 destination
 destination
 destination
 destination
 destination
 destination
 destination
destination --> PharmacyFoundedData(pharmacyLatitude: 39.775239, pharmacyLongitude: 28.882006, pharmacyName: "Yeni Orhan Eczanesi", pharmacyCounty: "Büyükorhan", pharmacyPhoneNumber: Optional("0(506)226-03-44"), pharmacyAddress: Optional("Orhan Mahallesi, Dr. İbrahim Öktem Caddesi, No:35 Büyükorhan / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.4209095, pharmacyLongitude: 29.1583118, pharmacyName: "Şems Eczanesi", pharmacyCounty: "Gemlik", pharmacyPhoneNumber: Optional("0(224)513-11-13"), pharmacyAddress: Optional("Hisar Mahallesi, Kına Sokak, No:35/I Gemlik / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.219256, pharmacyLongitude: 29.191456, pharmacyName: "Nehirin Eczanesi", pharmacyCounty: "Gürsu", pharmacyPhoneNumber: Optional("0(224)371-03-00"), pharmacyAddress: Optional("Zafer Mahallesi, Barbaros Sokak No:22/A Gürsu / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 39.679031, pharmacyLongitude: 29.154904, pharmacyName: "Ulaş Eczanesi", pharmacyCounty: "Harmancık", pharmacyPhoneNumber: Optional("0(224)881-22-72"), pharmacyAddress: Optional("Merkez Mahallesi, Fevzi Paşa Caddesi, No:9/A Harmancık / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.080568, pharmacyLongitude: 29.520877, pharmacyName: "Yeni İnegöl Eczanesi", pharmacyCounty: "İnegöl", pharmacyPhoneNumber: Optional("0(224)715-12-94"), pharmacyAddress: Optional("Orhaniye Mahallesi, Varışlısoy Sokak, No:20 İnegöl / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.0703095, pharmacyLongitude: 29.510258, pharmacyName: "Anadolu Eczanesi", pharmacyCounty: "İnegöl", pharmacyPhoneNumber: Optional("0(224)715-27-94"), pharmacyAddress: Optional("Hamidiye Mahallesi, Park Caddesi, No:55 İnegöl / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.101793, pharmacyLongitude: 29.524649, pharmacyName: "Bizim Eczanesi", pharmacyCounty: "İnegöl", pharmacyPhoneNumber: Optional("0(552)462-49-46"), pharmacyAddress: Optional("Yeni Mahallesi, Gülfidan Sokak, No:5/A İnegöl / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.429269, pharmacyLongitude: 29.7226726, pharmacyName: "Yeni Eczanesi", pharmacyCounty: "İznik", pharmacyPhoneNumber: Optional("0(224)757-24-25"), pharmacyAddress: Optional("Yeni Mahallesi, Kılıçaslan Caddesi, No:134 İznik / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.2093922, pharmacyLongitude: 28.3664961, pharmacyName: "Yeni Eczanesi", pharmacyCounty: "Karacabey", pharmacyPhoneNumber: Optional("0(224)676-10-67"), pharmacyAddress: Optional("Gazi Mahallesi, Fatih Sultan Mehmet Caddesi, No:6/1 Karacabey / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 39.912752, pharmacyLongitude: 29.23317, pharmacyName: "Şifa Eczanesi", pharmacyCounty: "Keles", pharmacyPhoneNumber: Optional("0(224)861-21-64"), pharmacyAddress: Optional("Atatürk Caddesi, Çarşı içi No:3/B Keles / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.201116, pharmacyLongitude: 29.2127555, pharmacyName: "Kestel Eczanesi", pharmacyCounty: "Kestel", pharmacyPhoneNumber: Optional("0(224)372-10-15"), pharmacyAddress: Optional("Kale Mahallesi, Bursa Caddesi, No:2/B Kestel / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.369716, pharmacyLongitude: 28.8907841, pharmacyName: "Arıman Eczanesi", pharmacyCounty: "Mudanya", pharmacyPhoneNumber: Optional("0(224)544-17-93"), pharmacyAddress: Optional("Ömerbey Mahallesi, Deniz Caddesi, Akarsu-2 Sitesi D-Blok No:31/A-1 Mudanya / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.35477, pharmacyLongitude: 28.928694, pharmacyName: "Güzelyalı Eczanesi", pharmacyCounty: "Mudanya", pharmacyPhoneNumber: Optional("0(224)554-85-80"), pharmacyAddress: Optional("Kazım Karabekir Caddesi, No:8/B Güzelyalı Mudanya / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.036121, pharmacyLongitude: 28.414565, pharmacyName: "Nergis Eczanesi", pharmacyCounty: "Mustafakemalpaşa", pharmacyPhoneNumber: Optional("0(224)613-08-09"), pharmacyAddress: Optional("Züferbey Mahallesi, İsmetpaşa Caddesi, No:38/A-B Mustafakemalpaşa / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.2470018, pharmacyLongitude: 28.9395714, pharmacyName: "Eylül Eczanesi", pharmacyCounty: "Nilüfer", pharmacyPhoneNumber: Optional("0(224)241-82-52"), pharmacyAddress: Optional("Minareli Çavuş Mahallesi, Mevlana Caddesi, No:36/A Nilüfer / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.206459, pharmacyLongitude: 28.980989, pharmacyName: "Alp Eczanesi", pharmacyCounty: "Nilüfer", pharmacyPhoneNumber: Optional("0(224)452-17-60"), pharmacyAddress: Optional("Konak Mahallesi, Beşevler Caddesi, Gonca Sitesi B-Blok No:44/19 Beşevler Nilüfer / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.2200933, pharmacyLongitude: 28.990292, pharmacyName: "Buket Eczanesi", pharmacyCounty: "Nilüfer", pharmacyPhoneNumber: Optional("0(224)245-66-45"), pharmacyAddress: Optional("İhsaniye Mahallesi, Tepe Sokak, No:14/A Nilüfer / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.216403, pharmacyLongitude: 28.893158, pharmacyName: "Narmanlı Eczanesi", pharmacyCounty: "Nilüfer", pharmacyPhoneNumber: Optional("0(224)909-35-69"), pharmacyAddress: Optional("100.Yıl Mahallesi, Hakan Sepetçi Caddesi, 512 Sokak, No:2A/h Nilüfer / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.2290474, pharmacyLongitude: 28.9183467, pharmacyName: "Bengisu Eczanesi", pharmacyCounty: "Nilüfer", pharmacyP2022-07-17 20:07:36.014755+0300 travelguide[20620:1363749] [UserSession] maps short session requested but session sharing is not enabled
destination --> PharmacyFoundedData(pharmacyLatitude: 40.222513, pharmacyLongitude: 28.973221, pharmacyName: "Nilüfer Yaşam Eczanesi", pharmacyCounty: "Nilüfer", pharmacyPhoneNumber: Optional("0(224)452-81-62"), pharmacyAddress: Optional("Cumhuriyet Mahallesi, Ga2022-07-17 20:07:36.021478+0300 travelguide[20620:1363749] [UserSession] maps short session requested but session sharing is not enabled
destination --> PharmacyFoundedData(pharmacyLatitude: 39.905429, pharmacyLongitude: 28.984376, pharmacyName: "Cannur Eczanesi", pharmacyCounty: "Orhaneli", pharmacyPhoneNumber: Optional("0(224)817-12-62"), pharmacy2022-07-17 20:07:36.022605+0300 travelguide[20620:1363749] [UserSession] maps short session requested but session sharing is not enabled
destination --> PharmacyFoundedData(pharmacyLatitude: 40.491856, pharmacyLongitude: 29.311617, pharmacyName: "Emir Eczanesi", pharmacyCounty: "Orhangazi", pharmacyPhoneNumber: Optional("0(224)575-00-05"), pharmacyAddress: Optional("Muradiye Mahallesi, Turist Yolu Altı Sokak, No:102 Orhangazi / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.208087, pharmacyLongitude: 29.04199, pharmacyName: "Serhat Eczanesi", pharmacyCounty: "Osmangazi", pharmacyPhoneNumber: Optional("0(224)236-75-47"), pharmacyAddress: Optional("Soğanlı Mahallesi, Nilüfer Caddesi, No:121 Osmangazi / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.203145, pharmacyLongitude: 29.0663129, pharmacyName: "Bahar Eczanesi", pharmacyCounty: "Osmangazi", pharmacyPhoneNumber: Optional("0(224)271-69-37"), pharmacyAddress: Optional("Bahar Mahallesi, Serçe Sokak, No:40 Osmangazi / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.214592, pharmacyLongitude: 29.058037, pharmacyName: "Tevhid Eczanesi", pharmacyCounty: "Osmangazi", pharmacyPhoneNumber: Optional("0(224)250-92-21"), pharmacyAddress: Optional("Fatih Mahallesi, Doğan Caddesi, No:71/1 Osmangazi / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.221837, pharmacyLongitude: 29.005762, pharmacyName: "Akasya Eczanesi", pharmacyCounty: "Osmangazi", pharmacyPhoneNumber: Optional("0(224)240-10-80"), pharmacyAddress: Optional("İstiklal Mahallesi, Yeşilova Caddesi, No:4A/b Osmangazi / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.244673, pharmacyLongitude: 28.967417, pharmacyName: "Tokoğlu2022-07-17 20:07:36.028152+0300 travelguide[20620:1363749] [UserSession] maps short session requested but session sharing is not enabled
destination --> PharmacyFoundedData(pharmacyLatitude: 40.198064, pharmacy2022-07-17 20:07:36.029311+0300 travelguide[20620:1363749] [UserSession] maps short session requested but session sharing is not enabled
destination --> PharmacyFoundedData(pharmacyLatitude: 40.185605, pharmacyLongitude: 29.06509, pharmacyName: "Serdar Eczanesi", pharmacyCounty: "Osmangazi", pharmacyPho2022-07-17 20:07:36.031064+0300 travelguide[20620:1363749] [UserSession] maps short session requested but session sharing is not enabled
destination --> PharmacyFoundedData(pharmacyLatitude: 40.2675214, pharmacyLongitude: 29.6515413, pharmacyName: "Koç Eczanesi", pharmacyCounty: "Yenişehir", pharmacyPhoneNumber: Optional("0(224)773-41-89"), pharmacyAddress: Optional("Yenigün Mahallesi, Atatürk Caddesi, No:17/1 Yenişehir / Bursa"))
destination --> PharmacyFounde2022-07-17 20:07:36.032604+0300 travelguide[20620:1363749] [UserSession] maps short session requested but session sharing is not enabled
destination --> PharmacyFoundedData(pharmacyLatitude: 40.186683, pharmacyLongitude: 29.10764, pharmacyName: "152 Evle2022-07-17 20:07:36.033941+0300 travelguide[20620:1363749] [UserSession] maps short session requested but session sharing is not enabled
destination --> PharmacyFoundedData(pharmacyLatitude: 40.179912, pharmacyLongitude: 29.1025009, pharmacyName: "Nur Eczanesi", pharmacyCounty: "Yıldırım", pharmacyPhoneNumber: Optional("0(555)042-32-20"), pharmacyAddress: Optional("Maltepe Mahallesi, Yeşilyayla Caddesi, 8.Şen Sokak, No10/a Yıldırım / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.18103, pharmacyLongitude: 29.073312, pharmacyName: "Yeşil Eczanesi", pharmacyCounty: "Yıldırım", pharmacyPhoneNumber: Optional("0(224)327-45-83"), pharmacyAddress: Optional("Yeşil Mahallesi, Yeşil Caddesi, No:44 Yıldırım / Bursa"))
destination --> PharmacyFoundedData(pharmacyLatitude: 40.200911, pharmacyLongitude: 29.088867, pharmacyName: "Bursa Vatan Eczanesi", pharmacyCounty: "Yıldırım", pharmacyPhoneNumber: Optional("0(224)361-37-64"), pharmacyAddress: Optional("Vatan Mahallesi, Vatan Caddesi, No:62/A Yıldırım / Bursa"))
destination --> Pharma2022-07-17 20:07:36.037196+0300 travelguide[20620:1363749] [UserSession] maps short session requested but session sharing is not enabled

Distance directions calculation error
 destination
hata --> Directions Not Available
t
Distance directions calculation error
 destination
hata --> Directions Not Available

Distance directions calculation error
 destination
hata --> Directions Not Available
t
Distance directions calculation error
 destination
hata --> Directions Not Available

Distance directions calculation error
 destination
hata --> Directions Not Available

Distance directions calculation error
 destination
hata --> Directions Not Available

Distance directions calculation error
 destination
hata --> Directions Not Available

Distance directions calculation error
 destination
hata --> Directions Not Available
tr
Distance directions calculation error
 destination
hata --> Directions Not Available

Distance directions calculation error
 destination
hata --> Directions Not Available

Distance directions calculation error
 destination
hata --> Directions Not Available
tr
Distance directions calculation error
 destination
