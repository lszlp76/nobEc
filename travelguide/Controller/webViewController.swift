//
//  webViewController.swift
//  travelguide
//
//  Created by ulas özalp on 2.08.2022.
//

import UIKit
import WebKit

class webViewController: UIViewController, WKUIDelegate {

    
    
    /**
     Webview yaparken segue olarak show e.g. push yapmalsın
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        
               let myURL = URL(string:"https://agromtek.com/NobEc/about.html")
               let myRequest = URLRequest(url: myURL!)
               webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @IBOutlet weak var webView: WKWebView!
    override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
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
