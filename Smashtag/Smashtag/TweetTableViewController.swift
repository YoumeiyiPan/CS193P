//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Youmeiyi Pan on 4/27/17.
//  Copyright © 2017 Youmeiyi Pan. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    private  var tweets = [Array<Tweet>] () {
        didSet {
            print(tweets)
        }
    }
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            lastTwitterRequest = nil     // REFRESHING
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    
    // MARK: Updating the Table
    
    
    // just creats a Twitter.Request
    // that finds tweets that match our searchText
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: "\(query) -filter:safe -filter:retweets", count: 100)
        }
        return nil
    }
    
    
    // we track this so that
    // a) we ignore tweets that come back from other than our last request
    // b) when we want to refresh, we only get tweets newer thatn our last request
    private var lastTwitterRequest: Twitter.Request?
    
    
    // takes the searchText part of our Model
    // and fires off a fetch for matching Tweets
    // when they come back (if they're still relevant)
    // we update our tweets array
    // and then let the table view know that we added a section
    // (it will then call our UITableViewDataSource to get what it needs)
    private func searchForTweets() {
       
        if let request = lastTwitterRequest?.requestForNewer ?? twitterRequest() {
             lastTwitterRequest = request
            request.fetchTweets{ [weak self] newTweets in  // this is off the main queue
                DispatchQueue.main.async {   // so we must dispatch back to main queue
                    if request == self?.lastTwitterRequest {
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: .fade)
                }
                self?.refreshControl?.endRefreshing()  //REFRESHING
                }
            }
        } else {
            self.refreshControl?.endRefreshing()   // REFRESHING
        }
        
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }
    
    //MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // we use the row height in the storyboard as an "estimate"
        tableView.estimatedRowHeight = tableView.rowHeight
        // but use whatever autolatyout says the height should be as the actual row height
        tableView.rowHeight = UITableViewAutomaticDimension
        // teh rowHeight could alternaltively be set
        // using the UITableViewDelegate method heightForRowAt
    }
    
    
    // MARK: Search Text Field
    
    // set ourself to be the UITextFieldDelegate
    // so taht we can get thextFieldShouldReturn sent to us
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }

    
    // when the return (i.e. Search) button is pressed in the keboard
    // we go off to search for the text in the searchTextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        
        
        // get the tweet that is associated with this row
        // that the table view is asking us to provide a UITableViewCell for
        let tweet: Tweet = tweets[indexPath.section][indexPath.row]
        
        
        // Configure the cell...
        // the textLabel and detailTextLabel are for non-Custom cells
//        cell.textLabel?.text = tweet.text
//        cell.detailTextLabel?.text = tweet.user.name
        
        // our outlets to our custom UI
        // are connected to this custom UITableViewCell-subclassed cell
        // so we need to tell it which tweet is shown in its row
        // and it can load up its UI through its outlets
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
    }
    
    // Added aftr lecture for REFRESHING
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // make it a little clearer when each pull from Twitter
        // occurs in the table by setting section header titles
        return "\(tweets.count-section)"
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
