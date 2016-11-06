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
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
    }
    
    func setMovie(_ movie:MAMovie) {

        titleLabel.text = movie.title!
        releaseDateLabel.text = "\(movie.releaseDate!)"
        if let path = movie.posterPath {
            posterImageView.sd_setImage(with: URL(string: "http://image.tmdb.org/t/p/w300\(path)")!, placeholderImage: UIImage(named: "blankMovie"))
        }
        else {
            posterImageView.image = UIImage(named: "blankMovie")
        }
        
        var genresString = ""
        
        for genreID in movie.genres! {
            if genresDict[genreID] != nil{
                genresString += "\(genresDict[genreID]!), "
            }
        }
        genresString = String(genresString.characters.dropLast())
        genresString = String(genresString.characters.dropLast())
        genresLabel.text = genresString
        
        DispatchQueue.global().async {

            let database = FIRDatabase.database().reference()
            let reviews = database.child("movies").queryOrdered(byChild: "movieID").queryEqual(toValue: movie.id)
            reviews.observeSingleEvent(of: .value, with: {(snapshot) in
                var reviews = Array<MAReview>()
                var sumOfReviews = 0
                if let reviewsDict = snapshot.value as? Dictionary<String, Dictionary<String,AnyObject>> {
                    for (_, review) in reviewsDict {
                        let reviewOBJ = MAReview.init(dict: review)
                        sumOfReviews += (reviewOBJ.ratingValue?.intValue)!
                        reviews.append(reviewOBJ)
                    }
                }
                DispatchQueue.main.async {
                    var ratingVal = -1 as CGFloat
                    if reviews.count > 0 {
                        ratingVal = CGFloat(sumOfReviews)/CGFloat(reviews.count)
                    }
                    self.emojiLabel.text = emojiForRating(ratingVal)
                }
            })
        }
    }
}
