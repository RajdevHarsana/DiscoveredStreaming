import UIKit
import SDWebImage
import AVFoundation
class BaseViewTabBarController: UIViewController, UITabBarDelegate,AVAudioPlayerDelegate{
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var tabbar = UITabBar()
    var tabBarItems = NSArray()
    
    let tabitem1 = UITabBarItem()
    let tabitem2 = UITabBarItem()
    let tabitem3 = UITabBarItem()
    let tabitem4 = UITabBarItem()
    
    var miniplayerView = UIView()
    var musicImg = UIImageView()
    var playButton = UIButton()
    var songNameLbl = UILabel()
    var artistNameLbl = UILabel()
    var mainPlayerButton = UIButton()
    var Admintimer = Timer()
    
    var MusicPlayer = AVAudioPlayer()
    
    var currentAudioPath:URL!
    var SongTyp = String()
    var newSongId = String()
    var newSongImg = String()
    
    override func viewDidLoad() {
        let song_file = DataManager.getVal(Config().AppUserDefaults.object(forKey: "song_file")) as? String ?? ""
        let vc =  song_file.replacingOccurrences(of: " ", with: "")
        let AddPicture_url = URL.init(string: vc)
        if AddPicture_url != nil{
            print(AddPicture_url!)
            self.currentAudioPath = AddPicture_url
            //        let url = NSURL(string: AddPicture_url)
            //        print("the url = \(url!)")
            downloadFileFromURL(url: currentAudioPath! as NSURL)
            
        }

        self.miniPlayerUI()
        
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                let bottom = window.safeAreaInsets.bottom
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    switch Int(UIScreen.main.nativeBounds.size.height) {
                    case 2436:
                        self.tabbar.frame = CGRect(x: 0, y: screenHeight-79, width: screenWidth, height: 49)
                    case 2688:
                        print("iPhone XS Max/11 Pro Max")
                        self.tabbar.frame = CGRect(x: 0, y: screenHeight-69, width: screenWidth, height: 49)//XR
                    case 1792:
                        print("iPhone XR/ 11 ")
                        self.tabbar.frame = CGRect(x: 0, y: screenHeight-69, width: screenWidth, height: 49)//XR
                    default:
                        self.tabbar.frame = CGRect(x: 0, y: screenHeight-69, width: screenWidth, height: 49)//XR
                    }
                }
            }
        }else{
            self.tabbar.frame = CGRect(x: 0, y: screenHeight-69, width: screenWidth, height: 49)
        }
        
        self.tabbar.tintColor = UIColor.systemRed
        self.tabbar.barTintColor = UIColor.black
        self.tabbar.delegate = self
        self.tabbar.backgroundColor = UIColor.green
        
        self.tabitem1.image = UIImage(named: "Pin")
        self.tabitem1.selectedImage = UIImage(named: "Pin")
        self.tabitem1.tag = 0
        self.tabitem1.title = "Location"
        
        self.tabitem2.image = UIImage(named: "Restorent")
        self.tabitem2.selectedImage = UIImage(named: "Restorent")
        self.tabitem2.tag = 1
        self.tabitem2.title = "Manage"
        
        self.tabitem3.image = UIImage(named: "Car")
        self.tabitem3.selectedImage = UIImage(named: "Car")
        self.tabitem3.tag = 2
        self.tabitem3.title = "Car"
        
        self.tabitem4.image = UIImage(named: "IceCreem")
        self.tabitem4.selectedImage = UIImage(named: "IceCreem")
        self.tabitem4.tag = 3
        self.tabitem4.title = "Ice"
        
        self.tabBarItems = [self.tabitem1,self.tabitem2,self.tabitem3,self.tabitem4]
        self.tabbar.items = self.tabBarItems as? [UITabBarItem]
        self.view.addSubview(self.tabbar)
        
    }
    
    func miniPlayerUI(){
        
        self.miniplayerView.frame = CGRect(x: 0, y: screenHeight-139, width: screenWidth, height: 60)
        self.miniplayerView.backgroundColor = UIColor.white
        self.view.addSubview(self.miniplayerView)
        
        self.musicImg.frame = CGRect(x: 8, y: 8, width: 44, height: 44)
        self.musicImg.layer.cornerRadius = 6
        self.musicImg.clipsToBounds = true
        self.musicImg.backgroundColor = UIColor.clear
        
        self.miniplayerView.addSubview(self.musicImg)
        
        self.playButton.frame = CGRect(x: self.miniplayerView.frame.size.width - 52, y: 8, width: 44, height: 44)
        self.playButton.backgroundColor = UIColor.clear
        self.playButton.setImage(UIImage(named: "play-1"), for: .normal)
        self.playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        self.miniplayerView.addSubview(self.playButton)
        
        
        self.songNameLbl.frame = CGRect(x: 60, y: 8, width: self.miniplayerView.frame.size.width - 120, height: 22)
        self.songNameLbl.textAlignment = .left
        self.songNameLbl.textColor = UIColor.black
        self.songNameLbl.numberOfLines = 1
        self.songNameLbl.clipsToBounds = true
        self.songNameLbl.backgroundColor = UIColor.clear
        
        self.miniplayerView.addSubview(self.songNameLbl)
        
        
        self.artistNameLbl.frame = CGRect(x: 60, y: 32, width: self.miniplayerView.frame.size.width - 120, height: 22)
        self.artistNameLbl.textAlignment = .left
        self.artistNameLbl.textColor = UIColor.black
        self.artistNameLbl.numberOfLines = 1
        self.artistNameLbl.clipsToBounds = true
        self.artistNameLbl.backgroundColor = UIColor.clear
        
        self.miniplayerView.addSubview(self.artistNameLbl)
        
        self.mainPlayerButton.frame = CGRect(x: 0, y: 0, width: self.miniplayerView.frame.size.width - 60, height: 60)
        self.mainPlayerButton.backgroundColor = UIColor.clear
        self.mainPlayerButton.addTarget(self, action: #selector(mainPlayerButtonAction), for: .touchUpInside)
        self.miniplayerView.addSubview(self.mainPlayerButton)
        
        self.Admintimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerdata1), userInfo: nil, repeats: true)
        
    }
    func downloadFileFromURL(url:NSURL){

        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            self?.prepareAudioSong(url: URL!)
        })

        downloadTask.resume()

    }
    // MARK: - Prepare audio for playing
    func prepareAudioSong(url : URL){

        print("playing \(url)")

        do {
            self.MusicPlayer = try AVAudioPlayer(contentsOf: url)
            self.MusicPlayer.prepareToPlay()
            self.MusicPlayer.volume = 1.0
            self.MusicPlayer.play()
            let pause = UIImage(named: "pause")
            self.playButton.setImage(pause, for: .normal)
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        self.MusicPlayer.delegate = self
    }
    
    @objc func timerdata1(){
        print("one time")
        let NewSong = DataManager.getVal(Config().AppUserDefaults.object(forKey: "NewSong")) as? String ?? ""
        let NewArtist = DataManager.getVal(Config().AppUserDefaults.object(forKey: "NewArtist")) as? String ?? ""
        let songImg = DataManager.getVal(Config().AppUserDefaults.object(forKey: "songImg")) as? String ?? ""
        let songType = DataManager.getVal(Config().AppUserDefaults.object(forKey: "hot_music")) as? String ?? ""
        let songID = DataManager.getVal(Config().AppUserDefaults.object(forKey: "id")) as? String ?? ""
        
        self.songNameLbl.text = NewSong
        self.artistNameLbl.text = NewArtist
        self.musicImg.sd_setImage(with: URL(string: songImg), placeholderImage: UIImage(named: "Group 4-1"))
        self.SongTyp = songType
        self.newSongId = songID
        self.newSongImg = songImg
        
    }
    
    @objc func playButtonAction(_ sender: UIButton){
        print("Play")
                
        if self.MusicPlayer.isPlaying{
            self.MusicPlayer.pause()
            let play = UIImage(named: "play-1")
            self.playButton.setImage(play, for: .normal)
        }else{
            self.MusicPlayer.play()
            let pause = UIImage(named: "pause")
            self.playButton.setImage(pause, for: .normal)
        }
        
    }
    @objc func mainPlayerButtonAction(_ sender: UIButton){
        print("main Button ")
        let vc = MaxiSongViewController(nibName: "MaxiSongViewController", bundle: nil)
        let navController = UINavigationController(rootViewController: vc)
        vc.songName = self.songNameLbl.text!
        vc.songImage = self.newSongImg
        vc.songArtist = self.artistNameLbl.text!
//        vc.SongID = self.newSongId
        vc.SongType = self.SongTyp
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            //let detailVC = MyQuestionVC(nibName: "MyQuestionVC", bundle: nil)
            //self.RootViewWithSideManu(detailVC)
        }else if(item.tag == 1) {
            
        }else if(item.tag == 2) {
            
        }else if(item.tag == 3) {
            
        }
    }
}
