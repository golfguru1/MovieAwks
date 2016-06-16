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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurView.frame = view.bounds
        view.insertSubview(blurView, atIndex: 0)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.lightGrayColor().CGColor, UIColor.blackColor().CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        navigationController?.navigationBarHidden = true
    }
    
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
