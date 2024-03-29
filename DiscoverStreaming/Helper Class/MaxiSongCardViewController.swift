/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import SwiftToast
protocol MaxiPlayerSourceProtocol: class {
  var originatingFrameInWindow: CGRect { get }
  var originatingCoverImageView: UIImageView { get }
}

class MaxiSongCardViewController: UIViewController, SongSubscriber {

  // MARK: - Properties
  let primaryDuration = 0.5
  let backingImageEdgeInset: CGFloat = 15.0
  let cardCornerRadius: CGFloat = 10
  var currentSong: Song?
  weak var sourceView: MaxiPlayerSourceProtocol!
  
  //scroller
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stretchySkirt: UIView!
  //cover image
  @IBOutlet weak var coverImageContainer: UIView!
  @IBOutlet weak var coverArtImage: UIImageView!
  @IBOutlet weak var dismissChevron: UIButton!
  //
  //cover image constraints
  @IBOutlet weak var coverImageLeading: NSLayoutConstraint!
  @IBOutlet weak var coverImageTop: NSLayoutConstraint!
  @IBOutlet weak var coverImageBottom: NSLayoutConstraint!
  @IBOutlet weak var coverImageHeight: NSLayoutConstraint!
  //cover image constraints
  @IBOutlet weak var coverImageContainerTopInset: NSLayoutConstraint!
  
  //backing image
  var backingImage: UIImage?
  @IBOutlet weak var backingImageView: UIImageView!
  @IBOutlet weak var dimmerLayer: UIView!
  //add backing image constraints here
  @IBOutlet weak var backingImageTopInset: NSLayoutConstraint!
  @IBOutlet weak var backingImageLeadingInset: NSLayoutConstraint!
  @IBOutlet weak var backingImageTrailingInset: NSLayoutConstraint!
  @IBOutlet weak var backingImageBottomInset: NSLayoutConstraint!
  
  //lower module constraints
  @IBOutlet weak var lowerModuleTopConstraint: NSLayoutConstraint!
  
  //fake tabbar contraints
  var tabBarImage: UIImage?
  @IBOutlet weak var bottomSectionHeight: NSLayoutConstraint!
  @IBOutlet weak var bottomSectionLowerConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomSectionImageView: UIImageView!
    var userId:Int!
    var songId:Int!
    var defaults:UserDefaults!
    var Image:String!
    var SongId:Int!
    var Name:String!
    var AsName:String!
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()

    modalPresentationCapturesStatusBarAppearance = true //allow this VC to control the status bar appearance
    modalPresentationStyle = .overFullScreen //dont dismiss the presenting view controller when presented
  }
    
    
    @objc func DiscoverSongDetailAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(String(describing: response))")
                self.coverArtImage.sd_setImage(with: URL(string: (response.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                self.Image = response.value(forKey: "song_image") as? String
                self.Name = response.value(forKey: "song_name") as? String
                self.SongId = response.value(forKey: "id") as? Int
                self.AsName = response.value(forKey: "as_type_name") as? String
                let defaultsNew = UserDefaults.standard
                defaultsNew.set(self.Image, forKey: "SNGIMG")
                defaultsNew.set(self.Name, forKey: "SNGNAME")
                defaultsNew.set(self.SongId, forKey: "Song_Id")
                defaultsNew.set(self.AsName, forKey: "ASNAME")
                defaultsNew.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name("Songpop"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
                self.removeAllOverlays()
            }
        }
    }

  override func viewDidLoad() {
    super.viewDidLoad()
    defaults = UserDefaults.standard
    userId = defaults.integer(forKey: "UserIDGet")
    songId = defaults.integer(forKey: "Song_Id")
    backingImageView.image = backingImage
    scrollView.contentInsetAdjustmentBehavior = .never //dont let Safe Area insets affect the scroll view
    
    coverImageContainer.layer.cornerRadius = cardCornerRadius
    coverImageContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    
    
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureImageLayerInStartPosition()
    coverArtImage.image = sourceView.originatingCoverImageView.image
    configureCoverImageInStartPosition()
    stretchySkirt.backgroundColor = .black
    configureLowerModuleInStartPosition()
    configureBottomSection()
     NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("PlaySong"), object: nil)
  }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        
        if Reachability.isConnectedToNetwork() == true {
            Parsing().DiscoverSongDetail(UserId: userId, SongId: songId)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongDetailAction), name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateBackingImageIn()
    animateImageLayerIn()
    animateCoverImageIn()
    animateLowerModuleIn()
    animateBottomSectionOut()
    
    if Reachability.isConnectedToNetwork() == true {
        Parsing().DiscoverSongDetail(UserId: userId, SongId: songId)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongDetailAction), name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
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

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? SongSubscriber {
      destination.currentSong = currentSong
    }
  }
}

// MARK: - IBActions
extension MaxiSongCardViewController {

  @IBAction func dismissAction(_ sender: Any) {
    animateBackingImageOut()
    animateCoverImageOut()
    animateImageLayerOut() { _ in
      self.dismiss(animated: false)
    }
    animateLowerModuleOut()
    animateBottomSectionIn()
    let defaultsNew = UserDefaults.standard
    defaultsNew.set(Image, forKey: "SNGIMG")
    defaultsNew.set(Name, forKey: "SNGNAME")
    defaultsNew.set(SongId, forKey: "Song_Id")
    defaultsNew.set(AsName, forKey: "ASNAME")
    defaultsNew.synchronize()
    NotificationCenter.default.post(name: NSNotification.Name("Songpop"), object: nil)
  }
    
    
  
}

//fake tab bar animation
extension MaxiSongCardViewController {

  func configureBottomSection() {
    if let image = tabBarImage {
      bottomSectionHeight.constant = image.size.height
      bottomSectionImageView.image = image
    } else {
      bottomSectionHeight.constant = 0
    }
    view.layoutIfNeeded()
  }
  
