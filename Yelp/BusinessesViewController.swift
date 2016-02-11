//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //! after initialization of variables means that you will assign values/ use the var later
    var businesses: [Business]!
    
    var filteredBusinesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //set autolayout feature; these 2 rows of code must be used together
        tableView.rowHeight = UITableViewAutomaticDimension
        //estimate row height to make code faster, ultimately calculate row height using auto layout constraints
        tableView.estimatedRowHeight = 120
        
        
        //set up search bar
        searchBar = UISearchBar()
        searchBar.barStyle = UIBarStyle.BlackOpaque
        searchBar.keyboardAppearance = UIKeyboardAppearance.Light
        searchBar.sizeToFit()
        
        //this line of code brings the search bar into the nav bar
        navigationItem.titleView = searchBar
        
        
        searchBar.delegate = self
        
        
        
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            
            //Thai is searched; returns are saved in businesses
            self.businesses = businesses
            self.filteredBusinesses = businesses
            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
        /* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
        self.businesses = businesses
        
        for business in businesses {
        print(business.name!)
        print(business.address!)
        }
        }
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBusinesses != nil {
            
            //filteredBusinesses gets smaller as user searches
            return filteredBusinesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = filteredBusinesses[indexPath.item]
        
        return cell
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        
        let cell = sender as! UITableViewCell
        
        //obtain index path from the cell
        let indexPath = tableView.indexPathForCell(cell)
        
        //index into array to get correct movie
        let business = businesses![indexPath!.row]
        
        //where the segue is going; cast the constant as DetailViewController so we can access the movie property of the detail view controller and set it to the movie we created here
        let DetailsViewController = segue.destinationViewController as! detailsViewController
        
        //set the business from DetailViewController = to the movie constant we made here
        DetailsViewController.business = business

    }
   
    
    
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({(business: Business) -> Bool in
            
            //business.name is an optional; Bool are not optional; must return T or F
            // ?? if business.name holds value, return it. Otherwise, return what is after ??
            business.name?.lowercaseString.containsString(searchText.lowercaseString) ?? false
        })
      tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        self.filteredBusinesses = businesses
        tableView.reloadData()
    }
    
}

