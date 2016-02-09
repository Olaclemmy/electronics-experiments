//
//  ViewController.swift
//  SimpleIOSEddystone
//
//  Created by Glenn De Backer on 23/01/16.
//  Copyright © 2016 Glenn De Backer. All rights reserved.
//

import UIKit
import Eddystone

class ViewController: UIViewController, Eddystone.ScannerDelegate {

    // labels
    @IBOutlet weak var lblEddystoneUUID: UILabel!
    @IBOutlet weak var lblEddystoneStrength: UILabel!
    @IBOutlet weak var lblEddystoneUrl: UILabel!
    
    // button
    @IBOutlet weak var btnSearch: UIButton!

    var urls = Eddystone.Scanner.nearbyUrls

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**
     * process eddystone info
     **/
    func processEddystoneInfo()
    {
        // check if urls has been found
        if(urls.count > 0){
            // update identifier
            lblEddystoneUUID.text = urls[0].identifier
            
            // update url
            lblEddystoneUrl.text =  urls[0].url.absoluteString
            
            // update strength //urls[0].signalStrength
            lblEddystoneStrength.text = String( urls[0].signalStrength)
        }
        
        // disable search button
        btnSearch.setTitle("Beacon found", forState: UIControlState.Normal)
        btnSearch.enabled = false
        
        // start scanning
        Eddystone.Scanner.start(self)
    }
    
    /**
     * Search button clicked
     **/
    @IBAction func searchButtonClicked(sender: AnyObject) {
        // start scanning
        Eddystone.Scanner.start(self)
    }
    
    
    func eddystoneNearbyDidChange() {
        
        print("eddystone")
        
        // store scanned urls
        self.urls = Eddystone.Scanner.nearbyUrls
        
        // process urls
        self.processEddystoneInfo()
    }
}
