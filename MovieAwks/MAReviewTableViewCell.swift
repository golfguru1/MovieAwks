//
//  MAReviewTableViewCell.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-27.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit

class MAReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    func setReview(review:MAReview) {
        usernameLabel.text = review.user!
        commentLabel.text = review.comment!
        
        if (review.ratingValue?.intValue < 2) {
            emojiLabel.text = "😇"
        }
        else if (review.ratingValue?.intValue < 4) {
            emojiLabel.text = "😐"
        }
        else if (review.ratingValue?.intValue < 6) {
            emojiLabel.text = "😔"
        }
        else if (review.ratingValue?.intValue < 8) {
            emojiLabel.text = "😬"
        }
        else if (review.ratingValue?.intValue < 10) {
            emojiLabel.text = "😵"
        }
        else {
            emojiLabel.text = "💀"
        }
    }

}
