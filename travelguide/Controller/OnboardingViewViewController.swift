//
//  OnboardingViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 3.06.2021.
//

import UIKit
import paper_onboarding


class OnboardingViewController: UIViewController , PaperOnboardingDataSource, PaperOnboardingDelegate{
    
    
    func onboardingItemsCount() -> Int {
        return 3 // 2 sayfa olacak
    }
    
    @IBAction func onBoardingTapped(_ sender: UIButton) {
        
            self.performSegue(withIdentifier: "toTabView", sender: nil)
        
        
    }
    @IBOutlet weak var onBoardingButton: UIButton!
    @IBOutlet weak var onBoardingView: OnboardingView!
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let bgcolor2 = UIColor( red:0/255, green: 0/255, blue :100/255,alpha: 1)
       // let bgcolor1 = UIColor( red: 200/255, green: 89/255, blue : 92/255,alpha: 1)
        
       // let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
       // let descFont = UIFont(name: "AvenirNext-Regular",size: 18)!
        let rocket  = UIImage(systemName: "circle.fill") as UIImage?
        let rocket3 = UIImage(named: "pharmacyRedLogo") as UIImage?
        let rocket2 = UIImage(named: "pharmacyBlueLogo" ) as UIImage?
        let icon = UIImage(named: "pharmacy") as UIImage?
        //let fontColor1 = UIColor (red: 206/255, green: 147/255, blue: 216/255, alpha: 1)
        let fontColor2 = UIColor (red: 204/255, green: 71/255, blue: 188/255, alpha: 1)
        
        return [
            OnboardingItemInfo(
                informationImage: rocket!, title: "Konumunuza en yakın eczaneler",
                                     description: "Bulunduğunuz bölgedeki en yakın eczaneleri harita üzerinde gösterir. Telefon numaraları ve mesafeyi hızlıca görebilirsin. ",                                     pageIcon: icon!,
                                     color: bgcolor2,
                                     titleColor: fontColor2,
                                     descriptionColor: fontColor2,
                                     titleFont: UIFont(name: "AvenirNext-Bold", size: 24)!,
                                     descriptionFont: UIFont(name: "AvenirNext-Regular", size: 18)!),
            OnboardingItemInfo(informationImage: rocket2!,
                                     title: "Nöbetçi eczaneleri listeler",
                                     description: "O günkü nöbetçi eczaneleri bulunduğunuz konuma göre listeler.",
                                     pageIcon: icon!,
                                     color: bgcolor2,
                                     titleColor: fontColor2,
                                     descriptionColor: fontColor2,
                                     titleFont: UIFont(name: "AvenirNext-Bold", size: 24)!,
                                     descriptionFont: UIFont(name: "AvenirNext-Regular", size: 18)!),
            OnboardingItemInfo(informationImage: rocket3!,
                                     title: "Paylaşım ile aktarın ",
                                     description: "Seçtiğiniz eczaneyi paylaşabilirsiniz.",
                                     pageIcon: icon!,
                                     color: bgcolor2,
                                     titleColor: fontColor2,
                                     descriptionColor: fontColor2,
                                     titleFont: UIFont(name: "AvenirNext-Bold", size: 24)!,
                                     descriptionFont: UIFont(name: "AvenirNext-Regular", size: 18)!)
                
        ] [index]
    }
    
    /*
     onboarding view button eklerken , buttonu ana view e eklemen lazım
     
     https://www.youtube.com/watch?v=G5UkS4Mrepo
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onBoardingView.dataSource = self
        onBoardingView.delegate = self
        
        onBoardingButton.alpha = 0
        
        
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    func onboardingDidTransitonToIndex(_ index: Int) {
        // eğer 3ncu sayfaya gelirse
        if index == 2{
            
            UIView.animate(withDuration: 0.4, animations: {
                self.onBoardingButton.alpha = 1
            })
        }
    }
    
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 || index == 0 {
            if self.onBoardingButton.alpha == 1 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.onBoardingButton.alpha = 0
                })
            }
            
        }
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
