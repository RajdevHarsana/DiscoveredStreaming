//
//  WalkthroughScreenViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 09/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class WalkthroughScreenViewController: BaseViewController,ImageScrollerDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    
    var img_1: UIImageView = UIImageView()
    var img_2: UIImageView = UIImageView()
    var img_3: UIImageView = UIImageView()
    var window: UIWindow?
    var deafults: UserDefaults!
    var navController : UINavigationController?
    var btn_NewUser: UIButton = UIButton()
    
    
    var imageScroller: ImageScroller!
    var pageControl:UIPageControl = UIPageControl()
    
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var pageControle: UIPageControl!
    var imageArray = ["2 Walkthrough Screen(App Guide)","2 Walkthrough Screen(App Guide)","2 Walkthrough Screen(App Guide)"]
    var imageArray1 = ["1Image","2image","3image"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
       
        //testWithView(.horizontal)
        
        
        let LibariryTypeLayOut = UICollectionViewFlowLayout()
        LibariryTypeLayOut.itemSize = CGSize(width: screenWidth, height: screenHeight)
        LibariryTypeLayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        LibariryTypeLayOut.minimumInteritemSpacing = 0
        LibariryTypeLayOut.minimumLineSpacing = 0
        LibariryTypeLayOut.scrollDirection = .horizontal
        
        imageCollection.collectionViewLayout = LibariryTypeLayOut
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.move()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray1.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
//    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WalkThroughCell
        cell.imageview.image = UIImage(named: imageArray1[indexPath.item])
        
        return cell
    }
    
    
    
    //MARK:- ImageSlider with text
    fileprivate func testWithView(_ rotation: rotationWay){
        
        
        
        // ---------------------------- First Page -----------------------------
        // let img_1: UIImageView = UIImageView()
        img_1.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        img_1.image = UIImage(named: "2 Walkthrough Screen(App Guide)")
        img_1.contentMode = .scaleAspectFill
        
        
        
        
        
        
        //---------------------------- END ------------------------
        
        // ---------------------------- Second Page -----------------------------
        //let img_2: UIImageView = UIImageView()
        img_2.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        img_2.image = UIImage(named: "2 Walkthrough Screen(App Guide)")
         img_2.contentMode = .scaleAspectFill
        
        
        //---------------------------- END ------------------------
        
        // ---------------------------- Third Page -----------------------------
        //let img_3: UIImageView = UIImageView()
        img_3.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        img_3.image = UIImage(named: "2 Walkthrough Screen(App Guide)")
        img_3.contentMode = .scaleAspectFill
        
        
        
        
        
        
        
        //---------------------------- END ------------------------
        
        let viewArray: [UIImageView] = [img_1, img_2, img_3]
        
        
        let ttt: Hola = Hola(frame: CGRect(), viewArray: viewArray, rotation)
        ttt.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(ttt)
        
        self.imageScroller = ImageScroller(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.imageScroller.backgroundColor = UIColor.clear
        self.imageScroller.delegate = self
        self.imageScroller.isAutoScrollEnabled = true
        self.imageScroller.scrollTimeInterval = 2 //time interval
        self.imageScroller.scrollView.bounces = false
        self.imageScroller.setupScrollerWithImages(images:imageArray)
        self.view.addSubview(imageScroller)
       
        
        self.pageChanged(index: 0)
        
        btn_NewUser.frame = CGRect(x: (self.view.frame.size.width - 100) / 2, y: view.frame.size.height-200, width: 100, height: 30)
        btn_NewUser.setTitle("Skip", for: .normal)
        btn_NewUser.setTitleColor(UIColor(red: 255/255, green: 0/255, blue: 161/255, alpha: 1.0), for: .normal)
        btn_NewUser.titleLabel?.font = UIFont(name: "Muli-Regular", size: 18.0)
        btn_NewUser.addTarget(self, action: #selector(btn_SignInAction), for: .touchUpInside)
        btn_NewUser.titleLabel?.textAlignment = .center
        imageScroller.addSubview(btn_NewUser)
        
       
       
        imageScroller.addSubview(pageControle)
        
    }
    
    func move() {
        
        deafults = UserDefaults.standard
        let LoginLogOutStatus = deafults.string(forKey: "Logoutstatus") as NSString?
        
        if LoginLogOutStatus == "1" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "tabbar")
            navigationController?.pushViewController(vc!, animated: false)
            
        }
        else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func goToTabBar(){

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nil
        let storyboard_main = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard_main.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        appDelegate.window?.rootViewController = controller;
        
    }




    func pageChanged(index: Int) {
//        if index == 2 {
//            self.imageScroller.isAutoScrollEnabled = false
//            deafults = UserDefaults.standard
//            let LoginLogOutStatus = deafults.string(forKey: "Logoutstatus") as NSString?
//            if LoginLogOutStatus == "1" {
//                self.imageScroller.isAutoScrollEnabled = false
//                self.perform(#selector(navigateToHome), with: self, afterDelay: 1.5)
//
//            }
//            else  {
//                self.imageScroller.isAutoScrollEnabled = false
//                self.perform(#selector(navigateToLogin), with: self, afterDelay: 1.5)
//
//            }
//        }
    }
    
    @objc func btn_SignInAction() {
         self.imageScroller.isAutoScrollEnabled = false
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func navigateToHome() {
        let navigate = storyboard?.instantiateViewController(withIdentifier: "tabbar")
        navigationController?.pushViewController(navigate!, animated: false)
    }
    @objc func navigateToLogin()
    {
        let navigate = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(navigate, animated: false)
    }
    @IBAction func skipBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
