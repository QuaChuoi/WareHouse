//
//  SongDetail.swift
//  BananaPlayer
//
//  Created by Admin on 10/3/19.
//  Copyright © 2019 Chuối. All rights reserved.
//

import UIKit

class SongDetail {
    
    
    var songName: String?
    var songAuthor: String?
    var songPath: URL
    var songArtwork: UIImage?
    
    init?(songName: String, songAuthor: String, songPath: URL, songArtwork: UIImage) {
        self.songName = songName
        self.songAuthor = songAuthor
        self.songPath = songPath
        self.songArtwork = songArtwork
    }
}
