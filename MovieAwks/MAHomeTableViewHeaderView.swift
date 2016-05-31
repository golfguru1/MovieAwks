//
//  MAHomeTableViewHeaderView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-28.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import SDWebImage

class MAHomeTableViewHeaderView: UIView {

    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movietitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieEmojiLabel: UILabel!
    @IBOutlet weak var submitReviewButton: UIButton!
    
    var delegate: MAHomeTableViewHeaderViewDelegate?
    
    func setMovie(movie:MAMovie, rating:NSNumber) {
        movieRatingLabel.text = "\(rating)/10"
        movietitleLabel.text = movie.title!
        if (rating.integerValue < 2) {
            movieEmojiLabel.text = "😇"
        }
        else if (rating.integerValue < 4) {
            movieEmojiLabel.text = "😐"
        }
        else if (rating.integerValue < 6) {
            movieEmojiLabel.text = "😔"
        }
        else if (rating.integerValue < 8) {
            movieEmojiLabel.text = "😬"
        }
        else if (rating.integerValue < 10) {
            movieEmojiLabel.text = "😵"
        }
        else {
            movieEmojiLabel.text = "💀"
        }
        
        if let path = movie.posterPath {
            moviePosterImageView.sd_setImageWithURL(NSURL(string: "http://image.tmdb.org/t/p/w600\(path)")!, placeholderImage: UIImage(named: "blankMovie"), completed: { (image, error, type, url) in
                let avgColor = image.averageColor()
                let textColor = avgColor.invertColor()
                self.movietitleLabel.textColor = textColor
                self.delegate?.updateStatusBarWithDark(avgColor.isDark())
//                self.movieRatingLabel.textColor = textColor
            })
            
        }
        else {
            moviePosterImageView.image = UIImage(named: "blankMovie")
        }

    }
    
}

protocol MAHomeTableViewHeaderViewDelegate {
    func updateStatusBarWithDark(dark: Bool)
}
