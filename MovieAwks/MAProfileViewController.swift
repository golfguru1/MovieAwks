//
//  MAProfileViewController.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import Firebase

class MAProfileViewController: MABaseViewController {
    
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNumberReviewsLabel: UILabel!
    @IBOutlet weak var userAverageReviewLAbel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var createAccountButton: UIButton!{
        didSet{
            createAccountButton.layer.cornerRadius = 5;
            createAccountButton.backgroundColor = UIColor.maPurple();
        }
    }
    @IBOutlet weak var logoutButton: UIButton!{
        didSet{
            logoutButton.backgroundColor = UIColor.maOrange();
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = FIRAuth.auth()?.currentUser {
            userDisplayNameLabel.text = user.displayName
            userEmailLabel.text = user.email
//            stackView.removeArrangedSubview(createAccountButton)
            createAccountButton.isHidden = true
            userEmailLabel.isHidden = false
            userAverageReviewLAbel.isHidden = false
            userNumberReviewsLabel.isHidden = false
            logoutButton.isHidden = false
            getUsersReviews(user)
        }
        else{
            userDisplayNameLabel.text = "Sign in to see your stats"
            userEmailLabel.isHidden = true
            userAverageReviewLAbel.isHidden = true
            userNumberReviewsLabel.isHidden = true
            stackView.insertArrangedSubview(createAccountButton, at: 1)
            createAccountButton.isHidden = false
            logoutButton.isHidden = true
        }
    }
    @IBAction func createAccountPressed(_ sender: AnyObject) {
        mm_drawerController.closeDrawer(animated: true) { (completed) in
            if (completed){
                let navController = self.mm_drawerController.centerViewController as! UINavigationController
                navController.viewControllers.first!.performSegue(withIdentifier: MA_SIGN_IN_SEGUE, sender: self)
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        mm_drawerController.closeDrawer(animated: true, completion: nil)
    }
    
    func getUsersReviews(_ user: FIRUser) {
        let database = FIRDatabase.database().reference()
        let reviews = database.child("movies").queryOrdered(byChild: "email").queryEqual(toValue: user.email)
        reviews.observe(.value, with: {(snapshot) in
            var reviews = Array<MAReview>()
            var sumOfReviews = 0
            if let reviewsDict = snapshot.value as? Dictionary<String, Dictionary<String,AnyObject>> {
                for (_, review) in reviewsDict {
                    let reviewOBJ = MAReview.init(dict: review)
                    sumOfReviews += (reviewOBJ.ratingValue?.intValue)!
                    reviews.append(reviewOBJ)
                }
            }
            self.userNumberReviewsLabel.text = "Number of Reviews: \(reviews.count)"
            if reviews.count > 0 {
                let ratingVal = CGFloat(sumOfReviews)/CGFloat(reviews.count)
                self.userAverageReviewLAbel.text = "Average Review: \(round(ratingVal)) \(emojiForRating(ratingVal))"
            }
            else{
                self.userAverageReviewLAbel.text = "Average Review: -"
            }
        })
    }
    
}
