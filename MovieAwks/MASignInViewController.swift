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
    @IBOutlet weak var logInButton: UIButton!{
        didSet{
            logInButton.layer.cornerRadius = 5;
            logInButton.backgroundColor = UIColor.maPurple();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        view.endEditing(true)
        if (emailField.text! == "" || passwordField.text! == "") {
            showErrorString("Looks like you're missing something...")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if ((error) != nil) {
                self.showError(error! as NSError)
            }
            else{
                self.presentingViewController?.dismiss(animated: true) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "DoneSignUp"), object: nil)
                }
            }
        }
    }

    @IBAction func cancelPressed(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == MA_SIGN_IN_SUCCESS_SEGUE){
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
}
