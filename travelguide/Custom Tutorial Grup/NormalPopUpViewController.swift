//
//  NormalPopUpViewController.swift
//  travelguide
//
//  Created by ulas özalp on 14.08.2022.
//

import UIKit

class NormalPopUpViewController: UIViewController {
    @IBOutlet var dialogBoxView: UIView!
   
  
    @IBOutlet weak var backButton: UIButton!
    private var i = 0
    @IBAction func backButtonClicked(_ sender: Any) {
        print(i)
        i -= 1
        print(i)
        switch i {
        case 3 :
            imageView.image = UIImage(named: "payla")
            label.text = "Seçtiğiniz eczane ikonuna basılı tuttuğunuzda paylaşım ekranı açılır."
            backButton.isHidden = false
            break
        case 2:
            imageView.image = UIImage(named: "eczaneDetay")
            label.text = "Araç butonu, eczaneye giden en kısa yolu otomobil ile tarif eder. Telefon butonu, eczaneyi aramanıza yardımcı olur"
            backButton.isHidden = false
           break
        case 1 :
            imageView.image = UIImage(named: "Tutorial")
            label.text = "Konumunuza en yakın nöbetçi eczane kırmızı ile, yakınınızdaki diğer eczaneler mavi ikon ile gösterilir."
            backButton.isHidden = true
            
           
        break
        case 0 :
            imageView.image = UIImage(named: "Tutorial")
            label.text = "Konumunuza en yakın nöbetçi eczane kırmızı ile, yakınınızdaki diğer eczaneler mavi ikon ile gösterilir."
            backButton.isHidden = true
        default:
            imageView.image = UIImage(named: "Tutorial")
            label.text = "Konumunuza en yakın nöbetçi eczane kırmızı ile, yakınınızdaki diğer eczaneler mavi ikon ile gösterilir."
            backButton.isHidden = false
        }
    }
    static let identifier = "NormalPopUpViewController"
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.isHidden = true
        //adding an overlay to the view to give focus to the dialog box
            view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
            //customizing the dialog box view
            dialogBoxView.layer.cornerRadius = 6.0
            dialogBoxView.layer.borderWidth = 1.2
            dialogBoxView.layer.borderColor = UIColor(named: "ColorForListView")?.cgColor
            label.textColor = UIColor(named: "ColorForTabsBallons")
        label.text = "Konumunuza en yakın nöbetçi eczane kırmızı ile, yakınınızdaki diğer eczaneler mavi ikon ile gösterilir."
       
            //customizing the okay button
//            okayButton.backgroundColor = UIColor(named: "ColorForTabsBallons")?.withAlphaComponent(0.85)
//             okayButton.setTitleColor(UIColor.white, for: .normal)
//             okayButton.layer.cornerRadius = 4.0
//             okayButton.layer.borderWidth = 1.2
//             okayButton.layer.borderColor = UIColor(named: "ColorForListView")?.cgColor
//        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTap(_ sender: Any) {
        i += 1
        switch i {
        case 1 :
            imageView.image = UIImage(named: "Tutorial")
            label.text = "Konumunuza en yakın nöbetçi eczane kırmızı ile, yakınınızdaki diğer eczaneler mavi ikon ile gösterilir."
            backButton.isHidden = true
            
           
        break
        case 2:
            imageView.image = UIImage(named: "eczaneDetay")
            label.text = "Araç butonu, eczaneye giden en kısa yolu otomobil ile tarif eder. Telefon butonu, eczaneyi aramanıza yardımcı olur"
            backButton.isHidden = false
           break
        case 3 :
            imageView.image = UIImage(named: "payla")
            label.text = "Seçtiğiniz eczane ikonuna basılı tuttuğunuzda paylaşım ekranı açılır."
            backButton.isHidden = false
            break
       
            
            
        default:
            imageView.image = UIImage(named: "payla")
            label.text = ""
        }
       //self.dismiss(animated: true, completion: nil)

    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
   
      
            
          
     
  
    static func showPopup(parentVC: UIViewController){
           
           //creating a reference for the dialogView controller
           if let popupViewController = UIStoryboard(name: "CustomView", bundle: nil).instantiateViewController(withIdentifier: "NormalPopUpViewController") as? NormalPopUpViewController {
               popupViewController.modalPresentationStyle = .custom
               popupViewController.modalTransitionStyle = .crossDissolve
               
               //presenting the pop up viewController from the parent viewController
               parentVC.present(popupViewController, animated: true)
           }
       }
}
