//
//  ViewController.swift
//  BananaPlayer
//
//  Created by Admin on 10/1/19.
//  Copyright © 2019 Chuối. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var labelEnd: UILabel!
    @IBOutlet weak var labelCurrent: UILabel!
    @IBOutlet weak var sliderMusic: UISlider!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelArtist: UILabel!
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var pressPlay: UIButton!
    @IBOutlet weak var pressPrevious: UIButton!
    @IBOutlet weak var pressNext: UIButton!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    //MARK: Properties
    let playerSingleton: PlayerSingleton = PlayerSingleton.getInstance()
    var audioPlayer = AVAudioPlayer()
    var songIndex:Int!
    var checkIndexIsNew = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up elements view
//        self.labelName.text = playerSingleton.allSongs[songIndex!].songName
//        self.labelArtist.text = playerSingleton.allSongs[songIndex!].songAuthor
//        self.artworkImage.image = playerSingleton.allSongs[songIndex!].songArtwork
//        prepareTime(index: songIndex)
        setupView(index: songIndex)
        
        self.volumeSlider.value = playerSingleton.currentVolume()
        
        checkIndexIsNew = playerSingleton.checkIndexIsNewOrNot(index: songIndex)
        if !checkIndexIsNew {
            self.navigationTitle.title = "Playing"
            self.pressPlay.isSelected = playerSingleton.isPlaying()
        } else {
            self.navigationTitle.title = ""
        }
        // Do any additional setup after loading the view, typically from a nib.
        Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
        //makePlayList()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if !playerSingleton.flag {
//            self.pressPrevious.isEnabled = false
//            self.pressNext.isEnabled = false
//        }
//    }
    
    private func setupView(index: Int) {
        self.labelName.text = playerSingleton.allSongs[index].songName
        self.labelArtist.text = playerSingleton.allSongs[index].songAuthor
        self.artworkImage.image = playerSingleton.allSongs[index].songArtwork
        prepareTime(index: index)
    }
    
    private func prepareTime(index: Int) {
        // sound file.
//        guard let soundPath = Bundle.main.path(forResource: "SurviveSaidTheProphet", ofType: "mp3") else {
//            return print("cant find any audio")
//        }
       do {

            // Try to get the initialize it with the URL created above
            //audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
        let soundURL = playerSingleton.allSongs[index].songPath
        audioPlayer = try AVAudioPlayer(contentsOf: soundURL)

            // Get song's info
//            let playerItem = AVPlayerItem(url: soundURL)
//            let playerItemMetadata = playerItem.asset.commonMetadata
//
//            //let bundle = Bundle(for: type(of: self))
//            let noImage = UIImage(named:"nullDefault")
//
//            var soundName: String?
//            var soundAuthor: String?
//            var soundArt: UIImage = noImage!
//
//            for item in playerItemMetadata {
//                guard let key = item.commonKey?.rawValue,
//                    let value = item.value else {
//                        continue
//                }
//
//                switch key {
//                case "title": soundName = value as? String
//                case "artist": soundAuthor = value as? String
//                case "artwork" where value is Data: soundArt = UIImage(data: value as! Data)!
//                default:
//                    continue
//                }
//
//            }
//
//            info = SongDetail(songName: soundName!, songAuthor: soundAuthor!, songPath: soundURL, songArtwork: soundArt)
//            self.labelName.text = info?.songName
//            self.labelArtist.text = info?.songAuthor
//            self.artworkImage.image = info?.songArtwork

            // get song playing time
        let duration = audioPlayer.duration
            self.labelEnd.text = displayTime(Float(duration))
            self.sliderMusic.maximumValue = Float(duration)
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    @objc func updateSlider() {
        if !checkIndexIsNew {
            let currentTime = playerSingleton.getAudioCurrentTime()
            sliderMusic.value = currentTime
            self.labelCurrent.text = displayTime(currentTime)
        }
    }
    
    //MARK: Actions
    @IBAction func pressPlay(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if checkIndexIsNew {
            playerSingleton.prepare(index: songIndex!)
            checkIndexIsNew = false
        }
        playerSingleton.play()
        self.navigationTitle.title = "Playing"
        
//        PlayerSingleton.songPlayer.audioPlayer = audioPlayer
//        print("index \(songIndex as Any)")
//        PlayerSingleton.songPlayer.playCalled(inputIndex: songIndex!)
//        if audioPlayer.isPlaying {
//            audioPlayer.stop()
//        } else {
//            audioPlayer.play()
//        }
    }
    
    @IBAction func pressPrevious(_ sender: UIButton) {
        if playerSingleton.flag {
            playerSingleton.previous()
            resetView()
            self.pressPlay.isSelected = true
        }
    }
    
    @IBAction func pressNext(_ sender: UIButton) {
        if playerSingleton.flag {
            playerSingleton.next()
            resetView()
            self.pressPlay.isSelected = true
        }
    }
    
    @IBAction func volumeOnChange(_ sender: Any) {
        playerSingleton.volumeChange(value: volumeSlider.value)
    }
    
    //MARK: Private Methods
    func displayTime(_ time: Float) -> String {
        let minute = Int(time) / 60
        let second = Int(time) % 60
        return String(format: "%02d:%02d", minute, second)
    }
    
    private func resetView() {
        songIndex = playerSingleton.currentPlayIndex
        setupView(index: songIndex)
        self.updateSlider()
    }
//    func extractAllFile(atPath path: String, withExtension fileExtension:String) -> [String] {
//        let pathURL = URL(fileURLWithPath: path, isDirectory: true)
//        var allFiles: [String] = []
//        let fileManager = FileManager.default
//        if let enumerator = fileManager.enumerator(atPath: path) {
//            for file in enumerator {
//                if let path = NSURL(fileURLWithPath: file as! String, relativeTo: pathURL).path, path.hasSuffix(".\(fileExtension)"){
//                    allFiles.append(path)
//                }
//            }
//        }
//        return allFiles
//    }
//    
//    func makePlayList() {
//        let folderPath = Bundle.main.bundlePath
//        let allMp3File = extractAllFile(atPath: folderPath, withExtension: "mp3")
//    }
    
    //MARK: Navigation
    @IBAction func back(_ sender: UIBarButtonItem) {
        if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The PlayingSong is not inside a navigation controller.")
        }
    }
    
}

