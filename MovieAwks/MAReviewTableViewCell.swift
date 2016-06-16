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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        contentView.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        selectionStyle = .None
    }
    
    func setReview(review:MAReview) {
        usernameLabel.text = review.user!
        commentLabel.text = review.comment!
        
        emojiLabel.text = emojiForRating((review.ratingValue?.floatValue)!)
        
    }

}
