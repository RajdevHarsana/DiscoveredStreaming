//
//  SongCornerView.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 26/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class SongCornerView: UIView {

    
    let bubbleLayer = CAShapeLayer()
    var borderWidth : CGFloat = 2
    var radius : CGFloat = 7
    var triangleHeight : CGFloat = 14
  
    @IBOutlet weak var viewHightBtn: UIButton!
    @IBOutlet weak var viewLowBtn: UIButton!
    @IBOutlet weak var RatingHighBtn: UIButton!
    @IBOutlet weak var RatingLowBtn: UIButton!
    @IBOutlet weak var orderNewwstBtn: UIButton!
    @IBOutlet weak var orderOldestBtn: UIButton!
     var buttonViewHighHandler : (()-> Void)?
     var buttonViewLowHandler : (()-> Void)?
     var buttonRatingHighHandler : (()-> Void)?
     var buttonRatingLowHandler : (()-> Void)?
     var buttonOrderNewesthandler : (()-> Void)?
     var buttonOrderOldesthandler : (()-> Void)?
    let IS_IPHONEX = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
    let IS_IPHONE_XS = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
    let IS_IPHONE_X_MAX = (UIScreen.main.bounds.size.height - 568) != 0.0 ? false : true
    let IS_IPHONE_XR = (UIScreen.main.bounds.size.height - 896) != 0.0 ? false : true
    var buttonImg:Int!
    var buttonImg1:Int!
    var viewhigh:Int!
    var viewlow:Int!
    var ratinghigh:Int!
    var ratinglow:Int!
    var ordernew:Int!
    var orderold:Int!
    var sortType:String!
    class func intitiateFromNib() -> SongCornerView {
        let View1 = UINib.init(nibName: "SongCornerView", bundle: nil).instantiate(withOwner: self, options: nil).first as! SongCornerView
        
        return View1
    }
    
    var orderType:String!
    var Sortorder:String!
    var defaults:UserDefaults!
    override func awakeFromNib() {
        super.awakeFromNib()
        defaults = UserDefaults.standard
        
        viewhigh = defaults.integer(forKey: "BUTTONIMG1")
        viewlow = defaults.integer(forKey: "BUTTONIMG2")
        ratinghigh = defaults.integer(forKey: "BUTTONIMG3")
        ratinglow = defaults.integer(forKey: "BUTTONIMG4")
        ordernew = defaults.integer(forKey: "BUTTONIMG5")
        orderold = defaults.integer(forKey: "BUTTONIMG6")
        
        if viewhigh == 1 && viewlow == 0 && ratinghigh == 0 && ratinglow == 0 && ordernew == 0 && orderold == 0 {
            viewHightBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            viewLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            RatingHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            RatingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            orderNewwstBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            orderOldestBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }else if viewhigh == 0 && viewlow == 2 && ratinghigh == 0 && ratinglow == 0 && ordernew == 0 && orderold == 0 {
            viewHightBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            viewLowBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            RatingHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            RatingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            orderNewwstBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            orderOldestBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }else if viewhigh == 0 && viewlow == 0 && ratinghigh == 3 && ratinglow == 0 && ordernew == 0 && orderold == 0 {
            viewHightBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            viewLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            RatingHighBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            RatingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            orderNewwstBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            orderOldestBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }else if viewhigh == 0 && viewlow == 0 && ratinghigh == 0 && ratinglow == 4 && ordernew == 0 && orderold == 0 {
            viewHightBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            viewLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            RatingHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            RatingLowBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            orderNewwstBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            orderOldestBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }else if viewhigh == 0 && viewlow == 0 && ratinghigh == 0 && ratinglow == 0 && ordernew == 5 && orderold == 0 {
            viewHightBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            viewLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            RatingHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            RatingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            orderNewwstBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            orderOldestBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }else if viewhigh == 0 && viewlow == 0 && ratinghigh == 0 && ratinglow == 0 && ordernew == 0 && orderold == 6 {
            viewHightBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            viewLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            RatingHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            RatingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            orderNewwstBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            orderOldestBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        }else {
            viewHightBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            viewLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            RatingHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            RatingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            orderNewwstBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            orderOldestBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }
        
        
        if viewhigh == 1 {
            
        }else  {
            
        }
        if viewlow == 2 {
            
        }else {
            
        }
        if ratinghigh == 3 {
            
        }else {
            
        }
        if ratinglow == 4 {
            
        }else {
            
        }
        if ordernew == 5 {
            
        }else {
            
        }
        if orderold == 6 {
            
        }else {
            
        }
        
       // bubbleLayer.path = bubblePathForContentSize(contentSize: self.bounds.size).cgPath
     //   bubbleLayer.fillColor = UIColor.clear.cgColor
        //bubbleLayer.strokeColor = UIColor.lightGray.cgColor
       // bubbleLayer.lineWidth = borderWidth
       // bubbleLayer.position = CGPoint.init(x: 0, y: -13)
       // self.layer.addSublayer(bubbleLayer)
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
    @IBAction func viewHighBtnAction(_ sender: Any) {
        sortType = "View"
        viewhigh = 1
        viewlow =  0
        ratinghigh = 0
        ratinglow = 0
        ordernew = 0
        orderold = 0
        orderType = "viewer"
        Sortorder = "DESC"
        viewHightBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        viewLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW")
        defaults.set(viewhigh, forKey: "BUTTONIMG1")
        defaults.set(viewlow, forKey: "BUTTONIMG2")
        defaults.set(ratinghigh, forKey: "BUTTONIMG3")
        defaults.set(ratinglow, forKey: "BUTTONIMG4")
        defaults.set(ordernew, forKey: "BUTTONIMG5")
        defaults.set(orderold, forKey: "BUTTONIMG6")
        defaults.synchronize()
        buttonViewHighHandler?()
    }
    @IBAction func viewLowBtnAction(_ sender: Any) {
        sortType = "View"
        viewlow = 2
        viewhigh =  0
        ratinghigh = 0
        ratinglow = 0
        ordernew = 0
        orderold = 0
        orderType = "viewer"
        Sortorder = "ASC"
        viewHightBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        viewLowBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW")
        defaults.set(viewlow, forKey: "BUTTONIMG2")
        defaults.set(viewhigh, forKey: "BUTTONIMG1")
        defaults.set(ratinghigh, forKey: "BUTTONIMG3")
        defaults.set(ratinglow, forKey: "BUTTONIMG4")
        defaults.set(ordernew, forKey: "BUTTONIMG5")
        defaults.set(orderold, forKey: "BUTTONIMG6")
        defaults.synchronize()
        buttonViewLowHandler?()
    }
    
    @IBAction func RatingHighBtnAction(_ sender: Any) {
        sortType = "Rating"
        ratinghigh = 3
        viewlow =  0
        viewhigh = 0
        ratinglow = 0
        ordernew = 0
        orderold = 0
        orderType = "rating_percentage"
        Sortorder = "DESC"
        RatingHighBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        RatingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW")
        defaults.set(ratinghigh, forKey: "BUTTONIMG3")
        defaults.set(viewhigh, forKey: "BUTTONIMG1")
        defaults.set(viewlow, forKey: "BUTTONIMG2")
        defaults.set(ratinglow, forKey: "BUTTONIMG4")
        defaults.set(ordernew, forKey: "BUTTONIMG5")
        defaults.set(orderold, forKey: "BUTTONIMG6")
        defaults.synchronize()
        buttonRatingHighHandler?()
    }
    
    @IBAction func RatingLowBtnAction(_ sender: Any) {
        sortType = "Rating"
        ratinglow = 4
        viewlow =  0
        viewhigh = 0
        ratinghigh = 0
        ordernew = 0
        orderold = 0
        orderType = "rating_percentage"
        Sortorder = "ASC"
        RatingHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        RatingLowBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW")
        defaults.set(ratinglow, forKey: "BUTTONIMG4")
        defaults.set(viewhigh, forKey: "BUTTONIMG1")
        defaults.set(viewlow, forKey: "BUTTONIMG2")
        defaults.set(ratinghigh, forKey: "BUTTONIMG3")
        defaults.set(ordernew, forKey: "BUTTONIMG5")
        defaults.set(orderold, forKey: "BUTTONIMG6")
        defaults.synchronize()
        buttonRatingLowHandler?()
    }
    
    @IBAction func OrderNewestBtnAction(_ sender: Any) {
        sortType = "Order"
        ordernew = 5
        viewlow =  0
        viewhigh = 0
        ratinghigh = 0
        ratinglow = 0
        orderold = 0
        orderType = "created_date"
        Sortorder = "DESC"
        orderNewwstBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        orderOldestBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW")
        defaults.set(ordernew, forKey: "BUTTONIMG5")
        defaults.set(viewhigh, forKey: "BUTTONIMG1")
        defaults.set(viewlow, forKey: "BUTTONIMG2")
        defaults.set(ratinghigh, forKey: "BUTTONIMG3")
        defaults.set(ratinglow, forKey: "BUTTONIMG4")
        defaults.set(orderold, forKey: "BUTTONIMG6")
        defaults.synchronize()
        buttonOrderNewesthandler?()
    }
    @IBAction func OrderOldestBtnAction(_ sender: Any) {
        sortType = "Order"
        orderold = 6
        viewlow =  0
        viewhigh = 0
        ratinglow = 0
        ratinghigh = 0
        ordernew = 0
        orderType = "created_date"
        Sortorder = "ASC"
        orderNewwstBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        orderOldestBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW")
        defaults.set(orderold, forKey: "BUTTONIMG6")
        defaults.set(viewhigh, forKey: "BUTTONIMG1")
        defaults.set(viewlow, forKey: "BUTTONIMG2")
        defaults.set(ratinghigh, forKey: "BUTTONIMG3")
        defaults.set(ratinglow, forKey: "BUTTONIMG4")
        defaults.set(ordernew, forKey: "BUTTONIMG5")
        defaults.synchronize()
         buttonOrderOldesthandler?()
    }
    
   
}
