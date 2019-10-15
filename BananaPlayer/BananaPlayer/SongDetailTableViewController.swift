//
//  SongDetailTableViewController.swift
//  BananaPlayer
//
//  Created by Admin on 10/7/19.
//  Copyright © 2019 Chuối. All rights reserved.
//

import UIKit
import AVFoundation
import os.log

class SongDetailTableViewController: UITableViewController {
    
    //MARK: Outlet
    @IBOutlet weak var backToPlaying: UIBarButtonItem!
    
    //MARK: Properties
    var songs = [SongDetail]()
    let playerSingleton: PlayerSingleton = PlayerSingleton.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backToPlaying.isEnabled = playerSingleton.flag
        playerSingleton.loadSongsFromDevice()
        songs = playerSingleton.allSongs
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backToPlaying.isEnabled = playerSingleton.flag
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SongDetailTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SongDetailTableViewCell else {
            fatalError("The dequeued cell is not an instance of SongDetailTableViewCell.")
        }

        // Fetches the appropriate song for the data source layout.
        let song = songs[indexPath.row]
        
        cell.nameLabel.text = song.songName
        cell.authorLabel.text = song.songAuthor
        cell.artworkImage.image = song.songArtwork

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        guard let songDetailViewController = segue.destination as? ViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
//        let selectedSong = songs[indexPath.row]
//        songDetailViewController.song = selectedSong
        switch (segue.identifier ?? "") {
        case "BackToPlaying":
            songDetailViewController.songIndex = playerSingleton.currentPlayIndex
        case "ShowDetails":
            guard let selectedSongCell = sender as? SongDetailTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedSongCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            songDetailViewController.songIndex = indexPath.row
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
        // songDetailViewController.songIndex = indexPath.row
    }
 
    
    
    //MARK: Private Methods
    
//    private func extractAllFile(atPath path: String, withExtension fileExtension:String) -> [String] {
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
//    private func loadSongsFromDevice() {
//        let folderPath = Bundle.main.bundlePath
//        let allMp3File = extractAllFile(atPath: folderPath, withExtension: "mp3")
//
//        //print("all \(allMp3File)")
//        for path in allMp3File {
//            songs.append(getSongDetailByPath(sigleMp3Path: path))
//        }
//
//    }
    
//    let rawPath = Bundle.main.path(forResource: "SurviveSaidTheProphet", ofType: "mp3")
//    let rawURL = URL( fileURLWithPath: rawPath)

//    private func getSongDetailByPath(sigleMp3Path path: String) -> SongDetail {
//        let soundUrl = URL( fileURLWithPath: path)
//        let playerItem = AVPlayerItem(url: soundUrl)
//        let playerItemMetadata = playerItem.asset.commonMetadata
//
//        var soundName = ""
//        var soundArtist = ""
//        var soundArt: UIImage = defaultImage!
//
//        for item in playerItemMetadata {
//            guard let key = item.commonKey?.rawValue,
//            let value = item.value else {
//                continue
//            }
//
//            switch key {
//            case "title": soundName = value as! String
//            case "artist": soundArtist = value as! String
//            case "artwork" where value is Data: soundArt = UIImage(data: value as! Data)!
//            default:
//                continue
//            }
//        }
//        return SongDetail(songName: soundName, songAuthor: soundArtist, songPath: soundUrl, songArtwork: soundArt)!
//    }

}
