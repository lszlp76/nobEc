//
//  SettingsViewController.swift
//  travelguide
//
//  Created by ulas özalp on 30.06.2022.
//

import UIKit
import StoreKit
class SettingsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
/*
 Settings te neler olacak ? :
 --> Şehirdeki tüm eczaneleri göster toogle buton ile
 --> Default olarak bulunduğu il ve ilçe gelecek
 --> Rate me olacak
 --> Hakkında olacak

 */
    
    @IBOutlet weak var tableView: UITableView!
    
   
    
   
    var switchON = false
    var settingsListElement = [SettingsModelStructure]()
    
    @IBOutlet weak var ss: UISwitch!
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
        configureSettingsList()
    }
    func configureSettingsList () {
        
        self.settingsListElement.append(SettingsModelStructure(switchOff: true, settingsCellText:  "Tüm eczaneleri göster"))
        self.settingsListElement.append(SettingsModelStructure(switchOff: false, settingsCellText: "Uygulamayı değerlendir"))
        self.settingsListElement.append(SettingsModelStructure(switchOff: false, settingsCellText: "Hakkında"))
        self.settingsListElement.append(SettingsModelStructure(switchOff: false, settingsCellText: "Policy"))
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitles = "AYARLAR"
    
        return headerTitles
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsListElement.count
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        switch indexPath.row {
        case 0 :
            (print("toggle"))
            break
        case 1:
            rateApp()
            break
        case 2:(
        print("hakkında"))
            break
        case 3: (
        print("policy"))
            break
        default : ( print("default"))
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCellModelTableViewCell
        tableView.rowHeight = 50
        
        settingsCell.labelText.text = settingsListElement[indexPath.row].settingsCellText
        
        
        if settingsListElement[indexPath.row].switchOff {
            settingsCell.toggleSwitch.isHidden = false
            settingsCell.toggleSwitch .addTarget(self, action: #selector(self.toggleTriggered), for: .primaryActionTriggered)
           
            if userDefaults.getValueForSwitch(keyName: "allPharmacyOption") == false
            {
                settingsCell.toggleSwitch.setOn(false, animated: true) // sayfa açıldığında swici off tutacak
            }else if userDefaults.getValueForSwitch(keyName: "allPharmacyOption") == true {
                settingsCell.toggleSwitch.setOn(true, animated: true)
            }
        }else {
            settingsCell.toggleSwitch.isHidden = true
            
        }
        
        return settingsCell
        
    }
    
    @objc func toggleTriggered (_ sender: UISwitch) {
        print("ulas swcth sender tag => \(sender.tag)")
        if GetLocation.sharedInstance.connectionGPSExist {
            
            if userDefaults.bool(forKey: "allPharmacyOption") == true {
                userDefaults.setValueForAllPharmacyOption(value: false, keyName: "allPharmacyOption")
            }else {
                userDefaults.setValueForAllPharmacyOption(value: true, keyName: "allPharmacyOption")
            }
            
        NotificationCenter.default.post(name: .allPharmacy, object: nil)
        }else {
            let unitAlert = UIAlertController (title:"Konum Hatası",message: "Çok sayıda talep yaptınız.\nBiraz bekledikten sonra deneyin", preferredStyle: .alert)
            unitAlert.addAction(UIAlertAction (title: "OK", style: .default,handler: { UIAlertAction in
                
                
                 // bağlantı yok
                
                return
            }))
            self.present(unitAlert,animated: true,completion: nil)
            
            if userDefaults.getValueForSwitch(keyName: "allPharmacyOption") == false {
               
                GetLocation.sharedInstance.allPharmacy = true
            print( "allPharmacyOption is ON")
              
                userDefaults.setValueForAllPharmacyOption(value: true, keyName: "allPharmacyOption")
             
            }else {
                 
                print( "allPharmacyOption is Off")
                GetLocation.sharedInstance.allPharmacy = false
                
                userDefaults.setValueForAllPharmacyOption(value: false, keyName: "allPharmacyOption")
              
            }
        }
    }
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()

        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" +  "GZ94AWJKRA") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
  
            
}
