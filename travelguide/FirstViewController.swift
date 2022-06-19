//
//  FirstViewController.swift
//  travelguide
//
//  Created by ulas özalp on 18.06.2022.
//

import UIKit
import CoreData

class FirstViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var titleArray = [String]()
    var idArrau = [UUID]()
    var choosenTitle = ""
    var choosenTitleID : UUID?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
        // Do any additional setup after loading the view.
    }
    @objc func getData () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request)
            if results.count > 0 {
                self.titleArray.removeAll(keepingCapacity: false)
                self.idArrau.removeAll(keepingCapacity: false)
                for result in results as! [NSManagedObject]{
                    
                    if let title =  result.value( forKey: "title") as? String {
                        self.titleArray.append(title)
                        
                    }
                    if let id = result.value (forKey: "id") as? UUID {
                        self.idArrau.append(id)
                         
                    }
                    tableView.reloadData()
                }
            }
        } catch {
            print ("error")
        }
        
        
        
        
    }
    @objc func addButtonClicked(){
        choosenTitle = ""
        performSegue(withIdentifier: "toViewController", sender: nil)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        choosenTitle = titleArray[indexPath.row]
        choosenTitleID = idArrau[indexPath.row]
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedTitle = choosenTitle
            destinationVC.selectedTitleID = choosenTitleID
        }
    }
}
