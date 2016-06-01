//
//  MAMovieSearchCell.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import SDWebImage

class MAMovieSearchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    func setMovie(movie:MAMovie) {

        titleLabel.text = movie.title!
        releaseDateLabel.text = "\(movie.releaseDate!)"
        if let path = movie.posterPath {
            posterImageView.sd_setImageWithURL(NSURL(string: "http://image.tmdb.org/t/p/w300\(path)")!, placeholderImage: UIImage(named: "blankMovie"))
        }
        else {
            posterImageView.image = UIImage(named: "blankMovie")
        }
    }
}
