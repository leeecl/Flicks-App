//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Li Chai on 2/8/16.
//  Copyright © 2016 lichai. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: infoView.frame.width, height: infoView.frame.origin.y + infoView.frame.height)
        
        let title = movie["original_title"] as! String
        let overview = movie["overview"] as! String

        titleLabel.text = title
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        navItem.title = title
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();

        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String{
            let imageUrl = NSURL(string: baseUrl + posterPath )
            posterView.setImageWithURL(imageUrl!)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
