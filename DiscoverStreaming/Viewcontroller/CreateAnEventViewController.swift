//
//  CreateAnEventViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 05/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import Stripe
import SwiftToast


class CreateAnEventViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UISearchBarDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,STPPaymentCardTextFieldDelegate {
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var artistTable: UITableView!
    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var CameraBtn: UIButton!
    @IBOutlet weak var EventNameTxt: FloatLabelTextField!
    @IBOutlet weak var DateTimeTxt: FloatLabelTextField!
    @IBOutlet weak var VenueNameTxt: FloatLabelTextField!
    @IBOutlet weak var PricePerSearTxt: FloatLabelTextField!
    @IBOutlet weak var NumberOfTicketsTxt: FloatLabelTextField!
    @IBOutlet weak var timeTxt: FloatLabelTextField!
    @IBOutlet weak var aboutTxtview: UITextView!
    
    @IBOutlet weak var venueAddressTxt: FloatLabelTextField!
    @IBOutlet weak var searchTxt: UISearchBar!
    
    @IBOutlet weak var priceHeightCons: NSLayoutConstraint!
    @IBOutlet weak var pricelineheightCons: NSLayoutConstraint!
    
    @IBOutlet weak var numberofticHeightcons: NSLayoutConstraint!
    
    @IBOutlet weak var abouttopCons: NSLayoutConstraint!
    @IBOutlet weak var noofticlinehegitCons: NSLayoutConstraint!
    
    @IBOutlet weak var cardnumber: UIImageView!
    @IBOutlet weak var cardViewHeightcons: NSLayoutConstraint!
    @IBOutlet weak var stripCardView: UIView!
    
    var cardtextfield:STPPaymentCardTextField!
    var str_cardNumber:NSString!
    var str_cardcvv:NSString!
    var str_cardexpmonth:NSString!
    var str_cardexpyear:NSString!
    
    var picker = UIImagePickerController()
    var response: NSMutableArray!
    var defaults:UserDefaults!
    var user_Id:Int!
    var arryFav = NSMutableArray()
    var InviteArray:NSMutableArray!
    var BandArray:NSMutableArray!
    var selectedIndexes:NSMutableArray!
    var chosenImage = UIImage()
    var imagedata: Data!
    var ArtistId:Int!
    var BandId:Int!
    var venueId:Int!
    var venuename:String!
    var EventType = ["Paid","Free"]
    var eventtype:UIPickerView = UIPickerView()
    
    var str_eventName:NSString!
    var str_Datetime:NSString!
    var str_time:NSString!
    var str_VenueName:NSString!
    var str_PricePerSeat:NSString!
    var str_NoOftickets:NSString!
    var str_AboutEvent:NSString!
    var str_vanueAddress:NSString!
  //  var str_Gethering:NSString!
    var str_lat:String!
    var str_long:String!
    var city:String!
    var state:String!
    var country:String!
    var zipcode:Int!
    var datePickerView  : UIDatePicker = UIDatePicker()
    var datePickerView1  : UIDatePicker = UIDatePicker()
    var searchplace = String()
    var searchActive = false
    var venueAd:String!
    var eventTy:String!
    var customerId:String!
    var accountId:String!
    
