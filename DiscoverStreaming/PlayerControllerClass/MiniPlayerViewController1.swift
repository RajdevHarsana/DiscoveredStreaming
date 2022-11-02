//
//  MiniPlayerViewController.swift
//  demoLNpopup
//
//  Created by MAC-27 on 23/09/20.
//  Copyright © 2020 MAC-27. All rights reserved.
//

import UIKit

protocol MiniPlayerDelegate: class {
  func expandSong(song: Song)
}

class MiniPlayerViewController1: UIView {

    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var song_img: UIImageView!
    @IBOutlet weak var song_Name: UILabel!
    @IBOutlet weak var artist_Name: UILabel!
    @IBOutlet weak var playPaus_btn: UIButton!
    var currentSong: Song?
    var Image:String!
    var Name:String!
    var songId:Int!
    var asName:String!
    var defaults:UserDefaults!
    
    var buttonGestureHandeler : (() -> Void)?
    var buttonPlayPauseHandeler : (() -> Void)?
    
    
    class func intitiateFromNib() -> MiniPlayerViewController1 {
        let view = UINib.init(nibName: "MiniPlayerViewController1", bundle: nil).instantiate(withOwner: self, options: nil).first as! MiniPlayerViewController1
        return view
    }
    
//   class func loadViewFromNib() -> MiniPlayerViewController1 {
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: "MiniPlayerViewController1", bundle: bundle)
//        return nib.instantiate(withOwner: self, options: nil).first as! MiniPlayerViewController1
//    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        defaults = UserDefaults.standard
         Image = defaults.value(forKey: "SNGIMG") as? String
         Name = defaults.value(forKey: "SNGNAME") as? String
         songId = defaults.integer(forKey: "Song_Id")
         asName = defaults.value(forKey: "ASNAME") as? String
         artist_Name.text = asName
         if  Image == nil {
             
         }else {
         let AddPicture_url = URL.init(string: Image)
         
         song_img.sd_setImage(with: AddPicture_url, placeholderImage: UIImage(named: "Group 4-1"))
         }
         
        
         song_Name.text = Name
         NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("Songpop"), object: nil)
          configure1(song: songId)
        //self.openController()
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        Image = defaults.value(forKey: "SNGIMG") as? String
        Name = defaults.value(forKey: "SNGNAME") as? String
        songId = defaults.integer(forKey: "Song_Id")
        asName = defaults.value(forKey: "ASNAME") as? String
        artist_Name.text = asName
        if  Image == nil {
            
        }else {
            let AddPicture_url = URL.init(string: Image)
            
            song_img.sd_setImage(with: AddPicture_url, placeholderImage: UIImage(named: "Group 4-1"))
        }
        
        
        song_Name.text = Name
        
       configure1(song: songId)
    }

    @IBAction func OnClickButtonAction(_ sender: UIButton) {
        print("Play cvlick")
        buttonGestureHandeler?()
    }
    
    
    @IBAction func playPaus_BtnAction(_ sender: Any) {
        print("Play")
        buttonPlayPauseHandeler?()
        
    }

}

// MARK: - Internal
extension MiniPlayerViewController1 {
  
  func configure(song: Song?) {
    if let song = song {
      song_Name.text = song.title
      song.loadSongImage { [weak self] (image) -> (Void) in
        self?.song_img.image = image
      }
    } else {
      song_Name.text = nil
      song_img.image = nil
    }
    currentSong = song
  }
    
    
    func configure1(song: Int?) {
        
        defaults = UserDefaults.standard
        Image = defaults.value(forKey: "SNGIMG") as? String
        Name = defaults.value(forKey: "SNGNAME") as? String
        songId = defaults.integer(forKey: "Song_Id")
        asName = defaults.value(forKey: "ASNAME") as? String
        song_Name.text = asName
        if  Image == nil {
            
        }else {
            let AddPicture_url = URL.init(string: Image)
            
            song_img.sd_setImage(with: AddPicture_url, placeholderImage: UIImage(named: "Group 4-1"))
        }
        song_Name.text = Name
        
    }
}

// MARK: - MaxiPlayerSourceProtocol
//extension MiniPlayerViewController1: MaxiPlayerSourceProtocol {
//
//  var originatingFrameInWindow: CGRect {
//    return view.convert(view.frame, to: nil)
//  }
//
//  var originatingCoverImageView: UIImageView {
//    return thumbImage
//  }
//}

extension MiniPlayerViewController1 {
    
    func configure1(songId: Int?, songName: String?, songImage: String?, songArtistName: String?) {
        
        
        
        
    }
    
    
}
