//
//  VenueSortView.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class VenueSortView: UIView {

    
    let bubbleLayer = CAShapeLayer()
    var borderWidth : CGFloat = 2
    var radius : CGFloat = 7
    var triangleHeight : CGFloat = 14
    
    var buttonViewHighhandler : (()-> Void)?
    var buttonViewLowhandler : (()-> Void)?
    var buttonRatingHighhandler : (()-> Void)?
    var buttonRatingLowhandler : (()-> Void)?
    
    @IBOutlet weak var viewHighBtn: UIButton!
    @IBOutlet weak var viewLowbtn: UIButton!
    @IBOutlet weak var ratingHighBtn: UIButton!
    @IBOutlet weak var ratingLowBtn: UIButton!
    
    var viewhigh:Int!
    var viewlow:Int!
    var ratinghigh:Int!
    var ratinglow:Int!
    
    let IS_IPHONEX = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
    let IS_IPHONE_XS = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
    let IS_IPHONE_X_MAX = (UIScreen.main.bounds.size.height - 568) != 0.0 ? false : true
    let IS_IPHONE_XR = (UIScreen.main.bounds.size.height - 896) != 0.0 ? false : true
    
    var orderType:String!
    var Sortorder:String!
    var sortType:String!
    var defaults:UserDefaults!
    
    class func intitiateFromNib() -> VenueSortView {
        let View1 = UINib.init(nibName: "VenueSortView", bundle: nil).instantiate(withOwner: self, options: nil).first as! VenueSortView
        
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaults = UserDefaults.standard
        viewhigh = defaults.integer(forKey: "BUTTONIMGVE1")
        viewlow = defaults.integer(forKey: "BUTTONIMGVE2")
        ratinghigh = defaults.integer(forKey: "BUTTONIMGVE3")
        ratinglow = defaults.integer(forKey: "BUTTONIMGVE4")
        
        if viewhigh == 1 && viewlow == 0 && ratinghigh == 0 && ratinglow == 0{
            viewHighBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            viewLowbtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            ratingHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            ratingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            
        }else if viewhigh == 0 && viewlow == 2 && ratinghigh == 0 && ratinglow == 0 {
            viewHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            viewLowbtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            ratingHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            ratingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            
        }else if viewhigh == 0 && viewlow == 0 && ratinghigh == 3 && ratinglow == 0{
            viewHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            viewLowbtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            ratingHighBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
            ratingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            
        }else if viewhigh == 0 && viewlow == 0 && ratinghigh == 0 && ratinglow == 4 {
            viewHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            viewLowbtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            ratingHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            ratingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            
        }else {
            viewHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            viewLowbtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            ratingHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            ratingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
            
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
        sortType = "Rating"
        orderType = "rating"
        Sortorder = "DESC"
        viewhigh = 1
        viewlow =  0
        ratinghigh = 0
        ratinglow = 0
        viewHighBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        viewLowbtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW3")
        defaults.set(ratinglow, forKey: "BUTTONIMGVE4")
        defaults.set(viewhigh, forKey: "BUTTONIMGVE1")
        defaults.set(viewlow, forKey: "BUTTONIMGVE2")
        defaults.set(ratinghigh, forKey: "BUTTONIMGVE3")
        defaults.synchronize()
        buttonViewHighhandler?()
    }
    
    @IBAction func viewLowBtnAction(_ sender: Any) {
        sortType = "Rating"
        orderType = "rating"
        Sortorder = "ASC"
        viewhigh = 0
        viewlow =  2
        ratinghigh = 0
        ratinglow = 0
        viewHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        viewLowbtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW3")
        defaults.set(ratinglow, forKey: "BUTTONIMGVE4")
        defaults.set(viewhigh, forKey: "BUTTONIMGVE1")
        defaults.set(viewlow, forKey: "BUTTONIMGVE2")
        defaults.set(ratinghigh, forKey: "BUTTONIMGVE3")
        defaults.synchronize()
         buttonViewLowhandler?()
    }
    @IBAction func ratingHighBtnAction(_ sender: Any) {
        sortType = "Distance"
        orderType = "distance"
        Sortorder = "DESC"
        viewhigh = 0
        viewlow =  0
        ratinghigh = 3
        ratinglow = 0
        ratingHighBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        ratingLowBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW3")
        defaults.set(ratinglow, forKey: "BUTTONIMGVE4")
        defaults.set(viewhigh, forKey: "BUTTONIMGVE1")
        defaults.set(viewlow, forKey: "BUTTONIMGVE2")
        defaults.set(ratinghigh, forKey: "BUTTONIMGVE3")
        defaults.synchronize()
         buttonRatingHighhandler?()
    }
    @IBAction func RatingLowBtnAction(_ sender: Any) {
        sortType = "Distance"
        orderType = "distance"
        Sortorder = "ASC"
        viewhigh = 0
        viewlow =  0
        ratinghigh = 0
        ratinglow = 4
        ratingHighBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        ratingLowBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        let defaults = UserDefaults.standard
        defaults.set(orderType, forKey: "ORDERTYPE")
        defaults.set(Sortorder, forKey: "SORTORDER")
        defaults.set(sortType, forKey: "TYPEVIEW3")
        defaults.set(ratinglow, forKey: "BUTTONIMGVE4")
        defaults.set(viewhigh, forKey: "BUTTONIMGVE1")
        defaults.set(viewlow, forKey: "BUTTONIMGVE2")
        defaults.set(ratinghigh, forKey: "BUTTONIMGVE3")
        defaults.synchronize()
        buttonRatingLowhandler?()
    }
    
}
