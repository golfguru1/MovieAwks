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

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = FIRAuth.auth()?.currentUser {
            userDisplayNameLabel.text = user.displayName
    //                let email = profile.email
    //                let photoURL = profile.photoURL
        } else {
            // No user is signed in.
        }
    }
    
}
