//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Li Chai on 1/10/16.
//  Copyright © 2016 lichai. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var movies: [NSDictionary]?
    var endpoint: String = ""
    
    var filteredData: [NSDictionary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        filteredData = movies
        
        loadDataFromNetwork()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // update movies data
    func loadDataFromNetwork(){
        
        // create NSURLRequest request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                // ... Remainder of response handling code ...
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.movies = (responseDictionary["results"] as! [NSDictionary])
                            self.tableView.reloadData()
                    }
                }
                
        });
        task.resume()
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // In case there's network call and movie is nil
        if let movies = movies {
            errorView.hidden = true
            return movies.count
            
        } else {
            errorView.hidden = false
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell",forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["original_title"] as! String
        let overview =  movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String{
        let imageUrl = NSURL(string: baseUrl + posterPath )
            cell.posterView.setImageWithURL(imageUrl!)
        }
        
        // custom selected background
        let customColorView = UIView.init()
        let themeColor = UIColor(red: 192.0/255.0, green: 18.0/255.0, blue: 13.0/255.0 , alpha: 1)

        customColorView.backgroundColor = themeColor
        cell.selectedBackgroundView = customColorView
        
        return cell
    }

    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl){
        
        loadDataFromNetwork()
        refreshControl.endRefreshing()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![(indexPath?.row)!]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
    }
    
    

}
