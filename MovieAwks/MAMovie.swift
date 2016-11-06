//
//  MAMovie.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit

class MAMovie: NSObject {

    var title: String?
    var posterPath: String?
    var backdropPath : String?
    var overview: String?
    var id: NSNumber?
    var releaseDate: String?
    var tagline: String?
    var genres: Array<NSNumber>?
    
    override init() {
        super.init()
    }
    
    init(dict: Dictionary<String, AnyObject>) {
        super.init()
        title = dict["title"] as? String
        posterPath = dict["poster_path"] as? String
        overview = dict["overview"] as? String
        id = dict["id"] as? NSNumber
        releaseDate = dict["release_date"] as? String
        backdropPath = dict["backdrop_path"] as? String
        tagline = dict["tagline"] as? String
        genres = dict["genre_ids"] as? Array<NSNumber>
    }
    
}
