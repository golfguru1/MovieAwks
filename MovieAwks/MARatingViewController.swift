//
//  MARatingViewController.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-27.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import ASValueTrackingSlider
import Firebase
import FirebaseDatabase

class MARatingViewController: MABaseViewController {

    @IBOutlet weak var ratingEmojiLabel: UILabel!
    @IBOutlet weak var ratingSlider: ASValueTrackingSlider!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = movie!.title!
        }
    }
    
    var movie: MAMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingSlider.maximumValue = 10
        ratingSlider.minimumValue = 0
        ratingSlider.value = 0
        
        ratingSlider.setMaxFractionDigitsDisplayed(0)
        ratingSlider.popUpViewAnimatedColors = [UIColor.greenColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.redColor()]
        changeEmojiWithValue(0)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurView.frame = view.bounds
        view.insertSubview(blurView, atIndex: 0)
        
//        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        changeEmojiWithValue(round(sender.value))
    }
    
    @IBAction func sliderDone(sender: UISlider) {
//        sender.setValue(round(sender.value), animated: true)
    }
    
    func changeEmojiWithValue(value: Float) {
        //😇😐😔😬😵💀
        ratingEmojiLabel.text = emojiForRating(value)
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        
        let review : [String: AnyObject] = ["movieID" : (movie!.id)!,
                                            "ratingValue" : round(ratingSlider.value) as NSNumber,
                                            "user" : (FIRAuth.auth()?.currentUser?.displayName)!,
                                            "comment" : reviewTextView.text,
                                            "email": (FIRAuth.auth()?.currentUser?.email)!]
        
        let database = FIRDatabase.database().reference()
        
        let movies = database.child("movies").childByAutoId()
        
        movies.updateChildValues(review) { (error, DB) in
            if error != nil {
                self.showError(error!)
            }
            else{
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    @IBAction func cancelPressed(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Enter your review here" {
            textView.text = nil
            textView.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your review here"
            textView.textColor = UIColor.lightGrayColor()
        }
    }

}
