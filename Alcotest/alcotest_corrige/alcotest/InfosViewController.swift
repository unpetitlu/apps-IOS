//
//  InfosViewController.swift
//  alcotest
//
//  Created by Nicolas on 15/02/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit

class InfosViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView : UIWebView!
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func goBack() {
        // revient en arrière dans la page web
        webView.goBack()
    }
    
    @IBAction func customButtonPressed() {
        let myString = "<h1>Mon titre</h1><p>Consommez avec modération.</p><p>L'abus d'alcool est dangereux pour la santé.</p>"
        displayHtmlPage(myString)
    }
    
    //intercepte les request dans la webview
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let requestURL = request.URL {
            print("requestURL=\(requestURL.absoluteString)")
            if requestURL.absoluteString.rangeOfString("iphone") != nil {
                    print("impossible")
                //on retourne false, ce qui bloque l'execution de la requête
                simpleAlert("Erreur", message: "Vous ne pouvez pas accéder à cette page", acceptTitle: nil, myController: self, completionHandler: nil)
                
                return false
            }
        }
        return true
    }
    
    // affichage d'un code html / css dans la webview
    func displayHtmlPage(htmlCode : String) {
        let mainBundleUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath)
        let htmlString = "<head> <link rel=\"stylesheet\" href=\" style.css \"></head><body>"
                + htmlCode + "</body>"
        
        webView.scalesPageToFit = true
        webView.loadHTMLString(htmlString, baseURL: mainBundleUrl)
    }
    
    // affichage d'une page web dans la webview
    func displayWebPage() {
        webView.scalesPageToFit = true
        let myurl = NSURL(string: "http://www.apple.fr")!
        let request = NSURLRequest(URL: myurl)
        webView.loadRequest(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        displayWebPage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
