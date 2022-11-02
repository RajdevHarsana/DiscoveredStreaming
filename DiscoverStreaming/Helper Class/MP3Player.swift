//
//  MP3Player.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 23/09/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import AVFoundation

class MP3Player: NSObject, AVAudioPlayerDelegate {
    
    var player = AVAudioPlayer()
    var currentTrackIndex = 0
    var tracks:[String] = [String]()
    var audioLength1 = 0.0
    
    override init(){
        tracks = FileReader.readFiles()
        super.init()
        
//        queueTrack();
    }
    
    func downloadFileFromURL(url:NSURL){

        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            self?.play(url: URL! as NSURL)
        })

        downloadTask.resume()

    }
    func play(url:NSURL) {
        print("playing \(url)")

        do {
            self.player = try AVAudioPlayer(contentsOf: url as URL)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        player.delegate = self
    }

    func queueTrack(){
        if (player != nil) {
//            player = nil
        }
         
//        var error:NSError?
        let url = NSURL.fileURL(withPath: tracks[currentTrackIndex] as String)
        player = try! AVAudioPlayer(contentsOf: url)
             
//        if let hasError = error {
//            //SHOW ALERT OR SOMETHING
//        } else {
        
        player.prepareToPlay()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetTrackNameText"), object: nil)
//        }
    }

    func play() {
        if player.isPlaying == false {
            player.play()
     }
    }
    
    func stop(){
        if player.isPlaying == true {
            player.stop()
            player.currentTime = 0
        }
    }
    
    func pause(){
        if player.isPlaying == true{
            player.pause()
        }
    }
    
    func nextSong(songFinishedPlaying:Bool){
        var playerWasPlaying = false
        if player.isPlaying == true {
            player.stop()
            playerWasPlaying = true
        }
     
        currentTrackIndex+=1
         if currentTrackIndex >= tracks.count {
            currentTrackIndex = 0
        }
        queueTrack()
        if playerWasPlaying || songFinishedPlaying {
            player.play()
        }
    }

    func previousSong(){
        var playerWasPlaying = false
        if player.isPlaying == true {
            player.stop()
            playerWasPlaying = true
        }
        currentTrackIndex-=1
        if currentTrackIndex < 0 {
            currentTrackIndex = tracks.count - 1
        }
             
        queueTrack()
        if playerWasPlaying {
            player.play()
        }
    }
    
    func getCurrentTrackName() -> String {
        let trackName = tracks[currentTrackIndex]
        return trackName
    }
    
    func getCurrentTimeAsString() -> String {
     var seconds = 0
     var minutes = 0
        if let time:Double = player.currentTime {
         seconds = Int(time) % 60
         minutes = (Int(time) / 60) % 60
     }
     return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    
    func getProgress()->Float{
        var theCurrentTime = 0.0
        var theCurrentDuration = 0.0
        if let currentTime:Double = player.currentTime, let duration:Double = player.duration {
            theCurrentTime = currentTime
            theCurrentDuration = duration
        }
        return Float(theCurrentTime / theCurrentDuration)
    }
    
    func setVolume(volume:Float){
        player.volume = volume
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if flag == true {
            nextSong(songFinishedPlaying: true)
        }
    }
    
    

}
