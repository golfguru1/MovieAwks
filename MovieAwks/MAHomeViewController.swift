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
    var tableHeader: MAButtonHeaderView?
    var darkBar: Bool = false
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        
        mm_drawerController.openDrawerGestureModeMask = .BezelPanningCenterView
        mm_drawerController.closeDrawerGestureModeMask = [.PanningCenterView, .TapCenterView]
        
        searchResultsController = UITableViewController.init()

        searchController = UISearchController.init(searchResultsController: searchResultsController)
        searchController!.searchBar.searchBarStyle = .Minimal
        searchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        navigationItem.titleView = searchController?.searchBar
        searchController!.searchBar.frame = CGRect(x: 0, y: UIApplication.sharedApplication().statusBarFrame.maxY, width: view.bounds.size.width, height: 44)
        view.addSubview(searchController!.searchBar)
        
        searchResultsController!.tableView.dataSource = self;
        searchResultsController!.tableView.delegate = self;
        searchResultsController!.tableView.registerNib(UINib(nibName: "MAMovieSearchCell", bundle: nil), forCellReuseIdentifier: MA_MOVIE_SEARCH_CELL)
        searchController!.delegate = self;
        searchController!.searchBar.delegate = self;
        
        headerView = NSBundle.mainBundle().loadNibNamed("MAHomeTableViewHeaderView", owner: self, options: nil).first as? MAHomeTableViewHeaderView
        headerView?.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        headerView?.delegate = self
        reviewsTableView.backgroundView = headerView
//        view.addSubview(headerView!)
//        view.sendSubviewToBack(headerView!)
        
//        let transparentView = UIView.init(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height/2))
//        transparentView.backgroundColor = UIColor.clearColor()
//        reviewsTableView.tableHeaderView = transparentView
        
//        tableHeader = NSBundle.mainBundle().loadNibNamed("MAButtonHeaderView", owner: self, options: nil).first as? MAButtonHeaderView
        headerView!.submitReviewButton.addTarget(self, action: #selector(MAHomeViewController.submitReviewButtonPressed), forControlEvents: .TouchUpInside)
        
        reviewsTableView.rowHeight = UITableViewAutomaticDimension
        reviewsTableView.estimatedRowHeight = 50
        reviewsTableView.contentInset = UIEdgeInsets(top: view.bounds.maxY, left: 0, bottom: 0, right: 0)
        
        
    }
    
    func updateStatusBarWithDark(dark: Bool) {
        darkBar = dark
        UIApplication.sharedApplication().setStatusBarStyle(darkBar ? .LightContent : .Default, animated: true)
    }
    
    func submitReviewButtonPressed() {
        performSegueWithIdentifier(MA_POST_REVIEW_SEGUE, sender: self)
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
            var ratingVal = 0
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (tableView != reviewsTableView){
            return 80
        }
        return UITableViewAutomaticDimension
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if(tableView == reviewsTableView){
//            return tableHeader!
//        }
//        return UIView()
//    }
//    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if(tableView == reviewsTableView){
//            return 50
//        }
//        return 0
//    }
    
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == reviewsTableView){
            
        }
        else{
            movie = movies[indexPath.row]
            searchController?.active = false
            searchController?.searchBar.searchBarStyle = .Minimal
        }
    }
    
    //MARK: UISsearchBarDelegate
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.searchBarStyle = .Prominent
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.searchBarStyle = .Minimal
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var rect = tableHeader?.frame
        rect?.origin.y = min(0, reviewsTableView.contentOffset.y + reviewsTableView.contentInset.top)
        tableHeader?.frame = rect!
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return darkBar ? .LightContent : .Default
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
