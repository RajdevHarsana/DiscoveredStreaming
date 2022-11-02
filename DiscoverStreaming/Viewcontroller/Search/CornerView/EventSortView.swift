//
//  EventSortView.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class EventSortView: UIView {

    let bubbleLayer = CAShapeLayer()
    var borderWidth : CGFloat = 2
    var radius : CGFloat = 7
    var triangleHeight : CGFloat = 14
    
    var buttonPriceHighhandler : (()-> Void)?
    var buttonPriceLowhandler : (()-> Void)?
    var buttonDateHighhandler : (()-> Void)?
    var buttonDateLowhandler : (()-> Void)?
    var buttonDistanceHighhandler : (()-> Void)?
    var buttonDistanceLowhandler : (()-> Void)?
    
    @IBOutlet weak var priceHighBtn: UIButton!
    @IBOutlet weak var priceLowbtn: UIButton!
    @IBOutlet weak var datehighBtn: UIButton!
    @IBOutlet weak var dateLowBtn: UIButton!
    @IBOutlet weak var disHighBtn: UIButton!
    @IBOutlet weak var disLowBtn: UIButton!
    
    var pricehigh:Int!
    var pricelow:Int!
    var datehigh:Int!
    var datelow:Int!
    var distancehigh:Int!
    var distancelow:Int!
    let IS_IPHONEX = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
    let IS_IPHONE_XS = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
    let IS_IPHONE_X_MAX = (UIScreen.main.bounds.size.height - 568) != 0.0 ? false : true
    let IS_IPHONE_XR = (UIScreen.main.bounds.size.height - 896) != 0.0 ? false : true
    var orderType:String!
    var Sortorder:String!
    var sortType:String!
    var defaults:UserDefaults!
    class func intitiateFromNib() -> EventSortView {
        let View1 = UINib.init(nibName: "EventSortView", bundle: nil).instantiate(withOwner: self, options: nil).first as! EventSortView
        
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaults = UserDefaults.standard
        pricehigh = defaults.integer(forKey: "BUTTONIMGEV1")
        pricelow = defaults.integer(forKey: "BUTTONIMGEV2")
        datehigh = defaults.integer(forKey: "BUTTONIMGEV3")
        datelow = defaults.integer(forKey: "BUTTONIMGEV4")
        distancehigh = defaults.integer(forKey: "BUTTONIMGEV5")
        distancelow = defaults.integer(forKey: "BUTTONIMGEV6")
        
        if pricehigh == 1 && pricelow == 0 && datehigh == 0 && datelow == 0 && distancehigh == 0 && distancelow == 0 {
            priceHighBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            priceLowbtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            datehighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            dateLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            disHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            disLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }else if pricehigh == 0 && pricelow == 2 && datehigh == 0 && datelow == 0 && distancehigh == 0 && distancelow == 0 {
            priceHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            priceLowbtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            datehighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            dateLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            disHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            disLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }else if pricehigh == 0 && pricelow == 0 && datehigh == 3 && datelow == 0 && distancehigh == 0 && distancelow == 0 {
            priceHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            priceLowbtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            datehighBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            dateLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            disHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            disLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }else if pricehigh == 0 && pricelow == 0 && datehigh == 0 && datelow == 4 && distancehigh == 0 && distancelow == 0 {
            priceHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            priceLowbtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            datehighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            dateLowBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            disHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            disLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }else if pricehigh == 0 && pricelow == 0 && datehigh == 0 && datelow == 0 && distancehigh == 5 && distancelow == 0 {
            priceHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            priceLowbtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            datehighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            dateLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            disHighBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            disLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }else if pricehigh == 0 && pricelow == 0 && datehigh == 0 && datelow == 0 && distancehigh == 0 && distancelow == 6 {
            priceHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            priceLowbtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            datehighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            dateLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            disHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            disLowBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        }else {
            priceHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            priceLowbtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            datehighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            dateLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            disHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            disLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }
        
        
        if pricehigh == 1 {
            
        }else  {
            
        }
        if pricelow == 2 {
            
        }else {
            
        }
        if datehigh == 3 {
            
        }else {
            
        }
        if datelow == 4 {
            
        }else {
            
        }
        if distancehigh == 5 {
            
        }else {
            
        }
        if distancelow == 6 {
            
        }else {
            
        }
        
    }
    
    func bubblePathForContentSize(contentSize: CGSize) -> UIBezierPath {
        if IS_IPHONEX {
            let rect = CGRect(origin: .zero, size: CGSize(width: contentSize.width-40, height: contentSize.height-30)).offsetBy(dx: radius, dy: radius + triangleHeight)
            let path = UIBezierPath();
            let radius2 = radius - borderWidth / 2 // Radius adjasted for the border width
            
            path.move(to: CGPoint(x: rect.maxX - triangleHeight * 2, y: rect.minY - radius2))
            path.addLine(to: CGPoint(x: rect.maxX - triangleHeight, y: rect.minY - radius2 - triangleHeight))
            path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.minY),
                        radius: radius2,
                        startAngle: CGFloat(-(Double.pi/2)), endAngle: 0, clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.maxY),
                        radius: radius2,
                        startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.maxY),
                        radius: radius2,
                        startAngle: CGFloat(Double.pi/2),endAngle: CGFloat(Double.pi), clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.minY),
                        radius: radius2,
                        startAngle: CGFloat(Double.pi), endAngle: CGFloat(-(Double.pi/2)), clockwise: true)
            
            path.close()
            return path
        }else if IS_IPHONE_XS {
            let rect = CGRect(origin: .zero, size: CGSize(width: contentSize.width-40, height: contentSize.height-30)).offsetBy(dx: radius, dy: radius + triangleHeight)
            let path = UIBezierPath();
            let radius2 = radius - borderWidth / 2 // Radius adjasted for the border width
            
            path.move(to: CGPoint(x: rect.maxX - triangleHeight * 2, y: rect.minY - radius2))
            path.addLine(to: CGPoint(x: rect.maxX - triangleHeight, y: rect.minY - radius2 - triangleHeight))
            path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.minY),
                        radius: radius2,
                        startAngle: CGFloat(-(Double.pi/2)), endAngle: 0, clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.maxY),
                        radius: radius2,
                        startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.maxY),
                        radius: radius2,
                        startAngle: CGFloat(Double.pi/2),endAngle: CGFloat(Double.pi), clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.minY),
                        radius: radius2,
                        startAngle: CGFloat(Double.pi), endAngle: CGFloat(-(Double.pi/2)), clockwise: true)
            
            path.close()
            return path
        }else if IS_IPHONE_X_MAX {
            let rect = CGRect(origin: .zero, size: CGSize(width: contentSize.width-90, height: contentSize.height-30)).offsetBy(dx: radius, dy: radius + triangleHeight)
            let path = UIBezierPath();
            let radius2 = radius - borderWidth / 2 // Radius adjasted for the border width
            
            path.move(to: CGPoint(x: rect.maxX - triangleHeight * 2, y: rect.minY - radius2))
            path.addLine(to: CGPoint(x: rect.maxX - triangleHeight, y: rect.minY - radius2 - triangleHeight))
            path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.minY),
                        radius: radius2,
                        startAngle: CGFloat(-(Double.pi/2)), endAngle: 0, clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.maxY),
                        radius: radius2,
                        startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.maxY),
                        radius: radius2,
                        startAngle: CGFloat(Double.pi/2),endAngle: CGFloat(Double.pi), clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.minY),
                        radius: radius2,
                        startAngle: CGFloat(Double.pi), endAngle: CGFloat(-(Double.pi/2)), clockwise: true)
            
            path.close()
            return path
        } else if IS_IPHONE_XR {
            let rect = CGRect(origin: .zero, size: CGSize(width: contentSize.width
                , height: contentSize.height-30)).offsetBy(dx: radius, dy: radius + triangleHeight)
            let path = UIBezierPath();
            let radius2 = radius - borderWidth / 2 // Radius adjasted for the border width
            
            path.move(to: CGPoint(x: rect.maxX - triangleHeight * 2, y: rect.minY - radius2))
            path.addLine(to: CGPoint(x: rect.maxX - triangleHeight, y: rect.minY - radius2 - triangleHeight))
            path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.minY),
                        radius: radius2,
                        startAngle: CGFloat(-(Double.pi/2)), endAngle: 0, clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.maxY),
                        radius: radius2,
                        startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.maxY),
                        radius: radius2,
                        startAngle: CGFloat(Double.pi/2),endAngle: CGFloat(Double.pi), clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.minY),
                        radius: radius2,
                        startAngle: CGFloat(Double.pi), endAngle: CGFloat(-(Double.pi/2)), clockwise: true)
            
            path.close()
            return path
        }
        else {
            let rect = CGRect(origin: .zero, size: CGSize(width: contentSize.width-40, height: contentSize.height-30)).offsetBy(dx: radius, dy: radius + triangleHeight)
            let path = UIBezierPath();
            let radius2 = radius - borderWidth / 2 // Radius adjasted for the border width
            
            path.move(to: CGPoint(x: rect.maxX - triangleHeight * 2, y: rect.minY - radius2))
            path.addLine(to: CGPoint(x: rect.maxX - triangleHeight, y: rect.minY - radius2 - triangleHeight))
            path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.minY),
                        radius: radius2,
                        startAngle: CGFloat(-(Double.pi/2)), endAngle: 0, clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.maxY),
                        radius: radius2,
                        startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.maxY),
                        radius: radius2,
                        startAngle: CGFloat(Double.pi/2),endAngle: CGFloat(Double.pi), clockwise: true)
            path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.minY),
                        radius: radius2,
                        startAngle: CGFloat(Double.pi), endAngle: CGFloat(-(Double.pi/2)), clockwise: true)
            
            path.close()
            return path
        }
        
    }
    @IBAction func priceHighBtnAction(_ sender: Any) {
        pricehigh = 1
        pricelow =  0
        datehigh = 0
        datelow = 0
        distancehigh = 0
        distancelow = 0
        sortType = "Price"
        orderType = "price_per_sit"
        Sortorder = "DESC"
        priceHighBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        priceLowbtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW2")
        defaults.set(pricehigh, forKey: "BUTTONIMGEV1")
        defaults.set(pricelow, forKey: "BUTTONIMGEV2")
        defaults.set(datehigh, forKey: "BUTTONIMGEV3")
        defaults.set(datelow, forKey: "BUTTONIMGEV4")
        defaults.set(distancehigh, forKey: "BUTTONIMGEV5")
        defaults.set(distancelow, forKey: "BUTTONIMGEV6")
        defaults.synchronize()
        buttonPriceHighhandler?()
    }
    @IBAction func priceLowBtnAction(_ sender: Any) {
        pricehigh = 0
        pricelow =  2
        datehigh = 0
        datelow = 0
        distancehigh = 0
        distancelow = 0
        sortType = "Price"
        orderType = "price_per_sit"
        Sortorder = "ASC"
        priceHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        priceLowbtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW2")
        defaults.set(pricehigh, forKey: "BUTTONIMGEV1")
        defaults.set(pricelow, forKey: "BUTTONIMGEV2")
        defaults.set(datehigh, forKey: "BUTTONIMGEV3")
        defaults.set(datelow, forKey: "BUTTONIMGEV4")
        defaults.set(distancehigh, forKey: "BUTTONIMGEV5")
        defaults.set(distancelow, forKey: "BUTTONIMGEV6")
        defaults.synchronize()
        buttonPriceLowhandler?()
    }
    
    @IBAction func dateHighBtnAction(_ sender: Any) {
        pricehigh = 0
        pricelow =  0
        datehigh = 3
        datelow = 0
        distancehigh = 0
        distancelow = 0
        sortType = "Date"
        orderType = "event_date"
        Sortorder = "DESC"
        datehighBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        dateLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW2")
        defaults.set(pricehigh, forKey: "BUTTONIMGEV1")
        defaults.set(pricelow, forKey: "BUTTONIMGEV2")
        defaults.set(datehigh, forKey: "BUTTONIMGEV3")
        defaults.set(datelow, forKey: "BUTTONIMGEV4")
        defaults.set(distancehigh, forKey: "BUTTONIMGEV5")
        defaults.set(distancelow, forKey: "BUTTONIMGEV6")
        defaults.synchronize()
        buttonDateHighhandler?()
    }
    
    @IBAction func dateLowbtnAction(_ sender: Any) {
        pricehigh = 0
        pricelow =  0
        datehigh = 0
        datelow = 4
        distancehigh = 0
        distancelow = 0
        sortType = "Date"
        orderType = "event_date"
        Sortorder = "ASC"
        datehighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        dateLowBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW2")
        defaults.set(pricehigh, forKey: "BUTTONIMGEV1")
        defaults.set(pricelow, forKey: "BUTTONIMGEV2")
        defaults.set(datehigh, forKey: "BUTTONIMGEV3")
        defaults.set(datelow, forKey: "BUTTONIMGEV4")
        defaults.set(distancehigh, forKey: "BUTTONIMGEV5")
        defaults.set(distancelow, forKey: "BUTTONIMGEV6")
        defaults.synchronize()
        buttonDateLowhandler?()
    }
    
    @IBAction func disHightBtnAction(_ sender: Any) {
        pricehigh = 0
        pricelow =  0
        datehigh = 0
        datelow = 0
        distancehigh = 5
        distancelow = 0
        sortType = "Distance"
        orderType = "distance"
        Sortorder = "DESC"
        disHighBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        disLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW2")
        defaults.set(pricehigh, forKey: "BUTTONIMGEV1")
        defaults.set(pricelow, forKey: "BUTTONIMGEV2")
        defaults.set(datehigh, forKey: "BUTTONIMGEV3")
        defaults.set(datelow, forKey: "BUTTONIMGEV4")
        defaults.set(distancehigh, forKey: "BUTTONIMGEV5")
        defaults.set(distancelow, forKey: "BUTTONIMGEV6")
        defaults.synchronize()
        buttonDistanceHighhandler?()
    }
    @IBAction func disLowBtnaction(_ sender: Any) {
        pricehigh = 0
        pricelow =  0
        datehigh = 0
        datelow = 0
        distancehigh = 0
        distancelow = 6
        sortType = "Distance"
        orderType = "distance"
        Sortorder = "ASC"
        disHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        disLowBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW2")
        defaults.set(pricehigh, forKey: "BUTTONIMGEV1")
        defaults.set(pricelow, forKey: "BUTTONIMGEV2")
        defaults.set(datehigh, forKey: "BUTTONIMGEV3")
        defaults.set(datelow, forKey: "BUTTONIMGEV4")
        defaults.set(distancehigh, forKey: "BUTTONIMGEV5")
        defaults.set(distancelow, forKey: "BUTTONIMGEV6")
        defaults.synchronize()
        buttonDistanceLowhandler?()
    }
    
}
