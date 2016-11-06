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
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.layer.cornerRadius = 5;
            signUpButton.backgroundColor = UIColor.maPurple();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FIRAuth.auth()?.currentUser != nil {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func cancelPressed(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        view.endEditing(true)
        if (emailField.text! == "" || passwordField.text! == "" || displayNameField.text == "") {
            showErrorString("Looks like you're missing something...")
            return
        }
        FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if ((error) != nil) {
                self.showError(error! as NSError)
            }
            else{
                let changeRequest = user!.profileChangeRequest()
                
                changeRequest.displayName = self.displayNameField.text!
                changeRequest.commitChanges { error in
                    if let error = error {
                        self.showError(error as NSError)
                    } else {
                        self.presentingViewController?.dismiss(animated: true) {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "DoneSignUp"), object: nil)
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == MA_USER_ALREADY_LOGGED_IN_SEGUE){
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
}

