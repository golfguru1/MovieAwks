//
//  MADisplayNameViewController.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import Firebase

class MADisplayNameViewController: MABaseViewController {

    @IBOutlet weak var displayNameField: UITextField!
    
    @IBAction func donePressed(sender: UIButton) {
        
        view.endEditing(true)
        if (displayNameField.text! == ""){
            return
        }
        
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            let changeRequest = user.profileChangeRequest()
            
            changeRequest.displayName = displayNameField.text!
            changeRequest.commitChangesWithCompletion { error in
                if let error = error {
                    self.showError(error)
                } else {
                    self.presentingViewController?.dismissViewControllerAnimated(true) {
                        NSNotificationCenter.defaultCenter().postNotificationName("DoneSignUp", object: nil)
                    }
                }
            }
        }
    }
}
