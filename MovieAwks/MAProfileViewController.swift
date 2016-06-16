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
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = FIRAuth.auth()?.currentUser {
            userDisplayNameLabel.text = user.displayName
            userEmailLabel.text = user.email
//            stackView.removeArrangedSubview(createAccountButton)
            createAccountButton.hidden = true
            userEmailLabel.hidden = false
            userAverageReviewLAbel.hidden = false
            userNumberReviewsLabel.hidden = false
            logoutButton.hidden = false
            getUsersReviews(user)
        }
        else{
            userDisplayNameLabel.text = "Sign in to see your stats"
            userEmailLabel.hidden = true
            userAverageReviewLAbel.hidden = true
            userNumberReviewsLabel.hidden = true
            stackView.insertArrangedSubview(createAccountButton, atIndex: 1)
            createAccountButton.hidden = false
            logoutButton.hidden = true
        }
    }
    @IBAction func createAccountPressed(sender: AnyObject) {
        mm_drawerController.closeDrawerAnimated(true) { (completed) in
            if (completed){
                let navController = self.mm_drawerController.centerViewController as! UINavigationController
                navController.viewControllers.first!.performSegueWithIdentifier(MA_SIGN_IN_SEGUE, sender: self)
            }
        }
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        mm_drawerController.closeDrawerAnimated(true) { completed in
            if (completed){
                let navController = self.mm_drawerController.centerViewController as! UINavigationController
                let home = navController.viewControllers.first! as! MAHomeViewController
                home.updateButton()
            }
            
        }
    }
    
    func getUsersReviews(user: FIRUser) {
        let database = FIRDatabase.database().reference()
        let reviews = database.child("movies").queryOrderedByChild("email").queryEqualToValue(user.email)
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
            self.userNumberReviewsLabel.text = "Number of Reviews: \(reviews.count)"
            if reviews.count > 0 {
                let ratingVal = Float(sumOfReviews)/Float(reviews.count)
                self.userAverageReviewLAbel.text = "Average Review: \(round(ratingVal)) \(emojiForRating(ratingVal))"
            }
            else{
                self.userAverageReviewLAbel.text = "Average Review: -"
            }
        })
    }
    
}
