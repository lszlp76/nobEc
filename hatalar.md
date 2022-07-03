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
3. telefon arama pital edilirse app çöküyor
/--> çözüldü ! 4. araç git butonu çalışmıypr
/--> çözüldü ! 5. gps kesilince tekrar çalışmıyor --> güncelleme bayrağı koyuldu. Ikon yeri şekli değişecek
/--> çözüldü ! 6. telefon numarasını değiştirmeyi unutma
7. konumları paylaşma koyulacak









      ,
      
