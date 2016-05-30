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
        // Do any additional setup after loading the view.
    }
    @IBAction func sliderChanged(sender: UISlider) {
        changeEmojiWithValue(round(sender.value))
    }
    @IBAction func sliderDone(sender: UISlider) {
//        sender.setValue(round(sender.value), animated: true)
    }
    
    func changeEmojiWithValue(value: Float) {
        //😇😐😔😬😵💀
        if (value < 2) {
            ratingEmojiLabel.text = "😇"
        }
        else if (value < 4) {
            ratingEmojiLabel.text = "😐"
        }
        else if (value < 6) {
            ratingEmojiLabel.text = "😔"
        }
        else if (value < 8) {
            ratingEmojiLabel.text = "😬"
        }
        else if (value < 10) {
            ratingEmojiLabel.text = "😵"
        }
        else {
            ratingEmojiLabel.text = "💀"
        }
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        
        let review : [String: AnyObject] = ["movieID" : (movie!.id)!,
                                            "ratingValue" : round(ratingSlider.value) as NSNumber,
                                            "user" : (FIRAuth.auth()?.currentUser?.displayName)!,
                                            "comment" : reviewTextView.text]
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
