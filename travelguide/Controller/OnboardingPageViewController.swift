//
//  OnboardingPageViewController.swift
//  travelguide
//
//  Created by ulas özalp on 7.08.2022.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
   
   
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
//        if previousIndex < 3 { title = "Industrial Chronometer"}
        guard previousIndex >= 0 else {
            return   nil // burayı orderedViewControllers.last yaparsan tekrar son sayfaya gelir
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
//        if nextIndex == 3 { title = "Saved Observations"}
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
//        let appearence =  UINavigationBar.appearance()
//        appearence.barTintColor = UIColor(red: 0.85, green: 0.11, blue: 0.38, alpha: 1.00)
//        appearence.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//
        //menu butonu eklemek
//        let menu =  UIBarButtonItem (image: UIImage(named: "menu"), style: .plain, target: self , action: #selector(callSettingsMenu))
        
//        self.navigationItem.leftBarButtonItem = menu
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController]
                               , direction: .forward
                               , animated: true,
                               completion: nil)
            
            
        }
        print(orderedViewControllers.first)
       
    }
    @objc func callSettingsMenu (){
        
        self.performSegue(withIdentifier: "toSettingsMenu", sender: nil)
        
    }
    
    
    private (set) lazy var orderedViewControllers : [UIViewController] = {
        
        return [self.callViewController ( order: "pageone" ),
                self.callViewController ( order: "pagetwo" ),
                self.callViewController ( order: "pagethree" )  ]
    }()
    
    func callViewController (order : String )-> UIViewController {
        
        return  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(order)")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
                  return 0
              }
        return firstViewControllerIndex
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
