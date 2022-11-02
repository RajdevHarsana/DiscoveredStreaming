//
//  EventAllDetailsViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import MapKit
import SwiftToast
import GoogleMaps
import CoreLocation

class EventAllDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,GMSMapViewDelegate {
  

    @IBOutlet weak var performarTableview: UITableView!
    var defaults:UserDefaults!
    var userId:Int!
    var eventID:Int!
    var typeID = Int()
    var accountId:String!
    
    
    @IBOutlet weak var eventImageview: UIImageView!
    @IBOutlet weak var eventNamelbl: UILabel!
    @IBOutlet weak var eventPrice: UILabel!
    @IBOutlet weak var venenamelbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var addresslbl: UILabel!
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var performaerLblHeightCons: NSLayoutConstraint!
    @IBOutlet weak var performerTableHeightCons: NSLayoutConstraint!
    @IBOutlet weak var venuedetailViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var venuedetailview: UIView!
    
    var vaenuedetail:NSMutableDictionary!
    var perfomerArray:NSMutableArray!
    @IBOutlet weak var eventdetialScrollview: UIScrollView!
    @IBOutlet weak var mapviewnew: GMSMapView!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var mintickektLbl: UILabel!
    @IBOutlet weak var maxticketLbl: UILabel!
    @IBOutlet weak var ticketPerLbl: UILabel!
    @IBOutlet weak var ticketsliderview: UISlider!
    
    @IBOutlet weak var ticketleftTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var bookBtnHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var slidertopCons: NSLayoutConstraint!
    @IBOutlet weak var tickpertopCons: NSLayoutConstraint!
    @IBOutlet weak var maxtictopcons: NSLayoutConstraint!
    @IBOutlet weak var minticTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var ticLLbl: UILabel!
    
    @IBOutlet weak var bookticBtn: UIButton!
    
    @IBOutlet weak var viewVenueDetailTopCons: NSLayoutConstraint!
    var str_lat:String!
    var str_long:String!
    var driverMarker: GMSMarker?
    var eventuserID:Int!
    var ArtisId:Int!
    var ArtisUserId:Int!
    var ArtisName:String!
    var BandiId:Int!
    var BandiUserId:Int!
    var BandiName:String!
    
    var nameEvent:String!
    var nameVenue:String!
    var idVenue:Int!
    var addressven:String!
    var dateTimeEvent:String!
    var ImageEvent:String!
    var PriceEve:NSNumber!
    var confee:String!
    var tax:String!
    var left_ticket:Int!
    var evid:Int!
    var maxnooftic:Int!
    var maxSlideValue = Int()
    var minSlideValue = Int()
    var flag = Bool()
    
