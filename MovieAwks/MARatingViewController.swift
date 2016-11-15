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
import SDWebImage
import NVActivityIndicatorView


class MARatingViewController: MABaseViewController {

    @IBOutlet weak var ratingEmojiLabel: UILabel!
    @IBOutlet weak var ratingSlider: ASValueTrackingSlider!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = movie!.title!
        }
    }
    @IBOutlet weak var submitReviewButton: UIButton!{
        didSet{
            submitReviewButton.layer.cornerRadius = 5
            submitReviewButton.layer.masksToBounds = true
            submitReviewButton.backgroundColor = UIColor.maPurple()
        }
    }
    
    @IBOutlet weak var posterImageView: UIImageView!{
        didSet{
            if let path = movie!.posterPath {
                posterImageView.sd_setImage(with: URL(string: "http://image.tmdb.org/t/p/w600\(path)")!, placeholderImage: UIImage(named: "blankMovie"), options: SDWebImageOptions())
                
            }
            else {
                posterImageView.image = UIImage(named: "blankMovie")
            }
        }
    }
    var movie: MAMovie?
    var activityIndicator: NVActivityIndicatorView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingSlider.maximumValue = 10
        ratingSlider.minimumValue = 0
        ratingSlider.value = 0
        
        ratingSlider.setMaxFractionDigitsDisplayed(0)
        ratingSlider.popUpViewAnimatedColors = [UIColor.green, UIColor.yellow, UIColor.orange, UIColor.red]
        changeEmojiWithValue(0)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame = view.bounds
        view.insertSubview(blurView, at: 0)
        
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        changeEmojiWithValue(round(CGFloat(sender.value)))
    }
    
    @IBAction func sliderDone(_ sender: UISlider) {
//        sender.setValue(round(sender.value), animated: true)
    }
    
    func changeEmojiWithValue(_ value: CGFloat) {
        //😇😐😔😬😵💀
        ratingEmojiLabel.text = emojiForRating(value)
    }
    
    @IBAction func submitPressed(_ sender: AnyObject) {
        showLoading()
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        formatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
        let utcTimeZoneStr = formatter.string(from: date as Date)
        
        let review : [String: AnyObject] = ["movieID" : (movie!.id)!,
                                            "ratingValue" : round(ratingSlider.value) as NSNumber,
                                            "user" : (FIRAuth.auth()?.currentUser?.displayName)! as AnyObject,
                                            "comment" : reviewTextView.text as AnyObject,
                                            "email": (FIRAuth.auth()?.currentUser?.email)! as AnyObject,
                                            "timestamp": utcTimeZoneStr as AnyObject
                                            ]
        
        let database = FIRDatabase.database().reference()
        
        let movies = database.child("movies").childByAutoId()
        
        movies.updateChildValues(review) { (error, DB) in
            self.hideLoading()
            if error != nil {
                self.showError(error! as NSError)
            }
            else{
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func showLoading(){
        UIView.animate(withDuration: 0.1, animations:{
            self.submitReviewButton.setTitle("", for: .normal)
            self.activityIndicator = NVActivityIndicatorView(frame: self.submitReviewButton.frame, type: .ballPulse, color: UIColor.white)
            self.activityIndicator?.startAnimating()
            self.submitReviewButton.addSubview(self.activityIndicator!)
        })
    }
    func hideLoading(){
        UIView.animate(withDuration: 0.1, animations:{
            self.submitReviewButton.setTitle("Submit Review", for: .normal)
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
        })
    }
    
    //MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter your review here" {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your review here"
            textView.textColor = UIColor.lightGray
        }
    }

}
