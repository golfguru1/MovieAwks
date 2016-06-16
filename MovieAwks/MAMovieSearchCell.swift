//
//  MAMovieSearchCell.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase

class MAMovieSearchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
    }
    
    func setMovie(movie:MAMovie) {

        titleLabel.text = movie.title!
        releaseDateLabel.text = "\(movie.releaseDate!)"
        if let path = movie.posterPath {
            posterImageView.sd_setImageWithURL(NSURL(string: "http://image.tmdb.org/t/p/w300\(path)")!, placeholderImage: UIImage(named: "blankMovie"))
        }
        else {
            posterImageView.image = UIImage(named: "blankMovie")
        }
        
        var genresString = ""
        
        for genreID in movie.genres! {
            genresString += "\(genresDict[genreID]!), "
        }
        genresString = String(genresString.characters.dropLast())
        genresString = String(genresString.characters.dropLast())
        genresLabel.text = genresString
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let database = FIRDatabase.database().reference()
            let reviews = database.child("movies").queryOrderedByChild("movieID").queryEqualToValue(movie.id)
            reviews.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                var reviews = Array<MAReview>()
                var sumOfReviews = 0
                if let reviewsDict = snapshot.value as? Dictionary<String, Dictionary<String,AnyObject>> {
                    for (_, review) in reviewsDict {
                        let reviewOBJ = MAReview.init(dict: review)
                        sumOfReviews += (reviewOBJ.ratingValue?.integerValue)!
                        reviews.append(reviewOBJ)
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    var ratingVal = Float(-1)
                    if reviews.count > 0 {
                        ratingVal = Float(sumOfReviews)/Float(reviews.count)
                    }
                    self.emojiLabel.text = emojiForRating(ratingVal)
                }
            })
        }
    }
}
