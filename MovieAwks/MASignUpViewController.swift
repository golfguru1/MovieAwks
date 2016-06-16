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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if FIRAuth.auth()?.currentUser != nil {
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func cancelPressed(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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

