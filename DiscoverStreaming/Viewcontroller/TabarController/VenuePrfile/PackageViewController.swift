//
//  PackageViewController.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 29/07/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class PackageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var packageCollectionView: UICollectionView!
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenheight = UIScreen.main.bounds.size.height
    var defaults :UserDefaults!
    var Arsts:String!
    var user_id:Int!
    var response = NSMutableArray()
    
    @objc func DiscoveredPromotionalPackageAction (_ notification: Notification){
        let status = (notification.userInfo?["status"] as? String)!
        let str_message = (notification.userInfo?["message"] as? String)!
        let proStatus = Int(status)
        DispatchQueue.main.async() {
            if proStatus == 0{
                
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
                
                
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(self.response)")
                self.packageCollectionView.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.packageCollectionView.delegate = self
        self.packageCollectionView.dataSource = self

        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().GetPromotionalPlanList()
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoveredPromotionalPackageAction), name: NSNotification.Name(rawValue: "GetPromotionalPlanListNotification"), object: nil)
        }else {
            let test =  SwiftToast(
                text: "Internet Connection not Available!",
                textAlignment: .center,
                image: UIImage(named: "Icon-App-29x29"),
                backgroundColor: .purple,
                textColor: .white,
                font: .boldSystemFont(ofSize: 15.0),
                duration: 2.0,
                minimumHeight: CGFloat(80.0),
                aboveStatusBar: false,
                target: nil,
                style: .navigationBar)
            self.present(test, animated: true)
            self.response.removeAllObjects()
        }
        
        
       let LiberaryLayOut = UICollectionViewFlowLayout()
        LiberaryLayOut.itemSize = CGSize(width: 260, height: 400)
        LiberaryLayOut.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 20)
        LiberaryLayOut.minimumInteritemSpacing = 0
        LiberaryLayOut.minimumLineSpacing = 30
        LiberaryLayOut.scrollDirection = .horizontal

        packageCollectionView.collectionViewLayout = LiberaryLayOut
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return response.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PromotionalPackageCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.packageName_lbl.text = dict.value(forKey: "package_name") as? String ?? ""
        cell.description_txt.text = dict.value(forKey: "custom_text") as? String ?? ""
        cell.layer.cornerRadius = 15;
        cell.layer.masksToBounds = true

        if indexPath.row == 0 {
            cell.imageView.image = UIImage(named: "screen3")
        }else if indexPath.row == 1 {
            cell.imageView.image = UIImage(named: "screen1")
        }else{
            cell.imageView.image = UIImage(named: "screen2")
        }
        let duration = dict.value(forKey: "duration") as? Int
        let durations = String(duration!)
        let duration_type = dict.value(forKey: "duration_type") as? String ?? ""
        cell.duration_lbl.text = "Duration : \(durations +  duration_type)"
        let amount = dict.value(forKey: "price") as? Int ?? 0
        let myColor : UIColor = UIColor.white
        cell.amount_lbl.layer.borderWidth = 2
        cell.amount_lbl.layer.borderColor = myColor.cgColor
        cell.amount_lbl.layer.cornerRadius = 10
        cell.amount_lbl.text = String("$ \(amount)")
 
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        print(dict)
        let id = dict.value(forKey: "id") as? Int
        let amount = dict.value(forKey: "price") as? Float
        var packageType = String()
        packageType = "Promotional"
        var packageFor = String()
        packageFor = "Venue"
        
        let defaultss = UserDefaults.standard
        defaultss.set(id, forKey: "Package_Id")
        defaultss.set(amount, forKey: "TLPrice")
        defaultss.set(packageType, forKey: "Package_Type")
        defaultss.set(packageFor, forKey: "PackageFor")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardListViewController") as! CardListViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
