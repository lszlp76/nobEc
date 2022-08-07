//
//  pageThreeViewController.swift
//  travelguide
//
//  Created by ulas özalp on 7.08.2022.
//

import UIKit

class pageThreeViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @IBAction func buttonClicked(_ sender: Any) {
        print("ok")
        UIView.animate(withDuration: 0.25, animations: {
            
            self.startButton.alpha = CGFloat(1)
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        })
        //self.performSegue(withIdentifier: "toTabView2", sender: nil)
    }
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    func showAnimate()
    {
        
        UIView.animate(withDuration: 0.85, animations: {
            
            self.startButton.alpha = CGFloat(1.0)
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
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
