//
//  menuDetailVC.swift
//  pennDining
//
//  Created by Qiaochu Guo on 9/15/17.
//  Copyright © 2017 pennDining. All rights reserved.
//

import UIKit

class menuDetailVC: UIViewController {
    
    @IBOutlet var menuw: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //unwrap the url passed by the previous view controller(listCafeVC)
        if let unwrappedURL = url {
            
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if error == nil {
                    
                    self.menuw.loadRequest(request)
                    
                } else {
                    //if there is no internet, pop errer message
                    let alertController = UIAlertController(title: "No Network", message:
                        "No Network Connection Found", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    //also print the error message to console
                    print("ERROR: \(error)")
                    
                }
                
            }
            
            task.resume()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