    var searchTextField: UITextField? {
        let subViews = self.searchTxt.subviews.first?.subviews.last?.subviews
        return subViews?.first as? UITextField
    }
    
    
    //MARK:- Login WebService
    @objc func DiscoverArtistListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.artistTable.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    
    //MARK:- Create Artist WebService
    @objc func CreateEventActionPending(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateEvent"), object: nil)
                self.removeAllOverlays()
            }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PendingUserEventViewController") as! PendingUserEventViewController
                self.navigationController?.pushViewController(vc, animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateEvent"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- Create Artist WebService
    @objc func CreateEventActionPublish(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateEvent"), object: nil)
                self.removeAllOverlays()
            }
            else{
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name("CreateEvent"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateEvent"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- Login WebService
    @objc func DiscoverSearchArtistListAction(_ notification: Notification) {
        
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
                self.response.removeAllObjects()
                self.artistTable.reloadData()
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.artistTable.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        customerId = defaults.value(forKey: "CUSTOMERID") as? String
        accountId = defaults.value(forKey: "Account_ID") as? String
        updateBtn.layer.cornerRadius = 25
        publishBtn.layer.cornerRadius = 25
        self.cardViewHeightcons.constant = 0
        self.stripCardView.isHidden = true
        response = NSMutableArray()
        selectedIndexes = NSMutableArray()
        InviteArray = NSMutableArray()
        BandArray = NSMutableArray()
        DateTimeTxt.delegate = self
        timeTxt.delegate = self
        aboutTxtview.delegate = self
        aboutTxtview.text = "About the event"
        VenueNameTxt.delegate = self
        EventNameTxt.delegate = self
        PricePerSearTxt.delegate = self
        NumberOfTicketsTxt.delegate = self
        eventtype.delegate = self
        eventtype.dataSource = self
        cardnumber.isHidden = true
        EventNameTxt.resignFirstResponder()
        DateTimeTxt.resignFirstResponder()
        timeTxt.resignFirstResponder()
        VenueNameTxt.resignFirstResponder()
        venueAddressTxt.resignFirstResponder()
        PricePerSearTxt.resignFirstResponder()
        NumberOfTicketsTxt.resignFirstResponder()
        EventNameTxt.attributedPlaceholder = NSAttributedString(string:"Event Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        DateTimeTxt.attributedPlaceholder = NSAttributedString(string:"Date", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        timeTxt.attributedPlaceholder = NSAttributedString(string:"Time", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        VenueNameTxt.attributedPlaceholder = NSAttributedString(string:"Venue Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        venueAddressTxt.attributedPlaceholder = NSAttributedString(string:"Event Type", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        PricePerSearTxt.attributedPlaceholder = NSAttributedString(string:"Price per seat(€)", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        NumberOfTicketsTxt.attributedPlaceholder = NSAttributedString(string:"Number of tickets available", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        venueAddressTxt.inputView = eventtype
        self.priceHeightCons.constant = 0
        self.pricelineheightCons.constant = 0
        self.numberofticHeightcons.constant = 0
        self.noofticlinehegitCons.constant = 0
        self.abouttopCons.constant = -30
        NumberOfTicketsTxt.delegate = self
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        DateTimeTxt.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
        datePickerView1.datePickerMode = UIDatePicker.Mode.time
        timeTxt.inputView = datePickerView1
        datePickerView1.addTarget(self, action: #selector(handleDatePicker1(sender:)), for: UIControl.Event.valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("emptyfield"), object: nil)
          self.searchTxt.delegate = self
        if #available(iOS 13.0, *) {
            searchTextField?.placeholder = "Search..."
            self.searchTextField?.textAlignment = NSTextAlignment.left
            searchTextField?.textColor = UIColor.white
            searchTextField?.backgroundColor = UIColor.clear
            searchTextField?.borderStyle = .none
            searchTextField?.clearButtonMode = .never
            searchTextField?.textAlignment = NSTextAlignment.left
        }else {
            let searchfield = self.searchTxt.subviews[0].subviews.last as! UITextField
            searchfield.placeholder = "Search..."
            searchfield.textColor = UIColor.white
            searchfield.backgroundColor = UIColor.clear
            searchfield.borderStyle = .none
            searchfield.textAlignment = NSTextAlignment.left
        }
        stripeMethod()
      
       
        
        if Reachability.isConnectedToNetwork() == true {
        Parsing().DiscoverArtistBandListing(user_Id: user_Id)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistListAction), name: NSNotification.Name(rawValue: "DiscoverArtistBandListing"), object: nil)
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
    
    
    func stripeMethod() {
        let paymentTextField = STPPaymentCardTextField()
        let cardParams = STPPaymentMethodCardParams()
        // Only successful 3D Secure transactions on this test card will succeed.
        //cardParams.number = @"4000000000003063";
        //cardParams.cvc = @"232";
        paymentTextField.cardParams = cardParams
        paymentTextField.delegate = self
        paymentTextField.cursorColor = UIColor.yellow
        paymentTextField.textColor = UIColor.white
        paymentTextField.resignFirstResponder()
        cardtextfield = paymentTextField
        cardtextfield.layer.borderColor = UIColor.white.cgColor
       // self.cardnumber.addSubview(paymentTextField)
        self.stripCardView.addSubview(paymentTextField)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 11
        let width: CGFloat = view.frame.width - (padding * 4.2)
        cardtextfield.frame = CGRect(x: padding , y: 53, width: width, height: 50)
        cardtextfield.resignFirstResponder()
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
            updateBtn.isEnabled = textField.isValid
            publishBtn.isEnabled = textField.isValid
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
      eventImage.image = UIImage(named: "")
        EventNameTxt.text = ""
        DateTimeTxt.text = ""
        timeTxt.text = ""
        VenueNameTxt.text = ""
        venueAddressTxt.text = ""
        PricePerSearTxt.text = ""
        NumberOfTicketsTxt.text = ""
        aboutTxtview.text = ""
        InviteArray.removeAllObjects()
        
    }
    
    // PickerView Delegate.....
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return EventType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EventType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if row == 0 {
            eventTy = "1"
//            self.cardtextfield.clear()
            self.priceHeightCons.constant = 50
            self.PricePerSearTxt.isHidden = false
             self.pricelineheightCons.constant = 1
             self.numberofticHeightcons.constant = 50
            self.NumberOfTicketsTxt.isHidden = false
             self.noofticlinehegitCons.constant = 1
            self.abouttopCons.constant = 15
            if accountId == ""{
              self.cardViewHeightcons.constant = 128
              self.stripCardView.isHidden = false
            }else{
              self.cardViewHeightcons.constant = 0
              self.stripCardView.isHidden = true
            }
            venueAddressTxt.text = EventType[row]
        }else {
//            self.cardtextfield.clear()
            self.priceHeightCons.constant = 0
            self.PricePerSearTxt.isHidden = true
            self.pricelineheightCons.constant = 0
            self.numberofticHeightcons.constant = 50
            self.NumberOfTicketsTxt.isHidden = false
            self.noofticlinehegitCons.constant = 1
            self.abouttopCons.constant = 10
            self.cardViewHeightcons.constant = 0
            self.stripCardView.isHidden = true
            eventTy = "2"
            venueAddressTxt.text = EventType[row]
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == PricePerSearTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 8
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
        }else  if textField == EventNameTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 55
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
        }else  if textField == NumberOfTicketsTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 8
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
        }
        else {
            return true
        }
    }
    func isBlank (_ textfield:UITextField) -> Bool {
        
        let thetext = textfield.text
        let trimmedString = thetext!.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedString.isEmpty {
            return true
        }
        return false
    }
    func validate(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
    
    func validate(whiteSpaceString: String) -> Bool {
        return whiteSpaceString.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    // textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "About the event" {
            textView.text = ""
            textView.textColor = UIColor.white
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        if textView.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            guard range.location == 0 else {
                return true
            }
            let currentString: NSString = (textView.text ?? "About the event") as NSString
            let newString = currentString.replacingCharacters(in: range, with: text)
            return  validate(string: newString)
        }else {
            
            let maxLength = 255
            let currentString: NSString = textView.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= maxLength
        }
        // return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "About the event"
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         if Reachability.isConnectedToNetwork() == true {
        searchBar.resignFirstResponder()
       
        showWaitOverlay()
        Parsing().DiscoverArtistBandListing(user_Id: user_Id)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistListAction), name: NSNotification.Name(rawValue: "DiscoverArtistBandListing"), object: nil)
        searchBar.resignFirstResponder()
        searchActive = false
        }else
         {
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
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         if Reachability.isConnectedToNetwork() == true{
        if searchBar.text == "" {
            searchBar.resignFirstResponder()
            Parsing().DiscoverArtistBandListing(user_Id: user_Id)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistListAction), name: NSNotification.Name(rawValue: "DiscoverArtistBandListing"), object: nil)
        }else {
            searchBar.resignFirstResponder()
            showWaitOverlay()
            Parsing().DiscoverSearch(UserId: user_Id, SearchType: "band_and_artist_search", SearchKetword: searchBar.text, Offset: 0)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSearchArtistListAction), name: NSNotification.Name(rawValue: "DiscoverSearchNotification"), object: nil)
        }
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
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchplace = searchText
    }
   
    
    //MARK:- Date Button Action
    @objc func handleDatePicker(sender: UIDatePicker) {
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: datePickerView.date)
        DateTimeTxt.text = dateString
       
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == VenueNameTxt {
                let nextview = VenueListView.intitiateFromNib()
                let model = NewPopModel()
                nextview.buttonDoneHandler = {
                    self.defaults = UserDefaults.standard
                    self.venueId = self.defaults.integer(forKey: "VID")
                    self.venueAd = self.defaults.value(forKey: "VADD") as? String
                    self.venuename = self.defaults.value(forKey: "VNAME") as? String
                    self.str_lat = self.defaults.value(forKey: "LAT") as? String
                    self.str_long = self.defaults.value(forKey: "LONG") as? String
                    self.city = self.defaults.value(forKey: "CITY") as? String
                    self.state = self.defaults.value(forKey: "STATE") as? String
                    self.country = self.defaults.value(forKey: "COUNTRY") as? String
                    self.zipcode = self.defaults.integer(forKey: "ZIPCODE")
                    var zip:String!
                    zip = String(self.zipcode)
                   // self.venueAddressTxt.text = self.venueAd + " " + self.city + " " + self.state + " " + self.country + " " + zip
                    self.VenueNameTxt.text = self.venuename
                    model.closewithAnimation()
                }
                nextview.buttonCancleHandler = {
                    model.closewithAnimation()
                }
                model.show(view: nextview)
            
        }else if textField == DateTimeTxt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            DateTimeTxt.text = dateString
        }else if  textField == timeTxt {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "hh:mm"
            let dateString1 = dateFormatter1.string(from: datePickerView1.date)
             timeTxt.text = dateString1
        }
     
    }
    
    //MARK:- Date Button Action
    @objc func handleDatePicker1(sender: UIDatePicker) {
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let dateString = dateFormatter.string(from: datePickerView1.date)
        timeTxt.text = dateString
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if response.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Artist/Band Found"
            
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InviteBecomeArtistCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        
        var DataType = String()
        DataType = dict.value(forKey: "data_type") as! String
        
        if DataType == "2" {
            cell.ArtistName.text = dict.value(forKey: "artist_name") as? String
            cell.ArtistImage.sd_setImage(with: URL(string: (dict.value(forKey: "artist_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.bandNameLbl.text = "Artist"
            var city:String!
            city = dict.value(forKey: "city") as? String
            var state:String!
            state = dict.value(forKey: "state") as? String
            cell.ArtistDes.text = city + " " + state
            if InviteArray.contains(dict.object(forKey: "id")!) {
                cell.inviteBtn.setTitle("Joined", for: .normal)
            } else {
                cell.inviteBtn.setTitle("Invite", for: .normal)
            }
        }else {
            cell.ArtistName.text = dict.value(forKey: "band_name") as? String
            cell.ArtistImage.sd_setImage(with: URL(string: (dict.value(forKey: "band_image") as? String)!), placeholderImage: UIImage(named: "Artist_img_3"))
            var city:String!
            city = dict.value(forKey: "city") as? String
            var state:String!
            state = dict.value(forKey: "state") as? String
            cell.ArtistDes.text = city + " " + state
            cell.bandNameLbl.text = "Band"
            if BandArray.contains(dict.object(forKey: "id")!) {
                cell.inviteBtn.setTitle("Joined", for: .normal)
            } else {
                cell.inviteBtn.setTitle("Invite", for: .normal)
            }
        }
      
        cell.inviteBtn.tag = indexPath.row
        cell.inviteBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        return cell
    }
    @objc func handleTap(_ sender:UIButton) {
        var btn = sender as? UIButton
        let dict1 = response.object(at: (btn?.tag)!) as! NSDictionary
        var DataType = String()
        DataType = dict1.value(forKey: "data_type") as! String
        if DataType == "2" {
          //  var id = String()
           // id = dict1.value(forKey: "id") as! String
             ArtistId = dict1.value(forKey: "id") as? Int
             BandId = 0
        }else {
             BandId = dict1.value(forKey: "id") as? Int
             ArtistId = 0
        }
       
        let myIP = IndexPath(row: sender.tag, section: 0)
        let cell1 = artistTable.cellForRow(at: myIP) as? InviteBecomeArtistCell
        
        
        
        if selectedIndexes == nil {
            
            selectedIndexes = [AnyHashable]() as? NSMutableArray
        }
        if selectedIndexes.contains((btn?.tag)!) {
            selectedIndexes.remove((btn?.tag)!)
            InviteArray.remove(ArtistId!)
            BandArray.remove(BandId!)
            cell1!.inviteBtn.setTitle("Invite", for: .normal)
            
            
        }
        else {
            selectedIndexes.add((btn?.tag)!)
            InviteArray.add(ArtistId!)
            BandArray.add(BandId!)
            cell1!.inviteBtn.setTitle("Joined", for: .normal)
            
        }
      //  let indexPath = NSIndexPath(row: (btn?.tag)!, section: 0)
       // artistTable.reloadRows(at: [indexPath as IndexPath], with: .none)
       // artistTable.reloadData()
        
    }
    @IBAction func CameraBtnAction(_ sender: Any) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera() {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.camera
        present(picker, animated: true, completion: nil)
    }
    func openGallary()
    {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        chosenImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        eventImage.image = chosenImage
        eventImage.image = self.resizeImage(chosenImage)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY hh:mm:ss"
        let dateExtension = formatter.string(from: date)
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dateExtension).appending(".png")
        print(paths)
        
        imagedata = chosenImage.jpegData(compressionQuality: 0.5)
       // CameraBtn.isHidden = true
        fileManager.createFile(atPath: paths as String, contents: imagedata, attributes: nil)
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func resizeImage(_ image:UIImage) -> UIImage
    {
        let actualHeight = Int(image.size.height);
        let actualWidth = Int(image.size.width);
        let compressionQuality:CGFloat = 0.3;//50 percent compression
        
        let newsizeWidth = CGFloat( actualWidth ) * CGFloat(compressionQuality)
        let newsizeHeight = CGFloat( actualHeight ) * CGFloat(compressionQuality)
        let newSize = CGSize(width: newsizeWidth , height: newsizeHeight);
        
        // Scale the original image to match the new size.
        UIGraphicsBeginImageContext(newSize);
        image.draw(in: CGRect(x: 0, y: 0 , width: newSize.width , height: newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        return compressedImage!
        
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateBtbaction(_ sender: Any) {
        if eventTy == "1" {
            str_cardNumber = cardtextfield.cardNumber! as NSString
            str_cardcvv = cardtextfield.cardParams.cvc! as NSString
            str_cardexpyear = cardtextfield.cardParams.expYear?.stringValue as? NSString
            str_cardexpmonth = cardtextfield.cardParams.expMonth?.stringValue as? NSString
            str_eventName = EventNameTxt.text as NSString?
            str_Datetime  = DateTimeTxt.text as NSString?
            str_time = timeTxt.text as NSString?
            str_VenueName = VenueNameTxt.text as NSString?
            str_PricePerSeat = PricePerSearTxt.text as NSString?
            str_NoOftickets = NumberOfTicketsTxt.text as NSString?
            str_AboutEvent = aboutTxtview.text as NSString?
            str_vanueAddress = venueAddressTxt.text as NSString?
            
            if str_eventName .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please Enter Event Name",
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
            }else if str_Datetime .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Event Date",
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
            }else if str_time .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Event Time",
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
            else if str_VenueName .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Venue Name",
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
            }else if str_vanueAddress .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Event Type",
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
            else if str_PricePerSeat .isEqual(to:  "") {
                let test =  SwiftToast(
                    text: "Please Enter Price Per Seat",
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
            }else if str_NoOftickets .isEqual(to:  "") {
                let test =  SwiftToast(
                    text: "Please Enter Number of Tickets",
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
            }else if str_AboutEvent .isEqual(to:  "About the event") {
                let test =  SwiftToast(
                    text: "Please Enter About Event",
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
            } else if InviteArray.count == 0 {
                let test =  SwiftToast(
                    text: "Please Select Invited Artist",
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
            }else {
                if Reachability.isConnectedToNetwork() == true {
                    showWaitOverlay()
                    let data = CreateEventModel()
                    if imagedata == nil {
                        
                    }
                    else {
                        data.Event_Image = imagedata as NSData
                    }
                    if accountId == "" {
                        if str_cardNumber .isEqual(to: "") {
                            let test =  SwiftToast(
                                text: "Enter card Number",
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
                            
                        }else if str_cardcvv .isEqual(to: "") {
                            let test =  SwiftToast(
                                text: "Enter card CVV",
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
                           
                        }else if str_cardexpmonth .isEqual(to: "") {
                            let test =  SwiftToast(
                                text: "Enter card expire month",
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
                            
                        }else if str_cardexpyear .isEqual(to: "") {
                            let test =  SwiftToast(
                                text: "Enter card expire year",
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
                        data.UserId = user_Id
                        data.EventName = str_eventName as String
                        data.EventDate = str_Datetime as String
                        data.EventTime = str_time as String
                        data.VenueID = venueId
                        data.EventPricePerSeat = str_PricePerSeat as String
                        data.EventNoOftickets = str_NoOftickets as String
                        data.AboutEvent = str_AboutEvent as String
                        data.cardNumber = str_cardNumber as String
                        data.cardexpmonth = str_cardexpmonth as String
                        data.cardexpyear = str_cardexpyear as String
                        data.cardcvv = str_cardcvv as String
                        data.Event_Status = "Pending"
                        data.latittude = str_lat
                        data.longitude = str_long
                        data.VenueAddress = "1"
                        
                        let  typeIdArrayString1 = self.JSONStringify(value: InviteArray as AnyObject)
                        print(typeIdArrayString1)
                        data.Invite_Artist = typeIdArrayString1
                        
                        let  typeIdArrayString2 = self.JSONStringify(value: BandArray as AnyObject)
                        print(typeIdArrayString2)
                        data.Invite_Band = typeIdArrayString2
                        
                        let parameterDictionary = NSMutableDictionary()
                        parameterDictionary.setObject(DataManager.getVal(data.UserId), forKey: "user_id" as NSCopying )
                        parameterDictionary.setValue(DataManager.getVal(data.EventName), forKey: "event_title")
                        parameterDictionary.setValue(DataManager.getVal(data.EventDate), forKey: "event_date")
                        parameterDictionary.setValue(DataManager.getVal(data.EventTime), forKey: "event_time")
                        parameterDictionary.setValue(DataManager.getVal(data.EventPricePerSeat), forKey: "price_per_sit")
                        parameterDictionary.setValue(DataManager.getVal(data.EventNoOftickets), forKey: "no_of_ticket")
                        parameterDictionary.setValue(DataManager.getVal(data.AboutEvent), forKey: "about_event")
                        parameterDictionary.setValue(DataManager.getVal(data.VenueID), forKey: "venue_id")
                        parameterDictionary.setValue(DataManager.getVal(data.VenueAddress), forKey: "event_type")
                        parameterDictionary.setValue(DataManager.getVal(data.Invite_Artist), forKey: "invited_artist")
                        parameterDictionary.setValue(DataManager.getVal(data.Invite_Band), forKey: "invited_bands")
                        parameterDictionary.setValue(DataManager.getVal(data.Event_Status), forKey: "event_status")
                        parameterDictionary.setValue(DataManager.getVal(data.latittude), forKey: "lat")
                        parameterDictionary.setValue(DataManager.getVal(data.longitude), forKey: "lng")
                        parameterDictionary.setValue(DataManager.getVal(data.cardNumber), forKey: "card[number]")
                        parameterDictionary.setValue(DataManager.getVal(data.cardcvv), forKey: "card[cvc]")
                        parameterDictionary.setValue(DataManager.getVal(data.cardexpmonth), forKey: "card[exp_month]")
                        parameterDictionary.setValue(DataManager.getVal(data.cardexpyear), forKey: "card[exp_year]")
                        print(parameterDictionary)
                        
                        let methodName = "create_event"
                        
                        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                        DispatchQueue.main.async(execute: {
                            let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                            let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                            
                            if status == "0"{
                                self.removeAllOverlays()
                            }
                            else{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PendingUserEventViewController") as! PendingUserEventViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                                self.removeAllOverlays()
                            }
                        })
                      }
                        
                    }else{
                        data.UserId = user_Id
                        data.EventName = str_eventName as String
                        data.EventDate = str_Datetime as String
                        data.EventTime = str_time as String
                        data.VenueID = venueId
                        data.AccountID = accountId as String
                        data.EventPricePerSeat = str_PricePerSeat as String
                        data.EventNoOftickets = str_NoOftickets as String
                        data.AboutEvent = str_AboutEvent as String
                        data.Event_Status = "Pending"
                        data.latittude = str_lat
                        data.longitude = str_long
                        data.VenueAddress = "1"
                        
                    let  typeIdArrayString1 = self.JSONStringify(value: InviteArray as AnyObject)
                    print(typeIdArrayString1)
                    data.Invite_Artist = typeIdArrayString1
                    
                    let  typeIdArrayString2 = self.JSONStringify(value: BandArray as AnyObject)
                    print(typeIdArrayString2)
                    data.Invite_Band = typeIdArrayString2
                    
//                    Parsing().DiscoverCreateEvent(data: data)
//                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateEvent"), object: nil)
//                    NotificationCenter.default.addObserver(self, selector: #selector(self.CreateEventActionPending), name: NSNotification.Name(rawValue: "DiscoverCreateEvent"), object: nil)
                    
                    let parameterDictionary = NSMutableDictionary()
                    parameterDictionary.setObject(DataManager.getVal(data.UserId), forKey: "user_id" as NSCopying )
                    parameterDictionary.setValue(DataManager.getVal(data.EventName), forKey: "event_title")
                    parameterDictionary.setValue(DataManager.getVal(data.EventDate), forKey: "event_date")
                    parameterDictionary.setValue(DataManager.getVal(data.EventTime), forKey: "event_time")
                    parameterDictionary.setValue(DataManager.getVal(data.EventPricePerSeat), forKey: "price_per_sit")
                    parameterDictionary.setValue(DataManager.getVal(data.EventNoOftickets), forKey: "no_of_ticket")
                    parameterDictionary.setValue(DataManager.getVal(data.AboutEvent), forKey: "about_event")
                    parameterDictionary.setValue(DataManager.getVal(data.VenueID), forKey: "venue_id")
                    parameterDictionary.setValue(DataManager.getVal(data.VenueAddress), forKey: "event_type")
                    parameterDictionary.setValue(DataManager.getVal(data.Invite_Artist), forKey: "invited_artist")
                    parameterDictionary.setValue(DataManager.getVal(data.Invite_Band), forKey: "invited_bands")
                    parameterDictionary.setValue(DataManager.getVal(data.Event_Status), forKey: "event_status")
                    parameterDictionary.setValue(DataManager.getVal(data.latittude), forKey: "lat")
                    parameterDictionary.setValue(DataManager.getVal(data.longitude), forKey: "lng")
                    parameterDictionary.setValue(DataManager.getVal(data.AccountID), forKey: "account_id")
                    print(parameterDictionary)
                    
                    let methodName = "create_event"
                    
                    DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                    DispatchQueue.main.async(execute: {
                        let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                        let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                        
                        if status == "0"{
                            self.removeAllOverlays()
                        }
                        else{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PendingUserEventViewController") as! PendingUserEventViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                            self.removeAllOverlays()
                        }
                    })
                  }
                }
                    
                    
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
            }
        }else {
            str_eventName = EventNameTxt.text as NSString?
            str_Datetime  = DateTimeTxt.text as NSString?
            str_time = timeTxt.text as NSString?
            str_VenueName = VenueNameTxt.text as NSString?
            str_PricePerSeat = PricePerSearTxt.text as NSString?
            str_NoOftickets = NumberOfTicketsTxt.text as NSString?
            str_AboutEvent = aboutTxtview.text as NSString?
            str_vanueAddress = venueAddressTxt.text as NSString?

            if str_eventName .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please Enter Event Name",
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
            }else if str_Datetime .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Event Date",
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
            }else if str_time .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Event Time",
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
            else if str_VenueName .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Venue Name",
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
            }else if str_vanueAddress .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Event Type",
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
            }else if str_NoOftickets .isEqual(to:  "") {
                let test =  SwiftToast(
                    text: "Please Enter Number of Tickets",
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
            else if str_AboutEvent .isEqual(to:  "About the event") {
                let test =  SwiftToast(
                    text: "Please Enter About Event",
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
            } else if InviteArray.count == 0 {
                let test =  SwiftToast(
                    text: "Please Select Invited Artist",
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
            }else {
            if Reachability.isConnectedToNetwork() == true {
                showWaitOverlay()
                let data = CreateEventModel()
                if imagedata == nil {
                    
                }
                else {
                    data.Event_Image = imagedata as NSData
                }
                data.UserId = user_Id
                data.EventName = str_eventName as String
                data.EventDate = str_Datetime as String
                data.EventTime = str_time as String
                data.EventNoOftickets = str_NoOftickets as String
                data.AccountID = accountId as String
                data.VenueID = venueId
                data.AboutEvent = str_AboutEvent as String
                data.Event_Status = "Publish"
                data.latittude = str_lat
                data.longitude = str_long
                data.VenueAddress = "0"
                let  typeIdArrayString1 = self.JSONStringify(value: InviteArray as AnyObject)
                print(typeIdArrayString1)
                data.Invite_Artist = typeIdArrayString1
                let  typeIdArrayString2 = self.JSONStringify(value: BandArray as AnyObject)
                print(typeIdArrayString2)
                data.Invite_Band = typeIdArrayString2
                let parameterDictionary = NSMutableDictionary()
                  parameterDictionary.setObject(DataManager.getVal(data.UserId), forKey: "user_id" as NSCopying )
                  parameterDictionary.setValue(DataManager.getVal(data.EventName), forKey: "event_title")
                  parameterDictionary.setValue(DataManager.getVal(data.EventDate), forKey: "event_date")
                  parameterDictionary.setValue(DataManager.getVal(data.EventTime), forKey: "event_time")
//                  parameterDictionary.setValue(DataManager.getVal(data.EventPricePerSeat), forKey: "price_per_sit")
                  parameterDictionary.setValue(DataManager.getVal(data.EventNoOftickets), forKey: "no_of_ticket")
                  parameterDictionary.setValue(DataManager.getVal(data.AboutEvent), forKey: "about_event")
                  parameterDictionary.setValue(DataManager.getVal(data.VenueID), forKey: "venue_id")
                  parameterDictionary.setValue(DataManager.getVal(data.VenueAddress), forKey: "event_type")
                  parameterDictionary.setValue(DataManager.getVal(data.Invite_Artist), forKey: "invited_artist")
                  parameterDictionary.setValue(DataManager.getVal(data.Invite_Band), forKey: "invited_bands")
                  parameterDictionary.setValue(DataManager.getVal(data.Event_Status), forKey: "event_status")
                  parameterDictionary.setValue(DataManager.getVal(data.latittude), forKey: "lat")
                  parameterDictionary.setValue(DataManager.getVal(data.longitude), forKey: "lng")
                  parameterDictionary.setValue(DataManager.getVal(data.AccountID), forKey: "account_id")
                  print(parameterDictionary)
                  
                  let methodName = "create_event"
                  
                  DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                  DispatchQueue.main.async(execute: {
                      let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                      let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                      
                      if status == "0"{
                          self.removeAllOverlays()
                      }
                      else{
                          let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                          let Flag = true
                          vc.flag = Flag
                          self.navigationController?.pushViewController(vc, animated: true)
                          self.removeAllOverlays()
                      }
                  })
                }
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
            }
        }
       
       
    }
    @IBAction func publishBtnAction(_ sender: Any) {
        if eventTy == "1" {
            str_cardNumber = cardtextfield.cardNumber! as NSString
            str_cardcvv = cardtextfield.cardParams.cvc! as NSString
            str_cardexpyear = cardtextfield.cardParams.expYear?.stringValue as? NSString
            str_cardexpmonth = cardtextfield.cardParams.expMonth?.stringValue as? NSString
            str_eventName = EventNameTxt.text as NSString?
            str_Datetime  = DateTimeTxt.text as NSString?
            str_time = timeTxt.text as NSString?
            str_VenueName = VenueNameTxt.text as NSString?
            str_PricePerSeat = PricePerSearTxt.text as NSString?
            str_NoOftickets = NumberOfTicketsTxt.text as NSString?
            str_AboutEvent = aboutTxtview.text as NSString?
            str_vanueAddress = venueAddressTxt.text as NSString?
            if str_eventName .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please Enter Event Name",
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
            }else if str_Datetime .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Event Date",
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
            }else if str_time .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Event Time",
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
            else if str_VenueName .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Venue Name",
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
            }else if str_vanueAddress .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Event Type",
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
            else if str_PricePerSeat .isEqual(to:  "") {
                let test =  SwiftToast(
                    text: "Please Enter Price Per Seat",
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
            }else if str_NoOftickets .isEqual(to:  "") {
                let test =  SwiftToast(
                    text: "Please Enter Number of Tickets",
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
            }else if str_AboutEvent .isEqual(to:  "About the event") {
                let test =  SwiftToast(
                    text: "Please Enter About Event",
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
            } else if InviteArray.count == 0 {
                let test =  SwiftToast(
                    text: "Please Select Invited Artist",
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
              }else {
            if Reachability.isConnectedToNetwork() == true {
                showWaitOverlay()
                let data = CreateEventModel()
                if imagedata == nil {
                    
                }
                else {
                    data.Event_Image = imagedata as NSData
                }
                if accountId == "" {
                    if str_cardNumber .isEqual(to: "") {
                        let test =  SwiftToast(
                            text: "Enter card Number",
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
                        
                    }else if str_cardcvv .isEqual(to: "") {
                        let test =  SwiftToast(
                            text: "Enter card CVV",
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
                       
                    }else if str_cardexpmonth .isEqual(to: "") {
                        let test =  SwiftToast(
                            text: "Enter card expire month",
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
                        
                    }else if str_cardexpyear .isEqual(to: "") {
                        let test =  SwiftToast(
                            text: "Enter card expire year",
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
                    data.UserId = user_Id
                    data.EventName = str_eventName as String
                    data.EventDate = str_Datetime as String
                    data.EventTime = str_time as String
                    data.VenueID = venueId
                    data.EventPricePerSeat = str_PricePerSeat as String
                    data.EventNoOftickets = str_NoOftickets as String
                    data.AboutEvent = str_AboutEvent as String
                    data.cardNumber = str_cardNumber as String
                    data.cardexpmonth = str_cardexpmonth as String
                    data.cardexpyear = str_cardexpyear as String
                    data.cardcvv = str_cardcvv as String
                    data.Event_Status = "Publish"
                    data.latittude = str_lat
                    data.longitude = str_long
                    data.VenueAddress = "1"
                    
                    let  typeIdArrayString1 = self.JSONStringify(value: InviteArray as AnyObject)
                    print(typeIdArrayString1)
                    data.Invite_Artist = typeIdArrayString1
                    
                    let  typeIdArrayString2 = self.JSONStringify(value: BandArray as AnyObject)
                    print(typeIdArrayString2)
                    data.Invite_Band = typeIdArrayString2
                    
                    let parameterDictionary = NSMutableDictionary()
                    parameterDictionary.setObject(DataManager.getVal(data.UserId), forKey: "user_id" as NSCopying )
                    parameterDictionary.setValue(DataManager.getVal(data.EventName), forKey: "event_title")
                    parameterDictionary.setValue(DataManager.getVal(data.EventDate), forKey: "event_date")
                    parameterDictionary.setValue(DataManager.getVal(data.EventTime), forKey: "event_time")
                    parameterDictionary.setValue(DataManager.getVal(data.EventPricePerSeat), forKey: "price_per_sit")
                    parameterDictionary.setValue(DataManager.getVal(data.EventNoOftickets), forKey: "no_of_ticket")
                    parameterDictionary.setValue(DataManager.getVal(data.AboutEvent), forKey: "about_event")
                    parameterDictionary.setValue(DataManager.getVal(data.VenueID), forKey: "venue_id")
                    parameterDictionary.setValue(DataManager.getVal(data.VenueAddress), forKey: "event_type")
                    parameterDictionary.setValue(DataManager.getVal(data.Invite_Artist), forKey: "invited_artist")
                    parameterDictionary.setValue(DataManager.getVal(data.Invite_Band), forKey: "invited_bands")
                    parameterDictionary.setValue(DataManager.getVal(data.Event_Status), forKey: "event_status")
                    parameterDictionary.setValue(DataManager.getVal(data.latittude), forKey: "lat")
                    parameterDictionary.setValue(DataManager.getVal(data.longitude), forKey: "lng")
                    parameterDictionary.setValue(DataManager.getVal(data.cardNumber), forKey: "card[number]")
                    parameterDictionary.setValue(DataManager.getVal(data.cardcvv), forKey: "card[cvc]")
                    parameterDictionary.setValue(DataManager.getVal(data.cardexpmonth), forKey: "card[exp_month]")
                    parameterDictionary.setValue(DataManager.getVal(data.cardexpyear), forKey: "card[exp_year]")
                    print(parameterDictionary)
                    
                    let methodName = "create_event"
                    
                    DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                    DispatchQueue.main.async(execute: {
                        let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                        let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                        
                        if status == "0"{
                            self.removeAllOverlays()
                            let test =  SwiftToast(
                                text: message,
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
                        else{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                            let Flag = true
                            vc.flag = Flag
                            self.navigationController?.pushViewController(vc, animated: true)
                            self.removeAllOverlays()
                        }
                    })
                  }
                    
                }else{
                    data.UserId = user_Id
                    data.EventName = str_eventName as String
                    data.EventDate = str_Datetime as String
                    data.EventTime = str_time as String
                    data.VenueID = venueId
                    data.AccountID = accountId as String
                    data.EventPricePerSeat = str_PricePerSeat as String
                    data.EventNoOftickets = str_NoOftickets as String
                    data.AboutEvent = str_AboutEvent as String
                    data.Event_Status = "Publish"
                    data.latittude = str_lat
                    data.longitude = str_long
                    data.VenueAddress = "1"
                    
                let  typeIdArrayString1 = self.JSONStringify(value: InviteArray as AnyObject)
                print(typeIdArrayString1)
                data.Invite_Artist = typeIdArrayString1
                
                let  typeIdArrayString2 = self.JSONStringify(value: BandArray as AnyObject)
                print(typeIdArrayString2)
                data.Invite_Band = typeIdArrayString2
                
//                    Parsing().DiscoverCreateEvent(data: data)
//                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateEvent"), object: nil)
//                    NotificationCenter.default.addObserver(self, selector: #selector(self.CreateEventActionPending), name: NSNotification.Name(rawValue: "DiscoverCreateEvent"), object: nil)
                
                let parameterDictionary = NSMutableDictionary()
                parameterDictionary.setObject(DataManager.getVal(data.UserId), forKey: "user_id" as NSCopying )
                parameterDictionary.setValue(DataManager.getVal(data.EventName), forKey: "event_title")
                parameterDictionary.setValue(DataManager.getVal(data.EventDate), forKey: "event_date")
                parameterDictionary.setValue(DataManager.getVal(data.EventTime), forKey: "event_time")
                parameterDictionary.setValue(DataManager.getVal(data.EventPricePerSeat), forKey: "price_per_sit")
                parameterDictionary.setValue(DataManager.getVal(data.EventNoOftickets), forKey: "no_of_ticket")
                parameterDictionary.setValue(DataManager.getVal(data.AboutEvent), forKey: "about_event")
                parameterDictionary.setValue(DataManager.getVal(data.VenueID), forKey: "venue_id")
                parameterDictionary.setValue(DataManager.getVal(data.VenueAddress), forKey: "event_type")
                parameterDictionary.setValue(DataManager.getVal(data.Invite_Artist), forKey: "invited_artist")
                parameterDictionary.setValue(DataManager.getVal(data.Invite_Band), forKey: "invited_bands")
                parameterDictionary.setValue(DataManager.getVal(data.Event_Status), forKey: "event_status")
                parameterDictionary.setValue(DataManager.getVal(data.latittude), forKey: "lat")
                parameterDictionary.setValue(DataManager.getVal(data.longitude), forKey: "lng")
                parameterDictionary.setValue(DataManager.getVal(data.AccountID), forKey: "account_id")
                print(parameterDictionary)
                
                let methodName = "create_event"
                
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                DispatchQueue.main.async(execute: {
                    let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                    let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                    
                    if status == "0"{
                        self.removeAllOverlays()
                    }
                    else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        let Flag = true
                        vc.flag = Flag
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.removeAllOverlays()
                    }
                })
              }
            }
                
                
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
            }
        }else {
            str_eventName = EventNameTxt.text as NSString?
            str_Datetime  = DateTimeTxt.text as NSString?
            str_time = timeTxt.text as NSString?
            str_VenueName = VenueNameTxt.text as NSString?
            str_PricePerSeat = PricePerSearTxt.text as NSString?
            str_NoOftickets = NumberOfTicketsTxt.text as NSString?
            str_AboutEvent = aboutTxtview.text as NSString?
            str_vanueAddress = venueAddressTxt.text as NSString?
            if str_eventName .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please Enter Event Name",
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
            }else if str_Datetime .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Event Date",
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
            }else if str_time .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Event Time",
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
            }else if str_NoOftickets .isEqual(to:  "") {
                let test =  SwiftToast(
                    text: "Please Enter Number of Tickets",
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
            else if str_VenueName .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Venue Name",
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
            }else if str_vanueAddress .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Event Type",
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
           else if str_AboutEvent .isEqual(to:  "About the event") {
                let test =  SwiftToast(
                    text: "Please Enter About Event",
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
            } else if InviteArray.count == 0 {
                let test =  SwiftToast(
                    text: "Please Select Invited Artist",
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
            }else {
                showWaitOverlay()
                let data = CreateEventModel()
                if imagedata == nil {
                    
                }
                else {
                    data.Event_Image = imagedata as NSData
                }
                
                
                
                data.UserId = user_Id
                data.EventName = str_eventName as String
                data.EventDate = str_Datetime as String
                data.EventTime = str_time as String
                data.EventNoOftickets = str_NoOftickets as String
                data.AccountID = accountId as String
                data.VenueID = venueId
                data.AboutEvent = str_AboutEvent as String
                data.Event_Status = "Publish"
                data.latittude = str_lat
                data.longitude = str_long
                data.VenueAddress = "0"
                // data.GateringNumber = str_Gethering as String
                let  typeIdArrayString1 = self.JSONStringify(value: InviteArray as AnyObject)
                print(typeIdArrayString1)
                data.Invite_Artist = typeIdArrayString1
                
                let  typeIdArrayString2 = self.JSONStringify(value: BandArray as AnyObject)
                print(typeIdArrayString2)
                data.Invite_Band = typeIdArrayString2
                
//                Parsing().DiscoverCreateEvent(data: data)
//                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateEvent"), object: nil)
//                NotificationCenter.default.addObserver(self, selector: #selector(self.CreateEventActionPublish), name: NSNotification.Name(rawValue: "DiscoverCreateEvent"), object: nil)
                let parameterDictionary = NSMutableDictionary()
                  parameterDictionary.setObject(DataManager.getVal(data.UserId), forKey: "user_id" as NSCopying )
                  parameterDictionary.setValue(DataManager.getVal(data.EventName), forKey: "event_title")
                  parameterDictionary.setValue(DataManager.getVal(data.EventDate), forKey: "event_date")
                  parameterDictionary.setValue(DataManager.getVal(data.EventTime), forKey: "event_time")
//                  parameterDictionary.setValue(DataManager.getVal(data.EventPricePerSeat), forKey: "price_per_sit")
                  parameterDictionary.setValue(DataManager.getVal(data.EventNoOftickets), forKey: "no_of_ticket")
                  parameterDictionary.setValue(DataManager.getVal(data.AboutEvent), forKey: "about_event")
                  parameterDictionary.setValue(DataManager.getVal(data.VenueID), forKey: "venue_id")
                  parameterDictionary.setValue(DataManager.getVal(data.VenueAddress), forKey: "event_type")
                  parameterDictionary.setValue(DataManager.getVal(data.Invite_Artist), forKey: "invited_artist")
                  parameterDictionary.setValue(DataManager.getVal(data.Invite_Band), forKey: "invited_bands")
                  parameterDictionary.setValue(DataManager.getVal(data.Event_Status), forKey: "event_status")
                  parameterDictionary.setValue(DataManager.getVal(data.latittude), forKey: "lat")
                  parameterDictionary.setValue(DataManager.getVal(data.longitude), forKey: "lng")
                  parameterDictionary.setValue(DataManager.getVal(data.AccountID), forKey: "account_id")
                  print(parameterDictionary)
                  
                  let methodName = "create_event"
                  
                  DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                  DispatchQueue.main.async(execute: {
                      let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                      let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                      
                      if status == "0"{
                          self.removeAllOverlays()
                      }
                      else{
                          let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                          let Flag = true
                          vc.flag = Flag
                          self.navigationController?.pushViewController(vc, animated: true)
                          self.removeAllOverlays()
                      }
                  })
                }
            }
        }
      
        
    }
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                print("error")
            }
        }
        return ""
    }
    

}
