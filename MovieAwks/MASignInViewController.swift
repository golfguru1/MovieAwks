//
//  MASignInViewController.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import Firebase

class MASignInViewController: MABaseViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    @IBAction func signInPressed(sender: UIButton) {
        view.endEditing(true)
        if (emailField.text! == "" || passwordField.text! == "") {
            showErrorString("Looks like you're missing something...")
            return
        }
        FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
            if ((error) != nil) {
                self.showError(error!)
            }
            else{
                self.performSegueWithIdentifier(MA_SIGN_IN_SUCCESS_SEGUE, sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == MA_SIGN_IN_SUCCESS_SEGUE){
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
}
