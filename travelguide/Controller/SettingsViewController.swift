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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView"
        {
            let destinationVC = segue.destination as! webViewController
            
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    
    
   
    var switchON = false
    var settingsListElement = [SettingsModelStructure]()
    
    @IBOutlet weak var ss: UISwitch!
    let userDefaults = UserDefaults.standard
    override func viewWillAppear(_ animated: Bool) {
        
        
        tableView.reloadData()
    }
    @objc func turnOnAllPharmacyOption (){
        
        if userDefaults.getValueForSwitch(keyName: "tutorial") == false {
         
           // allPharmacyOption = true
           // GetLocation.sharedInstance.allPharmacy = allPharmacyOption
           print("kapandı")
           
           // userDefault.setValueForAllPharmacyOption(value: false, keyName: "tutorial")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
        configureSettingsList()
    }
    func configureSettingsList () {
        
self.settingsListElement.append(SettingsModelStructure(switchOff: true, settingsCellText:  "Uygulama öğreticisini aç "))
        /*
         Tüm eczaneleri göster gereksiz bir özellik olduğu için iptal edildi.
         ancak tüm detayları duruyor code içinde
         */
        
        self.settingsListElement.append(SettingsModelStructure(switchOff: false, settingsCellText: "Uygulamayı değerlendir"))
       // self.settingsListElement.append(SettingsModelStructure(switchOff: false, settingsCellText: "Hakkında"))
        self.settingsListElement.append(SettingsModelStructure(switchOff: false, settingsCellText: "Policy"))
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitles = "AYARLAR"
    
        return headerTitles
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsListElement.count
        
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
            header.textLabel?.textColor = UIColor.init(named: "SpesificColor")
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            header.textLabel?.frame = header.bounds
           // header.textLabel?.textAlignment = .center
     
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        switch indexPath.row {
        case 0 :
            (print("toggle"))
            break
        case 1:
            rateApp()
            break
//        case 2:(
//        print("hakkında"))
//            break
    case 2: 
        self.performSegue(withIdentifier: "toWebView", sender: nil)
    
            break
        default : ( print("default"))
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCellModelTableViewCell
        tableView.rowHeight = 50
        settingsCell.labelText.textColor = UIColor.init(named: "ColorForListView")
        settingsCell.labelText.text = settingsListElement[indexPath.row].settingsCellText
        
        
        if settingsListElement[indexPath.row].switchOff {
            settingsCell.toggleSwitch.isHidden = false
            settingsCell.toggleSwitch .addTarget(self, action: #selector(self.toggleTriggered), for: .primaryActionTriggered)
//            if userDefaults.getValueForSwitch(keyName: "allPharmacyOption") == false
//
            if userDefaults.getValueForSwitch(keyName: "tutorial") == false
            {
                settingsCell.toggleSwitch.setOn(false, animated: true) // sayfa açıldığında swici off tutacak
            }else if userDefaults.getValueForSwitch(keyName: "tutorial") == true {
                settingsCell.toggleSwitch.setOn(true, animated: true)
            }
        }else {
            settingsCell.toggleSwitch.isHidden = true
            
        }
        
        return settingsCell
        
    }
    
    @objc func toggleTriggered (_ sender: UISwitch) {
     
      // --> öğretici açık kapalı kontrolu
        // eğer aç talebi geldiyse, userdefaults a kapat yazdırıyor
//            if userDefaults.bool(forKey: "tutorial") == true {
//                userDefaults.setValueForAllPharmacyOption(value: true, keyName: "tutorial")
//            }else {
//                userDefaults.setValueForAllPharmacyOption(value: false, keyName: "tutorial")
//            }
//            
            if userDefaults.getValueForSwitch(keyName: "tutorial") == false {
               
                GetLocation.sharedInstance.allPharmacy = true
            print( "tutorial is ON")
              
                userDefaults.setValueForAllPharmacyOption(value: true, keyName: "tutorial")
             
            }else {
                 
                print( "tutorial off")
                GetLocation.sharedInstance.allPharmacy = false
                
                userDefaults.setValueForAllPharmacyOption(value: false, keyName: "tutorial")
              
            }
        NotificationCenter.default.post(name: .allPharmacy, object: nil)
      
       
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
  
            

