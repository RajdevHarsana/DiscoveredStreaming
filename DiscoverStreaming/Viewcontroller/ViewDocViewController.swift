//
//  ViewDocViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 22/01/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class ViewDocViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webnewView: UIWebView!
    @IBOutlet weak var indicatiorView: UIActivityIndicatorView!
    var defaults:UserDefaults!
    var docUrl:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        docUrl = defaults.value(forKey: "Image") as? String
        webnewView.delegate = self
        indicatiorView.style =  .whiteLarge
        indicatiorView.color = UIColor.black
        indicatiorView.center = self.view.center
        termsandconditionmethod()
        // Do any additional setup after loading the view.
    }
    
    func termsandconditionmethod() {
        
       // let urlString = "http://i.devtechnosys.tech:8083/hostgates/pages/about_us_mob"
        indicatiorView.startAnimating()
        indicatiorView.isHidden = false
        webnewView.scrollView.isScrollEnabled = true
        webnewView.scrollView.contentOffset = CGPoint(x: 0, y: 800)
        webnewView.scalesPageToFit = true
        webnewView.scrollView.bounces = false
        if let aString = URL(string: docUrl) {
            webnewView.loadRequest(URLRequest(url: aString))
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        indicatiorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicatiorView.stopAnimating()
        indicatiorView.isHidden = true
    }
    
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
