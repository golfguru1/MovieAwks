//
//  MAHomeTableViewHeaderView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-28.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth

class MAHomeTableViewHeaderView: UIView {

    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movietitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieEmojiLabel: UILabel!
    @IBOutlet weak var submitReviewButton: UIButton!{
        didSet{
            submitReviewButton.titleLabel?.textAlignment = NSTextAlignment.center
            submitReviewButton.titleLabel!.numberOfLines = 0;
            submitReviewButton.titleLabel!.adjustsFontSizeToFitWidth = true;
            submitReviewButton.titleLabel!.lineBreakMode = .byWordWrapping;
        }
    }
    
    func setMovie(_ movie:MAMovie, rating:CGFloat) {
        movieRatingLabel.text = "\(rating)/10"
        movietitleLabel.text = movie.title!
        if (rating < 0) {
            movieRatingLabel.text = "-"
        }
        
        movieEmojiLabel.text = emojiForRating(rating)
        
        if let path = movie.posterPath {
            moviePosterImageView.sd_setImage(with: URL(string: "http://image.tmdb.org/t/p/w600\(path)")!, placeholderImage: UIImage(named: "blankMovie"), options: SDWebImageOptions())
            
        }
        else {
            moviePosterImageView.image = UIImage(named: "blankMovie")
        }
        
        if FIRAuth.auth()?.currentUser == nil {
            submitReviewButton.setTitle("Sign up to submit review", for: UIControlState())
        }

    }
    
}
