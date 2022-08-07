//
//  pageThreeViewController.swift
//  travelguide
//
//  Created by ulas özalp on 7.08.2022.
//

import UIKit

class pageThreeViewController: UIViewController {

    @IBAction func buttonClicked(_ sender: Any) {
       
        self.performSegue(withIdentifier: "toTabView2", sender: nil)
    }
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
