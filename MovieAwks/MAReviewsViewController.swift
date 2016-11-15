//
//  MAHomeViewController.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import MMDrawerController
import SDWebImage
import FirebaseDatabase
import Firebase

class MAReviewsViewController: MABaseViewController, UITableViewDelegate, UITableViewDataSource {

    var reviews: Array<MAReview> = []

    @IBOutlet weak var reviewsTableView: UITableView!
    
    var movie: MAMovie? {
        didSet {
            getReviewsForMovieID((movie?.id)!)
        }
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewsTableView.rowHeight = UITableViewAutomaticDimension
        reviewsTableView.estimatedRowHeight = 50
    }
    
    
    func submitReviewButtonPressed() {
        if FIRAuth.auth()?.currentUser != nil {
            performSegue(withIdentifier: MA_POST_REVIEW_SEGUE, sender: self)
        }
        else{
            performSegue(withIdentifier: MA_SIGN_IN_SEGUE, sender: self)
        }
    }
    
    func getReviewsForMovieID(_ id: NSNumber) {
        
        let database = FIRDatabase.database().reference()
        let reviews = database.child("movies").queryOrdered(byChild: "movieID").queryEqual(toValue: id)
        reviews.observe(.value, with: {(snapshot) in
            self.reviews = []
            var sumOfReviews = 0
            if let reviewsDict = snapshot.value as? Dictionary<String, Dictionary<String,AnyObject>> {
                for (_, review) in reviewsDict {
                    let reviewOBJ = MAReview.init(dict: review)
                    sumOfReviews += (reviewOBJ.ratingValue?.intValue)!
                    self.reviews.append(reviewOBJ)
                }
            }
            self.reviews.sort(by:{$0.timestamp! > $1.timestamp!})
            if (self.reviewsTableView != nil){
                self.reviewsTableView.reloadData()
            }
//            var ratingVal = -1 as CGFloat
//            if self.reviews.count > 0 {
//                ratingVal = CGFloat(sumOfReviews)/CGFloat(self.reviews.count)
//            }
        })
        
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: MA_REVIEW_TABLE_VIEW_CELL, for: indexPath) as! MAReviewTableViewCell
        
        cell.setReview(reviews[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
}
