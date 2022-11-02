//
//  MusicPlayerViewController.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 12/10/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerViewController: UIViewController, AVAudioPlayerDelegate {

    var avPlayer = AVAudioPlayer()
    var currentAudioPath:URL!
    var Audiolength = 0.0
    var timer:Timer?
    var totalLengthOfAudio1 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        // Do any additional setup after loading the view.
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
            self.avPlayer = try AVAudioPlayer(contentsOf: url)
            self.avPlayer.prepareToPlay()
            self.avPlayer.volume = 1.0
            self.playAudio()
//            let pause = UIImage(named: "pause")
//            self.playButton.setImage(pause, for: .normal)
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        self.avPlayer.delegate = self
        Audiolength = avPlayer.duration
//        DispatchQueue.main.async {
//        self.playAudio()
//        }
    }

    //MARK:- Player Controls Methods
        func  playAudio(){
            avPlayer.play()
//            startTimer()
        }
        func stopAudiplayer(){
            avPlayer.stop();
        }
        func pauseAudioPlayer(){
            avPlayer.pause()
        }
    
    
    
}



