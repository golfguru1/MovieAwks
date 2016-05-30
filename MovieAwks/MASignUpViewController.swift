//
//  ViewController.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import Firebase

class MASignUpViewController: MABaseViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegueWithIdentifier(MA_USER_ALREADY_LOGGED_IN_SEGUE, sender: self)
        }
//        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
//            if let user = user {
//                self.performSegueWithIdentifier(MA_USER_ALREADY_LOGGED_IN_SEGUE, sender: self)
//            } else {
//                // No user is signed in.
//            }
//        }
    }

    @IBAction func signUpPressed(sender: UIButton) {
        view.endEditing(true)
        if (emailField.text! == "" || passwordField.text! == "") {
            showErrorString("Looks like you're missing something...")
            return
        }
        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
            if ((error) != nil) {
                self.showError(error!)
            }
            else{
                self.performSegueWithIdentifier(MA_CONTINUE_SIGN_UP_SEGUE, sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == MA_USER_ALREADY_LOGGED_IN_SEGUE){
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }

}