    @objc func DiscoverEventDetailAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                let test =  SwiftToast(
                    text: str_message,
                    textAlignment: .center,
                    image: UIImage(named: "ic_alert"),
                    backgroundColor: .purple,
                    textColor: .white,
                    font: .boldSystemFont(ofSize: 15.0),
                    duration: 2.0,
                    minimumHeight: CGFloat(100.0),
                    statusBarStyle: .lightContent,
                    aboveStatusBar: true,
                    target: nil,
                    style: .navigationBar)
                self.present(test, animated: true)
                self.removeAllOverlays()
            }
            else{
                
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(response)")
                self.eventImageview.sd_setImage(with: URL(string: (response.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                self.eventNamelbl.text = response.value(forKey: "event_title") as? String
                self.nameEvent =  response.value(forKey: "event_title") as? String
                self.ImageEvent = response.value(forKey: "event_image") as? String
                var str:String!
                str = response.value(forKey: "event_date") as? String
                var str1:String!
                str1 = response.value(forKey: "event_time") as? String
                self.dateTimeEvent =  str + " " + str1
                self.dateLbl.text = str + " " + str1
                
                self.descriptionLbl.text = response.value(forKey: "about_event") as? String
                var price:NSNumber!
                price = response.value(forKey: "price_per_sit") as? NSNumber
                self.PriceEve = response.value(forKey: "price_per_sit") as? NSNumber
                self.eventPrice.text = "$" + price.stringValue
               
                self.confee = response.value(forKey: "convenience_fee") as? String
                self.tax = response.value(forKey: "tax") as? String
                self.left_ticket = response.value(forKey: "ticket_left") as? Int
                self.evid = response.value(forKey: "id") as? Int
                self.accountId = response.value(forKey: "account_id") as? String
               
                var showdata:Int!
                showdata = response.value(forKey: "show_tickets_data") as? Int
               
                if showdata == 1 {
                   
                    self.maxnooftic = response.value(forKey: "no_of_ticket") as? Int
                    self.maxSlideValue = self.maxnooftic
                    var maxno = String()
                    maxno = String(self.maxnooftic)
                    self.maxticketLbl.text = maxno
                    
                    var minnooftic:Int!
                    minnooftic = response.value(forKey: "ticket_left") as? Int
                    
                    var ticbook:Int!
                    ticbook = response.value(forKey: "ticket_booked") as? Int
                    self.minSlideValue = ticbook
                    var minno = Float()
                    minno = Float(minnooftic)
                    
                    var strMin = String()
                    strMin = String(ticbook)
                    self.mintickektLbl.text = strMin
                    if minno == 0 {
                      self.ticketPerLbl.text = "0%"
                    }else {
                        var maxi:Float!
                        maxi = Float(self.maxnooftic)
                        //var perticket:Float!
                        //perticket = Float(maxi*minno/100)
                        var pertic:Int!
                        pertic = minnooftic*100/self.maxnooftic
                        var tol:Int!
                        tol = 100
                        tol -= pertic
                        self.ticketPerLbl.text =  String(tol) + "%"
                           // String(format: "%.02f %%",pertic!)
                    }
                    
                   
                    self.sliderView()
                    self.ticketleftTopCons.constant = 12
                    self.bookBtnHeightCons.constant = 38
                    self.tickpertopCons.constant = 8
                    self.maxtictopcons.constant = 3
                    self.minticTopCons.constant = 3
                    self.slidertopCons.constant = 1.5
                    self.ticLLbl.isHidden = false
                    self.ticketsliderview.isHidden = false
                    self.ticketPerLbl.isHidden = false
                    self.mintickektLbl.isHidden = false
                    self.maxticketLbl.isHidden = false
                    self.bookticBtn.isHidden = false
                    self.viewVenueDetailTopCons.constant = 25
                }else {
                    self.ticketleftTopCons.constant = 0
                    self.bookBtnHeightCons.constant = 0
                    self.tickpertopCons.constant = 0
                    self.maxtictopcons.constant = 0
                    self.minticTopCons.constant = 0
                    self.slidertopCons.constant = 0
                    self.ticLLbl.isHidden = true
                    self.ticketsliderview.isHidden = true
                    self.ticketPerLbl.isHidden = true
                    self.mintickektLbl.isHidden = true
                    self.maxticketLbl.isHidden = true
                     self.bookticBtn.isHidden = true
                    self.viewVenueDetailTopCons.constant = -60
                }
              
                
               
                
               
                   // pert + " %"

                self.perfomerArray = response.value(forKey: "performer") as? NSMutableArray
                
                if self.perfomerArray.count == 0 {
                    self.performaerLblHeightCons.constant = 0
                    self.performerTableHeightCons.constant  = 0
                    self.performarTableview.isHidden = true
                }else {
                    self.performaerLblHeightCons.constant = 20
                    self.performerTableHeightCons.constant  = 150
                     self.performarTableview.isHidden = false
                    self.performarTableview.reloadData()
                }
                self.vaenuedetail = response.value(forKey: "venue_detail") as? NSMutableDictionary
                if self.vaenuedetail == nil {
                    self.venuedetailViewHeightCons.constant = 0
                    self.venuedetailview.isHidden = true
                }else {
                self.venuedetailViewHeightCons.constant = 242
                     self.venuedetailview.isHidden = false
                self.venenamelbl.text = self.vaenuedetail.value(forKey: "venue_name") as? String
                self.nameVenue =  self.vaenuedetail.value(forKey: "venue_name") as? String
                self.venueAddress.text = self.vaenuedetail.value(forKey: "venue_name") as? String
                self.idVenue =  self.vaenuedetail.value(forKey: "id") as? Int
                var address: String!
                address = self.vaenuedetail.value(forKey: "address") as? String
                var city: String!
                city = self.vaenuedetail.value(forKey: "city") as? String
                var state: String!
                state = self.vaenuedetail.value(forKey: "state") as? String
                self.addresslbl.text = (address + " \(city ?? "")" + " \(state ?? "")")
                self.addressven = (address + " \(city ?? "")" + " \(state ?? "")")
                self.venueImage.sd_setImage(with: URL(string: (self.vaenuedetail.value(forKey: "venue_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                }
                self.str_lat = response.value(forKey: "lat") as? String
                self.str_long = response.value(forKey: "lng") as? String
                
                if self.str_lat == "" || self.str_long == "" {
                    
                }else {
                    let morelat = Double(self.str_lat)
                    let morelong = Double(self.str_long)
                    
                    print(self.str_lat!)
                    print(self.str_long!)
                    self.driverMarker = GMSMarker()
                    self.driverMarker?.position = CLLocationCoordinate2DMake(morelat!, morelong!)
                    self.driverMarker?.icon = UIImage(named: "")
                    self.driverMarker?.map = self.mapviewnew
                    let updatedCamera = GMSCameraUpdate.setTarget((self.driverMarker?.position)!, zoom: 14.0)
                    self.mapviewnew.animate(with: updatedCamera)
                }
                
               
                self.removeAllOverlays()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if flag == true{
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        eventID = typeID
        }else{
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        eventID = defaults.integer(forKey: "EventID")
        eventuserID = defaults.integer(forKey: "EventUserID")
        }
//        if eventuserID == userId {
//          shareBtn.isHidden = false
//        }else {
//           shareBtn.isHidden = true
//        }
        
      
        mapviewnew.delegate = self
        vaenuedetail = NSMutableDictionary()
        perfomerArray = NSMutableArray()
         if Reachability.isConnectedToNetwork() == true {
        showWaitOverlay()
        Parsing().DiscoverEventDetail(UserId: userId, EventId: eventID, ArtistId: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventDetailAction), name: NSNotification.Name(rawValue: "DiscoverEventDetail"), object: nil)
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
        }
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
        addresslbl.addGestureRecognizer(tap)
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
//        self.ticketsliderview.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VenueDetailViewController") as! VenueDetailViewController
        let flag = true
        vc.flag = flag
        vc.nameVenue = nameVenue
        vc.notiId = idVenue
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func sliderView(){
        
        ticketsliderview.minimumValue = 0
        ticketsliderview.maximumValue = Float(self.maxSlideValue)
        ticketsliderview.isContinuous = true
        ticketsliderview.value = Float(self.minSlideValue)
        ticketsliderview.setNeedsLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        //  print("A")

        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)

        let positionOfSlider: CGPoint = ticketsliderview.frame.origin
        let widthOfSlider: CGFloat = ticketsliderview.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(ticketsliderview.maximumValue) / widthOfSlider)

        ticketsliderview.setValue(Float(newValue), animated: true)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = coordinate
        let defaults = UserDefaults.standard
        defaults.set(str_lat, forKey: "lati")
        defaults.set(str_long, forKey: "long")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "VenueLocationViewController") as! VenueLocationViewController
        self.navigationController?.present(vc, animated: true, completion: nil)
       // self.showAnimate(YourHiddenView: self.MapHiddenView, ishidden: false)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return perfomerArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PerformerCell
        var dict = NSDictionary()
        dict = perfomerArray.object(at: indexPath.row) as! NSDictionary
        var listype:String!
        listype = dict.value(forKey: "list_type") as? String
        if listype == "artist" {
            cell.performerImage.sd_setImage(with: URL(string: (dict.value(forKey: "artist_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.performenameLbl.text = dict.value(forKey: "artist_name") as? String
            var city:String!
            city = dict.value(forKey: "city") as? String
            
            var state:String!
            state = dict.value(forKey: "state") as? String
            
            
            cell.performerAddlbl.text = city + " ," + state
           // cell.performerAddlbl.text = dict.value(forKey: "description") as? String
        }else {
            cell.performerImage.sd_setImage(with: URL(string: (dict.value(forKey: "band_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.performenameLbl.text = dict.value(forKey: "band_name") as? String
            var city:String!
            city = dict.value(forKey: "city") as? String
            
            var state:String!
            state = dict.value(forKey: "state") as? String
            
            
            cell.performerAddlbl.text = city + " ," + state
           // cell.performerAddlbl.text = dict.value(forKey: "description") as? String
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = perfomerArray.object(at: indexPath.row) as! NSDictionary
        var listype:String!
        listype = dict.value(forKey: "list_type") as? String
        if listype == "artist" {
        ArtisId = dict.value(forKey: "id") as? Int
        ArtisUserId = dict.value(forKey: "user_id") as? Int
        ArtisName = dict.value(forKey: "artist_name") as? String
        let defaults = UserDefaults.standard
        defaults.set(ArtisId, forKey: "ArtistID")
        defaults.set(ArtisUserId, forKey: "ArUserId")
        defaults.set(ArtisName, forKey: "ArName")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistDetailViewController") as! ArtistDetailViewController
        navigationController?.pushViewController(vc, animated: true)
        }else {
            var dict = NSDictionary()
            dict = perfomerArray.object(at: indexPath.row) as! NSDictionary
            BandiId = dict.value(forKey: "id") as? Int
            BandiUserId = dict.value(forKey: "user_id") as? Int
            BandiName = dict.value(forKey: "band_name") as? String
            let defaults = UserDefaults.standard
            defaults.set(BandiId, forKey: "BandID")
            defaults.set(BandiUserId, forKey: "BandUserID")
            defaults.set(BandiName, forKey: "BandName")
            defaults.synchronize()
            let vc = storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookticketBtnAction(_ sender: Any) {
         let defaults = UserDefaults.standard
         defaults.set(nameVenue, forKey: "NVEN")
         defaults.set(nameEvent, forKey: "NEVE")
         defaults.set(addressven, forKey: "ADDEVE")
         defaults.set(dateTimeEvent, forKey: "DTEVE")
         defaults.set(PriceEve.stringValue, forKey: "PriceEve")
         defaults.set(ImageEvent, forKey: "ImageEVE")
         defaults.set(confee, forKey: "ConFee")
         defaults.set(tax, forKey: "Tax")
         defaults.set(left_ticket, forKey: "Tickleft")
         defaults.set(evid, forKey: "EveId")
         defaults.set(accountId, forKey: "ACCOUNTID")
         defaults.synchronize()
         let vc = storyboard?.instantiateViewController(withIdentifier: "BookTicketsViewController") as! BookTicketsViewController
         navigationController?.pushViewController(vc, animated: true)
     }
    @IBAction func shareBtnAction(_ sender: Any) {
        let text = "This is some text that I want to share."
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        activityViewController.popoverPresentationController?.sourceRect = self.navigationController?.navigationBar.frame ?? CGRect.zero
        activityViewController.popoverPresentationController?.sourceView = self.navigationController?.navigationBar
        self.present(activityViewController, animated: true)
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
            
        ticketPerLbl.text = "\(currentValue)"
    }
   
}
