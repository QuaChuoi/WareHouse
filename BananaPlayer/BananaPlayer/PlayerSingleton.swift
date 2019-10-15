//
//  PlayerSingleton.swift
//  BananaPlayer
//
//  Created by Admin on 10/8/19.
//  Copyright © 2019 Chuối. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

private protocol MediaManagerProtocol {
    func prepare(index: Int)
    func play()
//    func stop()
    func changeTrack(increase: Int)
    func next()
    func previous()
    func getAudioCurrentTime() -> Float
    func volumeChange(value: Float)
}

class PlayerSingleton: MediaManagerProtocol {
    
    // make a singleton
    private static let songPlayer = PlayerSingleton()

    //MARK: Properties
    private var audioPlayer = AVAudioPlayer()
    var currentPlayIndex:Int?
    var allSongs = [SongDetail]()
    var flag = false
    
    let defaultImage = UIImage(named: "nullDefault")
    
    //MARK: Singleton's methods
    static func getInstance() -> PlayerSingleton {
        return songPlayer
    }
    
    func prepare(index: Int) {
        let soundURL = allSongs[index].songPath
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer.prepareToPlay()
            flag = true
            currentPlayIndex = index
//            let audioSession = AVAudioSession.sharedInstance()
//            try audioSession.setCategory(AVAudioSession.Category)
        } catch {
            print("Error \(error)")
        }
    }
    
    func play() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }
    
//    func stop() {
//        audioPlayer.stop()
//    }
    
    func changeTrack(increase: Int) {
        currentPlayIndex = (currentPlayIndex ?? -1) + increase
        if currentPlayIndex! >= allSongs.count {
            currentPlayIndex = 0
        } else if currentPlayIndex! < 0 {
            currentPlayIndex = allSongs.count - 1
        }
        prepare(index: currentPlayIndex!)
        play()
    }
    
    func next() {
        changeTrack(increase: 1)
    }
    
    func previous() {
        changeTrack(increase: -1)
    }
    
    func volumeChange(value: Float) {
        if flag {
            audioPlayer.volume = value
        }
    }
    
    func currentVolume() -> Float {
        if flag {
            return audioPlayer.volume
        } else {
            return 1
        }
    }
    
    func  getAudioCurrentTime() -> Float {
        return Float(audioPlayer.currentTime)
    }
    
    func checkIndexIsNewOrNot(index: Int) -> Bool {
        return !(index ==  currentPlayIndex)
    }
    
    //MARK: Private Methods
    
    func isPlaying() -> Bool {
        return audioPlayer.isPlaying
    }

    func loadSongsFromDevice() {
        let folderPath = Bundle.main.bundlePath
        let allMp3File = extractAllFile(atPath: folderPath, withExtension: "mp3")

        for path in allMp3File {
            allSongs.append(getSongDetailByPath(sigleMp3Path: path))
        }

    }

    private func extractAllFile(atPath path: String, withExtension fileExtension:String) -> [String] {
        let pathURL = URL(fileURLWithPath: path, isDirectory: true)
        var allFiles: [String] = []
        let fileManager = FileManager.default
        if let enumerator = fileManager.enumerator(atPath: path) {
            for file in enumerator {
                if let path = NSURL(fileURLWithPath: file as! String, relativeTo: pathURL).path, path.hasSuffix(".\(fileExtension)"){
                    allFiles.append(path)
                }
            }
        }
        return allFiles
    }

    private func getSongDetailByPath(sigleMp3Path path: String) -> SongDetail {
        let soundUrl = URL( fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: soundUrl)
        let playerItemMetadata = playerItem.asset.commonMetadata

        var soundName = ""
        var soundArtist = ""
        var soundArt: UIImage = defaultImage!

        for item in playerItemMetadata {
            guard let key = item.commonKey?.rawValue,
                let value = item.value else {
                    continue
            }

            switch key {
            case "title": soundName = value as! String
            case "artist": soundArtist = value as! String
            case "artwork" where value is Data: soundArt = UIImage(data: value as! Data)!
            default:
                continue
            }
        }
        return SongDetail(songName: soundName, songAuthor: soundArtist, songPath: soundUrl, songArtwork: soundArt)!
    }

}
