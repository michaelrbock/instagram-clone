//
//  ViewController.swift
//  Instagram
//
//  Created by Michael Bock on 2/3/16.
//  Copyright © 2016 Michael R. Bock. All rights reserved.
//

import AFNetworking
import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var refreshControl = UIRefreshControl()
    var mediaArray: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 320

        refreshControl.addTarget(self, action: "fetchPhotos", forControlEvents: UIControlEvents.ValueChanged)

        tableView.insertSubview(refreshControl, atIndex: 0)

        fetchPhotos()
    }

    func fetchPhotos() {
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )

        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {

                            self.mediaArray = responseDictionary["data"] as! [NSDictionary]

                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                    }
                }
        });
        task.resume()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.michaelrbock.photocell") as! PhotoTableViewCell

        print("here")

        cell.photoImageView.setImageWithURL(getPhotoUrl(indexPath.row)!)

        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mediaArray.count
    }

//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PhotoDetailsViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let photoUrl = getPhotoUrl(indexPath!.row)
        vc.photoUrl = photoUrl
    }

    func getPhotoUrl(row: Int) -> NSURL? {
        if let images = self.mediaArray[row]["images"] as? [String: AnyObject] {
            if let low_resolution = images["low_resolution"] as? [String: AnyObject] {
                if let url = low_resolution["url"] as? String {
                    return NSURL(string: url)!
                }
            }
        }
        return nil
    }
}

