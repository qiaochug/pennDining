//
//  listCafeVC.swift
//  pennDining
//
//  Created by Qiaochu Guo on 9/15/17.
//  Copyright © 2017 pennDining. All rights reserved.
//

import UIKit
import Foundation

class listCafeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var cafenames : [String] = ["1920 Commons", "McClelland Express","New College House","English House","Falk Kosher Dinning"]
    
    var times : [String] = ["11 - 2 | 5 - 7:30","8 - 10 | 11 - 2","5 - 7","8:30 - 10 | 11 - 2 |5 - 8","11:30 - 2 | 8:15 - 10"]
    
    var images = [UIImage(named: "1920Commons"),UIImage(named: "mcclelland"),UIImage(named: "nch"),UIImage(named: "kceh"),UIImage(named: "folkkosher") ]

    @IBOutlet weak var nb: UINavigationBar!
    @IBOutlet weak var dininglabel: UILabel!
    @IBOutlet weak var cafes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cafes.delegate = self
        cafes.dataSource = self
        
        let usabledata: Data
        
        let urlString = URL(string: "http://api.pennlabs.org/dining/venues")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                } else {
                    if let usabledata = data {
                        print(usabledata) //JSONSerialization
                        self.updateDetail(data: usabledata)
                    }
                }
            }
        task.resume()
        }
        
        
    }
    
    func updateDetail(data: Data){
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let dictionary = json as? [String: Any] {
            
            if let nestedDictionary = dictionary["document"] as? [String: Any] {
                
                if let venues = nestedDictionary["venue"] as? [[String:Any]] {
                    
                    for vdict in venues{
                        print(vdict["name"])
                    }
                    
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafenames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.cafes.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customCell
        
        cell.photo.image = images[indexPath.row]
        cell.name.text = cafenames[indexPath.row]
        cell.hours.text = times[indexPath.row]
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
