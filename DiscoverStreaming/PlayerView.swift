//
//  PlayerView.swift
//  MusicPlayerTransition
//
//  Created by mac-15 on 13/10/20.
//  Copyright © 2020 xxxAIRINxxx. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    @IBOutlet weak var MiniView: UIView!
    @IBOutlet weak var MiniViewHeightConstraint: NSLayoutConstraint!//60
    @IBOutlet weak var MiniImgView: UIImageView!
    @IBOutlet weak var MiniSongNameLbl: UILabel!
    @IBOutlet weak var ArtistNameLbl: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var BigButton: UIButton!
    
    //Bottom View
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var CrossButton: UIButton!
    @IBOutlet weak var BottomImgView: UIImageView!
    @IBOutlet weak var BottomSongNameLbl: UILabel!
    @IBOutlet weak var BottomArtistNameLbl: UILabel!
    @IBOutlet weak var BottomSongTypeLbl: UILabel!
    
    @IBOutlet weak var MinimumTimeLbl: UILabel!
    @IBOutlet weak var MaximumTimeLbl: UILabel!
    @IBOutlet weak var SongSlider: UISlider!
    
    @IBOutlet weak var PauseAndPlayButton: UIButton!
    @IBOutlet weak var PreviousButton: UIButton!
    @IBOutlet weak var NextButton: UIButton!
    
    @IBOutlet weak var Fav_btn: UIButton!
    @IBOutlet weak var Like_btn: UIButton!
    @IBOutlet weak var Dislike_btn: UIButton!
    
    @IBOutlet weak var LikeCountLbl: UILabel!
    @IBOutlet weak var DislikeCountLbl: UILabel!
    
    @IBOutlet weak var NewSongTblView: UITableView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
