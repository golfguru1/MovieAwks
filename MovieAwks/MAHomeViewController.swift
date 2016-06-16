//
//  MAHomeViewController.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import MMDrawerController
import SDWebImage
import FirebaseDatabase
import Firebase

class MAHomeViewController: MABaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, MAHomeTableViewHeaderViewDelegate {
    
    var movies: Array<MAMovie> = []
    var reviews: Array<MAReview> = []
    var headerView: MAHomeTableViewHeaderView?
    var darkBar: Bool = false
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDateLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UITextView!
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var postReviewButton: UIButton!
    
    var movie: MAMovie? {
        didSet {
            getReviewsForMovieID((movie?.id)!)
        }
    }
    var searchController: UISearchController?
    var searchResultsController: UITableViewController?
    var firstLoad: Bool = true
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MAHomeViewController.updateButton), name: "DoneSignUp", object: nil)
        
        mm_drawerController.openDrawerGestureModeMask = .BezelPanningCenterView
        mm_drawerController.closeDrawerGestureModeMask = [.PanningCenterView, .TapCenterView]
        
        searchResultsController = UITableViewController.init()
        
        searchController = UISearchController.init(searchResultsController: searchResultsController)
        searchController!.searchBar.searchBarStyle = .Minimal
        searchController?.hidesNavigationBarDuringPresentation = false
        
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurView.frame = (searchResultsController?.tableView.bounds)!
        //        searchResultsController?.view.insertSubview(blurView, atIndex: 0)
        
        searchController?.view.insertSubview(blurView, atIndex: 0)
        definesPresentationContext = true
        navigationItem.titleView = searchController?.searchBar
        
        searchResultsController!.tableView.dataSource = self;
        searchResultsController!.tableView.delegate = self;
        searchResultsController?.modalPresentationStyle = .OverCurrentContext
        searchResultsController?.tableView.backgroundColor = UIColor.clearColor()
        
        searchResultsController!.tableView.registerNib(UINib(nibName: "MAMovieSearchCell", bundle: nil), forCellReuseIdentifier: MA_MOVIE_SEARCH_CELL)
        searchController!.delegate = self;
        searchController!.searchBar.delegate = self;
        
        headerView = NSBundle.mainBundle().loadNibNamed("MAHomeTableViewHeaderView", owner: self, options: nil).first as? MAHomeTableViewHeaderView
        headerView?.frame = view.bounds
        headerView?.delegate = self
        reviewsTableView.backgroundView = headerView
        
        headerView!.submitReviewButton.addTarget(self, action: #selector(MAHomeViewController.submitReviewButtonPressed), forControlEvents: .TouchUpInside)
        
        reviewsTableView.rowHeight = UITableViewAutomaticDimension
        reviewsTableView.estimatedRowHeight = 50
        reviewsTableView.contentInset = UIEdgeInsets(top: view.bounds.maxY, left: 0, bottom: 0, right: 0)
        
        notSearching()
        getGenres()
    }
    
    func showKeyboard() {
        if (firstLoad) {
            searching()
            firstLoad = false
        }
    }
    
    func updateButton() {
        if FIRAuth.auth()?.currentUser != nil {
            headerView!.submitReviewButton.setTitle("Submit Review", forState: .Normal)
        }
        else{
            headerView!.submitReviewButton.setTitle("Sign up to submit review", forState: .Normal)
        }
    }
    
    func notSearching() {
        UIView.animateWithDuration(0.5) {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.translucent = true
            self.searchController?.searchBar.searchBarStyle = .Minimal
            //            self.updateStatusBarWithDark(self.darkBar)
        }
    }
    
    func searching() {
        UIView.animateWithDuration(0.5) {
            //            self.updateStatusBarWithDark(true)
            self.searchController?.searchBar.searchBarStyle = .Default
        }
    }
    
    func updateStatusBarWithDark(dark: Bool) {
        //        darkBar = dark
        //        UIApplication.sharedApplication().setStatusBarStyle(darkBar ? .LightContent : .Default, animated: true)
    }
    
    func submitReviewButtonPressed() {
        if FIRAuth.auth()?.currentUser != nil {
            performSegueWithIdentifier(MA_POST_REVIEW_SEGUE, sender: self)
        }
        else{
            performSegueWithIdentifier(MA_SIGN_IN_SEGUE, sender: self)
        }
    }
    
    func getReviewsForMovieID(id: NSNumber) {
        
        let database = FIRDatabase.database().reference()
        let reviews = database.child("movies").queryOrderedByChild("movieID").queryEqualToValue(id)
        reviews.observeEventType(.Value, withBlock: {(snapshot) in
            self.reviews = []
            var sumOfReviews = 0
            if let reviewsDict = snapshot.value as? Dictionary<String, Dictionary<String,AnyObject>> {
                for (_, review) in reviewsDict {
                    let reviewOBJ = MAReview.init(dict: review)
                    sumOfReviews += (reviewOBJ.ratingValue?.integerValue)!
                    self.reviews.append(reviewOBJ)
                }
            }
            self.reviewsTableView.reloadData()
            var ratingVal = -1
            if self.reviews.count > 0 {
                ratingVal = sumOfReviews/self.reviews.count
            }
            self.headerView!.setMovie(self.movie!, rating: ratingVal)
        })
        
    }
    
    
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == reviewsTableView){
            return reviews.count
        }
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (tableView == reviewsTableView){
            let cell  = tableView.dequeueReusableCellWithIdentifier(MA_REVIEW_TABLE_VIEW_CELL, forIndexPath: indexPath) as! MAReviewTableViewCell
            
            cell.setReview(reviews[indexPath.row])
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MA_MOVIE_SEARCH_CELL, forIndexPath: indexPath) as! MAMovieSearchCell
        
        cell.setMovie(movies[indexPath.row])
        if searchView.superview != nil {
            searchView.removeFromSuperview()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (tableView != reviewsTableView){
            return 80
        }
        return UITableViewAutomaticDimension
    }
    
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == reviewsTableView){
            
        }
        else{
            movie = movies[indexPath.row]
            searchController?.active = false
            notSearching()
        }
    }
    
    //MARK: UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searching()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        notSearching()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text! == "") {
            return
        }
        searchForMovieWithName(searchBar.text!) {
            (response) in
            if response is NSError{
                self.showError(response as! NSError)
            }
            else{
                if let movieResults = response as? Array<MAMovie> {
                    self.movies = movieResults
                    self.searchResultsController?.tableView.reloadData()
                }
            }
            
        }
    }
    
    
    //MARK: UISearchControllerDelegate
    
    func didDismissSearchController(searchController: UISearchController) {
        notSearching()
    }
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == MA_POST_REVIEW_SEGUE) {
            if let reviewVC = segue.destinationViewController as? MARatingViewController {
                reviewVC.movie = movie
            }
        }
    }
    
}