  func animateBottomSectionOut() {
    if let image = tabBarImage {
      UIView.animate(withDuration: primaryDuration / 2.0) {
        self.bottomSectionLowerConstraint.constant = -image.size.height
        self.view.layoutIfNeeded()
      }
    }
  }
  
  func animateBottomSectionIn() {
    if tabBarImage != nil {
      UIView.animate(withDuration: primaryDuration / 2.0) {
        self.bottomSectionLowerConstraint.constant = 0
        self.view.layoutIfNeeded()
      }
    }
  }
}

//background image animation
extension MaxiSongCardViewController {
  
  private func configureBackingImageInPosition(presenting: Bool) {
    let edgeInset: CGFloat = presenting ? backingImageEdgeInset: 0
    let dimmerAlpha: CGFloat = presenting ? 0.3: 0
    let cornerRadius: CGFloat = presenting ? cardCornerRadius: 0
    
    backingImageLeadingInset.constant = edgeInset
    backingImageTrailingInset.constant = edgeInset
    let aspectRatio = backingImageView.frame.height / backingImageView.frame.width
    backingImageTopInset.constant = edgeInset * aspectRatio
    backingImageBottomInset.constant = edgeInset * aspectRatio

    dimmerLayer.alpha = dimmerAlpha

    backingImageView.layer.cornerRadius = cornerRadius
  }
  
  private func animateBackingImage(presenting: Bool) {
    UIView.animate(withDuration: primaryDuration) {
      self.configureBackingImageInPosition(presenting: presenting)
      self.view.layoutIfNeeded() //IMPORTANT!
    }
  }
  
  func animateBackingImageIn() {
    animateBackingImage(presenting: true)
  }
  
  func animateBackingImageOut() {
    animateBackingImage(presenting: false)
  }
}

//Image Container animation.
extension MaxiSongCardViewController {
  
  private var startColor: UIColor {
    return UIColor.black.withAlphaComponent(0.3)
  }
  
  private var endColor: UIColor {
    return .black
  }
  
  private var imageLayerInsetForOutPosition: CGFloat {
    let imageFrame = view.convert(sourceView.originatingFrameInWindow, to: view)
    let inset = imageFrame.minY - backingImageEdgeInset
    return inset
  }
  
  func configureImageLayerInStartPosition() {
    coverImageContainer.backgroundColor = startColor
    let startInset = imageLayerInsetForOutPosition
    dismissChevron.alpha = 0
    coverImageContainer.layer.cornerRadius = 0
    coverImageContainerTopInset.constant = startInset
    view.layoutIfNeeded()
  }
  
  func animateImageLayerIn() {
    UIView.animate(withDuration: primaryDuration / 4.0) {
      self.coverImageContainer.backgroundColor = self.endColor
    }
    
    UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseIn], animations: {
      self.coverImageContainerTopInset.constant = 0
      self.dismissChevron.alpha = 1
      self.coverImageContainer.layer.cornerRadius = self.cardCornerRadius
      self.view.layoutIfNeeded()
    })
  }
  
  func animateImageLayerOut(completion: @escaping ((Bool) -> Void)) {
    let endInset = imageLayerInsetForOutPosition
    
    UIView.animate(withDuration: primaryDuration / 4.0, delay: primaryDuration , options: [.curveEaseOut], animations: {
      self.coverImageContainer.backgroundColor = self.startColor
    }, completion: { finished in
      completion(finished)
    })
    
    UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseOut], animations: {
      self.coverImageContainerTopInset.constant = endInset
      self.dismissChevron.alpha = 0
      self.coverImageContainer.layer.cornerRadius = 0
      self.view.layoutIfNeeded()
    })
  }
}

//cover image animation
extension MaxiSongCardViewController {

  func configureCoverImageInStartPosition() {
    let originatingImageFrame = sourceView.originatingCoverImageView.frame
    coverImageHeight.constant = originatingImageFrame.height
    coverImageLeading.constant = originatingImageFrame.minX
    coverImageTop.constant = originatingImageFrame.minY
    coverImageBottom.constant = originatingImageFrame.minY
  }
  
  func animateCoverImageIn() {
    let coverImageEdgeContraint: CGFloat = 30
    let endHeight = coverImageContainer.bounds.width - coverImageEdgeContraint * 2
    UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseIn], animations: {
      self.coverImageHeight.constant = endHeight
      self.coverImageLeading.constant = coverImageEdgeContraint
      self.coverImageTop.constant = coverImageEdgeContraint
      self.coverImageBottom.constant = coverImageEdgeContraint
      self.view.layoutIfNeeded()
    })
  }
  
  func animateCoverImageOut() {
    UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseOut], animations: {
      self.configureCoverImageInStartPosition()
      self.view.layoutIfNeeded()
    })
  }
}

//lower module animation
extension MaxiSongCardViewController {
  
  private var lowerModuleInsetForOutPosition: CGFloat {
    let bounds = view.bounds
    return bounds.height - bounds.width
  }
  
  func configureLowerModuleInStartPosition() {
    lowerModuleTopConstraint.constant = lowerModuleInsetForOutPosition
  }
  
  func animateLowerModule(isPresenting: Bool) {
    let topInset = isPresenting ? 0 : lowerModuleInsetForOutPosition
    UIView.animate(withDuration: primaryDuration , delay: 0 , options: [.curveEaseIn], animations: {
      self.lowerModuleTopConstraint.constant = topInset
      self.view.layoutIfNeeded()
    })
  }
  
  func animateLowerModuleOut() {
    animateLowerModule(isPresenting: false)
  }
  
  func animateLowerModuleIn() {
    animateLowerModule(isPresenting: true)
  }
}
