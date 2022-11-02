//
//  FeaturedPackageViewController.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 30/07/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class FeaturedPackageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var artistPackageCollectionView: UICollectionView!
    let screenWidth = UIScreen.main.bounds.size.width
    let screenheight = UIScreen.main.bounds.size.height
    var defaults :UserDefaults!
    var Arsts:String!
    var user_id:Int!
    var response = NSMutableArray()
    var packageForId:Int!
    
    @objc func DiscoveredFeaturedArtistPlanAction (_ notification: Notification){
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
                self.artistPackageCollectionView.reloadData()
                self.removeAllOverlays()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.artistPackageCollectionView.delegate = self
        self.artistPackageCollectionView.dataSource = self

        defaults = UserDefaults.standard
        packageForId = defaults.value(forKey: "ArtistID") as? Int ?? 0
        
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().GetFeaturedArtistPlanList()
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoveredFeaturedArtistPlanAction), name: NSNotification.Name(rawValue: "GetFaeturedArtistPlanListNotification"), object: nil)
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

        artistPackageCollectionView.collectionViewLayout = LiberaryLayOut
        // Do any additional setup after loading the view.
    }
    

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return response.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeaturedPackageCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        
        cell.artistPlanName_lbl.text = dict.value(forKey: "package_name") as? String ?? ""
        cell.descriptinn_txt.text = dict.value(forKey: "custom_text") as? String ?? ""
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
        cell.music_img.image = UIImage(named: "music-disc")
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        let id = dict.value(forKey: "id") as? Int ?? 0
        let amount = dict.value(forKey: "price") as? Float ?? 0
        var packageType = String()
        packageType = "Featured"
        var packageFor = String()
        packageFor = "Artists"
        
        let packageArtistId = packageForId ?? 0
        
        let defaultss = UserDefaults.standard
        defaultss.set(id, forKey: "Package_Id")
        defaultss.set(amount, forKey: "TLPrice")
        defaultss.set(packageType, forKey: "Package_Type")
        defaultss.set(packageFor, forKey: "PackageFor")
        defaultss.set(packageArtistId, forKey: "PackageForId")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardListViewController") as! CardListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
