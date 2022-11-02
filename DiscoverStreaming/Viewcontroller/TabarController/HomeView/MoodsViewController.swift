//
//  MoodsViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class MoodsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var moodsCollectionVioew: UICollectionView!
    var MoodsId:Int!
    var listName:String!
    let IS_IPHONE_7 = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
    var response = NSMutableArray()
    //MARK:- Login WebService
    @objc func DiscoverGenresAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
                
                
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(self.response)")
                self.moodsCollectionVioew.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moodsCollectionVioew.delegate = self
        moodsCollectionVioew.dataSource = self
        
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().GetGenresList()
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverGenresAction), name: NSNotification.Name(rawValue: "GetGenresListNotification"), object: nil)
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

        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return response.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoodsListCell
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.moodImageView.text = dict.value(forKey: "genre_name") as? String
        cell.moodsImage.sd_setImage(with: URL(string: (dict.value(forKey: "image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        MoodsId = dict.value(forKey: "id") as? Int
        listName = dict.value(forKey: "genre_name") as? String
        let defaults = UserDefaults.standard
        defaults.set(MoodsId, forKey: "MoodsID")
        defaults.set(listName, forKey: "MoodsName")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "MoodsSongViewController") as! MoodsSongViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if IS_IPHONE_7{
//            let height = view.frame.size.height
//            let width = view.frame.size.width
//            // in case you you want the cell to be 40% of your controllers view
//            return CGSize(width: width * 0.44, height: height * 0.18)
//        }else{
            let height = view.frame.size.height
            let width = view.frame.size.width
            // in case you you want the cell to be 40% of your controllers view
            return CGSize(width: width * 0.44, height: height * 0.18)
//        }
        
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
