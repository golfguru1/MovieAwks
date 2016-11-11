//
//  MAHomeViewController.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-10-27.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import SDWebImage
import QuartzCore
import Firebase
import FirebaseDatabase

class MAHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate {

    
    @IBOutlet weak var posterImageView: UIImageView!{
        didSet{
            posterImageView.layer.cornerRadius = 5
            posterImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UITextView!
    var isSearching: Bool = false
    
    var movieToDisplay: MAMovie?{
        didSet{
            titleLabel.text = movieToDisplay!.title!
            synopsisTextView.text = movieToDisplay!.overview!
            yearLabel.text = movieToDisplay!.releaseDate!
            loadUI()
            
            DispatchQueue.global().async {
                
                let database = FIRDatabase.database().reference()
                let reviews = database.child("movies").queryOrdered(byChild: "movieID").queryEqual(toValue: self.movieToDisplay!.id)
                reviews.observe(.value, with: {(snapshot) in
                    var reviews = Array<MAReview>()
                    var sumOfReviews = 0
                    if let reviewsDict = snapshot.value as? Dictionary<String, Dictionary<String,AnyObject>> {
                        for (_, review) in reviewsDict {
                            let reviewOBJ = MAReview.init(dict: review)
                            sumOfReviews += (reviewOBJ.ratingValue?.intValue)!
                            reviews.append(reviewOBJ)
                        }
                    }
                    DispatchQueue.main.async {
                        var ratingVal = -1 as CGFloat
                        if reviews.count > 0 {
                            ratingVal = CGFloat(sumOfReviews)/CGFloat(reviews.count)
                            self.reviewsLabel.text = "\(emojiForRating(ratingVal)) \(String(format: "%.0f",round(ratingVal)))/10 awks: \(reviews.count) reviews"
                            self.seeReviewsButton.isEnabled = true
                        }
                        else{
                            self.reviewsLabel.text = "No Reviews yet"
                            self.seeReviewsButton.isEnabled = false
                        }
                    }
                })
            }

            
            if let path = movieToDisplay!.posterPath {
                posterImageView.contentMode = .center
                self.gradient.removeFromSuperlayer()
                posterImageView.sd_setImage(with: URL(string: "http://image.tmdb.org/t/p/w600\(path)")!, placeholderImage: UIImage(named: "blankMovie"), options: SDWebImageOptions()){ (image, error, cacheType, imageURL) in
                    self.posterImageView.contentMode = .scaleAspectFill
                    self.gradient.frame = self.posterImageView.bounds
                    self.posterImageView.layer.addSublayer(self.gradient)

                }
                
            }
            else {
                posterImageView.image = UIImage(named: "blankMovie")
            }

        }
    }
    
    @IBOutlet weak var submitReviewButton: UIButton!{
        didSet{
            submitReviewButton.layer.cornerRadius = 5
            submitReviewButton.backgroundColor = UIColor.maPurple()
        }
    }
    @IBOutlet weak var seeReviewsButton: UIButton!
    lazy var gradient: CAGradientLayer! = {
        var tempGradient = CAGradientLayer()
        tempGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        return tempGradient
    }()
    var searchResults = Array<MAMovie>()
    let searchResultsController = UITableViewController()
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController!.navigationBar.barTintColor = UIColor.maBlack()
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.isTranslucent = false
        
        mm_drawerController.openDrawerGestureModeMask = .bezelPanningCenterView
        mm_drawerController.closeDrawerGestureModeMask = [.panningCenterView, .tapCenterView]
        
        searchResultsController.view.backgroundColor = UIColor.maBlack()
        searchResultsController.tableView.delegate = self
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.register(UINib(nibName: "MAMovieSearchCell", bundle: nil), forCellReuseIdentifier: MA_MOVIE_SEARCH_CELL)
        searchResultsController.tableView.estimatedRowHeight = 80
        searchResultsController.tableView.rowHeight = UITableViewAutomaticDimension
        searchResultsController.modalPresentationStyle = .overCurrentContext
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController!.delegate = self
        searchController!.searchBar.delegate = self
        searchController!.dimsBackgroundDuringPresentation = false
        searchController!.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        navigationItem.titleView = searchController!.searchBar
        searchController!.isActive = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        getGenres()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func hamburgerPressed(_ sender: AnyObject) {
        mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    @IBAction func submitReviewPressed(_ sender: AnyObject) {
        if let _ = FIRAuth.auth()?.currentUser {
            performSegue(withIdentifier: MA_POST_REVIEW_SEGUE, sender: self)
        }
        else{
            performSegue(withIdentifier: MA_SIGN_IN_SEGUE, sender: self)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text
        
        if (!isSearching){
            if (searchResults.count > 0){
                searchResultsController.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
//            searchResultsController.tableView.contentOffset = CGPoint(x: 0, y: 0)
            isSearching = true
            searchForMovieWithName(searchText!) { (result) in
                self.isSearching = false
                if let error = result as? NSError{
                    print(error)
                }
                else{
                    self.searchResults = result as! Array<MAMovie>
                    self.searchResultsController.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieToDisplay = searchResults[indexPath.row]
        searchController!.isActive = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MA_MOVIE_SEARCH_CELL, for: indexPath) as! MAMovieSearchCell
        
        cell.setMovie(searchResults[indexPath.row])
        
        return cell
    }
    
    func loadUI(){
        titleLabel.backgroundColor = UIColor.clear
        reviewsLabel.backgroundColor = UIColor.clear
        yearLabel.backgroundColor = UIColor.clear
        synopsisTextView.backgroundColor = UIColor.clear
        submitReviewButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == MA_POST_REVIEW_SEGUE){
            if let vc = segue.destination as? MARatingViewController{
                vc.movie = movieToDisplay
            }
        }
        else if (segue.identifier == MA_SEE_REVIEWS_SEGUE){
            if let vc = segue.destination as? MAReviewsViewController{
                vc.movie = movieToDisplay
            }
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        searchResultsController.tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
}
