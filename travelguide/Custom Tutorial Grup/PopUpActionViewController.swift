//
//  PopUpActionViewController.swift
//  travelguide
//
//  Created by ulas özalp on 14.08.2022.
//

import UIKit
protocol PopUpProtocol {
    func handleAction(action: Bool)
}
class PopUpActionViewController: UIViewController {
    static let identifier = "PopUpActionViewController"
        
        var delegate: PopUpProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func buttonClicked(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    static func showPopup(parentVC: UIViewController){
           //creating a reference for the dialogView controller
           if let popupViewController = UIStoryboard(name: "CustomView", bundle: nil).instantiateViewController(withIdentifier: "PopUpActionViewController") as? PopUpActionViewController {
               popupViewController.modalPresentationStyle = .custom
               popupViewController.modalTransitionStyle = .crossDissolve
               
               //setting the delegate of the dialog box to the parent viewController
               popupViewController.delegate = parentVC as? PopUpProtocol

               //presenting the pop up viewController from the parent viewController
               parentVC.present(popupViewController, animated: true)
           }
       }
}
