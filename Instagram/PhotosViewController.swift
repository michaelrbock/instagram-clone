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

    var mediaArray: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 320

        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )

        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            // NSLog("response: \(responseDictionary)")
                            self.mediaArray = responseDictionary["data"] as! [NSDictionary]
                            //NSLog("\(self.mediaArray)")
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.michaelrbock.photocell") as! PhotoTableViewCell

        print("here")

        if let images = self.mediaArray[indexPath.row]["images"] as? [String: AnyObject] {
            if let low_resolution = images["low_resolution"] as? [String: AnyObject] {
                if let url = low_resolution["url"] as? String {
                    cell.photoImageView.setImageWithURL(NSURL(string: url)!)
                }
            }
        }

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mediaArray.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

