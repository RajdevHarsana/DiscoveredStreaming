//
//  AppDelegate.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 26/06/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AVFoundation
import IQKeyboardManagerSwift
import UserNotifications
import FirebaseCore
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import FBSDKCoreKit
import TwitterCore
import TwitterKit
import Stripe
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate,CLLocationManagerDelegate {
    
    var window: UIWindow?
    var defaults:UserDefaults!
    var navController : UINavigationController?
    var storyboard = UIStoryboard()
    var locationManager = CLLocationManager()
    var str_lat:NSString!
    var str_long:NSString!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("Database FilePath: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "NotFound")
        
        DispatchQueue.main.async {
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        } else {
            print("Location services are not enabled");
        }
        }
        
        defaults = UserDefaults.standard
        defaults.removeObject(forKey: "ORDERTYPE")
        defaults.removeObject(forKey: "SORTORDER")
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setActive(true)
            try session.setCategory(AVAudioSession.Category.playback)
        } catch{
            print(error.localizedDescription)
        }
        
        IQKeyboardManager.shared.enable = true
        
        if #available(iOS 13.0, *) {
        }else {
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = UIColor.clear
            }
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        
        GMSServices.provideAPIKey("AIzaSyB3F_B_YH0XuWy_EB-zK-w4hyNJ1vjEJqQ")
        GMSPlacesClient.provideAPIKey("AIzaSyB3F_B_YH0XuWy_EB-zK-w4hyNJ1vjEJqQ")
        // STPPaymentConfiguration.shared().publishableKey = "pk_test_IeR8DmaKtT6Gi5W7vvySoCiO"
        Stripe.setDefaultPublishableKey("pk_test_IeR8DmaKtT6Gi5W7vvySoCiO")
        FirebaseApp.configure()
        //        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {__, _  in })
            // For iOS 10 data message (sent via FCM
            
            Messaging.messaging().delegate = self
        }else{
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            Messaging.messaging().delegate = self
        }
        application.registerForRemoteNotifications()
        
        
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        TWTRTwitter.sharedInstance().start(withConsumerKey: "0tCkRl2OcdW4PU64SZLc6MPyL", consumerSecret: "793zQzifo6Z8VEOiW2zB5rZuSVo7OnFGhsF4OOaHaG9nctSSac")
        
        
        window = UIWindow(frame:UIScreen.main.bounds)
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigate = storyboard.instantiateViewController(withIdentifier: "WalkthroughScreenViewController") as! WalkthroughScreenViewController
        navController = UINavigationController(rootViewController: navigate)
        window?.rootViewController = navController
        navigate.navigationController?.navigationBar.isHidden = true
        window?.makeKeyAndVisible()
        
        // Initialize Google Mobile Ads SDK
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
            [ "2077ef9a63d2b398840261c8221a0c9b" ] // Sample device ID
        
        
        // Override point for customization after application launch.
        return true
    }
    
    private func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
         if (error) != nil {
            print(error)
         }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let userLocation:CLLocation = locations[0] as CLLocation
            
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
            
            print("\(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
            
            str_lat = ((String(userLocation.coordinate.latitude) as NSString))
            str_long = ((String(userLocation.coordinate.longitude) as NSString))
            print("lat: \(String(describing: str_lat))")
            print("long: \(String(describing: str_long))")
            let defaults = UserDefaults.standard
            defaults.set(str_lat, forKey: "LAT")
            defaults.set(str_long, forKey: "LONG")
            defaults.synchronize()
            
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            geocoder.reverseGeocodeLocation(location) {
                (placemarks, error) -> Void in
                // print(placemarks!)
                //            if let placemarks = placemarks as? [CLPlacemark], placemarks.count > 0 {
                //                var placemark = placemarks[0]
                //                print(placemark.addressDictionary)
            }
            
            if userLocation.coordinate.latitude>0  {
                
                manager.stopUpdatingLocation()
            }
            
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
            Messaging.messaging().apnsToken = deviceToken
            Messaging.messaging().isAutoInitEnabled = true
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let deafults = UserDefaults.standard
        deafults.set(fcmToken, forKey: "Devicetoken")
        deafults.synchronize()
        print("Firebase registration token: \(fcmToken)")
    }
    
    func  application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        //        let sourceApplication =  options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        //        let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
        //
        //
        //        let facebookHandler = ApplicationDelegate.shared.application (
        //            application,
        //            open: url,
        //            sourceApplication: sourceApplication,
        //            annotation: annotation )
        //
        //        let twitterHandler = TWTRTwitter.sharedInstance().application(application, open: url, options: options)
        //  return googleHandler
        //return googleHandler || facebookHandler
        
        // return facebookHandler || twitterHandler
        let handled: Bool = ApplicationDelegate.shared.application(application, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        //  Add any custom logic here.
        return handled
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK:- Click on notification click
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let userInfo = userInfo as! [String: Any]
        print(userInfo)
        let type = DataManager.getVal(userInfo["type"]) as! String
        
    }
    private func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        //Handle the notification
        completionHandler(
            [UNNotificationPresentationOptions.alert,
             UNNotificationPresentationOptions.sound,
             UNNotificationPresentationOptions.badge])
    }
    
    // MARK:- Function will call when application in active state
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        let userInfo = notification.request.content.userInfo as! [String: Any]
        print(userInfo)
        let typeId = DataManager.getVal(userInfo["type_id"]) as! String
    }
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
}

