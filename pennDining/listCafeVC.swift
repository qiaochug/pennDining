//
//  listCafeVC.swift
//  pennDining
//
//  Created by Qiaochu Guo on 9/15/17.
//  Copyright © 2017 pennDining. All rights reserved.
//

import UIKit
import Foundation

var url = URL(string: "http://university-of-pennsylvania.cafebonappetit.com/cafe/1920-commons/")

class listCafeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var cafenames : [String] = ["1920 Commons", "McClelland Express","New College House","English House","Falk Kosher Dinning"]
    
    var times : [String] = ["CLOSED","CLOSED","CLOSED","CLOSED","CLOSED"]
    
    var images = [UIImage(named: "1920Commons"),UIImage(named: "mcclelland"),UIImage(named: "nch"),UIImage(named: "kceh"),UIImage(named: "folkkosher") ]
    
    var urls = ["","","","",""]
    
    var today: String = "" //the date of today, updated when view load

    @IBOutlet weak var nb: UINavigationItem!
    @IBOutlet weak var dlabel: UILabel!
    @IBOutlet weak var cafes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cafes.delegate = self
        cafes.dataSource = self
        
        today = checkCalendar() //update date
        
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
                        switch vdict["name"] as! String {
                        case "1920 Commons":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], ind:0)
                            urls[0] = vdict["facilityURL"] as! String
                        case "McClelland Express":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], ind:1)
                            urls[1] = vdict["facilityURL"] as! String
                        case "New College House":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], ind:2)
                            urls[2] = vdict["facilityURL"] as! String
                        case "English House":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], ind:3)
                            urls[3] = vdict["facilityURL"] as! String
                        case "Falk Kosher Dining":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], ind:4)
                            urls[4] = vdict["facilityURL"] as! String
                        default:
                            print("not yet in the list")
                        }
                    }
                    
                }
            }
        }
        
    }
    
    func checkCalendar() -> String{
        var yearstr: String
        var monthstr: String
        var daystr: String
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        yearstr = String(year)
        monthstr = String(month)
        daystr = String(day)
        
        //add padding if there is only one digit
        if (month < 10){
            monthstr = "0" + monthstr
        }
        if (day < 10){
            daystr = "0" + daystr
        }
        
        //return in 2017-09-17 format
        return(yearstr + "-" + monthstr + "-" + daystr)
        
    }
    
    func gethours(data: [[String:Any]], ind: Int){
        var str:String = "CLOSED"
        for datehours in data{
            if datehours["date"] as! String == today{
                str = "" // cafe is not closed, start empty string to record hours
                var meals:[[String:String]] = datehours["meal"] as! [[String:String]]
                if meals.count == 1{
                    str = parseSingle(optime: (meals.first!["open"])!, cltime:
                    (meals.first!["close"])!)
                }else{
                     for meal in meals{
                        var nstr = parseTime(optime: meal["open"]!, cltime: meal["close"]!)
                        str = str + nstr + " | "
                     }
                str = str[0...(str.characters.count-3)]
                }
            }
        }
        print(str)
        times[ind] = str //update the hours for this cafe
    }
    
    func parseSingle(optime: String, cltime: String)-> String{
        var op: Int
        var cl: Int
        //whether it is morning or afternoon
        var opa : Int = 0
        var cla : Int = 0
        
        op = Int(optime[0...1])!
        cl = Int(cltime[0...1])!
        
        if(op > 12){
            op = op - 12
            opa = 1
        }
        if(cl > 12){
            cl = cl - 12
            cla = 1
        }
        
        var opt: String
        var clt: String
        if(optime[3] == "3"){
            opt = String(op) + ":30"
        }else{
            opt = String(op)
        }
        if(opa == 0){
            opt = opt + "a"
        }else{
            opt = opt + "p"
        }
        
        if(cltime[3] == "3"){
            clt = String(cl) + ":30"
        }else{
            clt = String(cl)
        }
        if(cla == 0){
            clt = clt + "a"
        }else{
            clt = clt + "p"
        }
        
        return (opt + " - " + clt)
    }
    
    func parseTime(optime: String, cltime: String)-> String{
        var op: Int
        var cl: Int
        
        op = Int(optime[0...1])!
        cl = Int(cltime[0...1])!
        
        if(op > 12){
            op = op - 12
        }
        if(cl > 12){
            cl = cl - 12
        }
        
        var opt: String
        var clt: String
        if(optime[3] == "3"){
            opt = String(op) + ":30"
        }else{
            opt = String(op)
        }
        if(cltime[3] == "3"){
            clt = String(cl) + ":30"
        }else{
            clt = String(cl)
        }
        
        return (opt + " - " + clt)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        url = URL(string: urls[indexPath.row])
        performSegue(withIdentifier: "segue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}



extension String {
    subscript (i: Int) -> String {
        return String(self[self.characters.index(self.startIndex, offsetBy: i)])
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start..<end]
    }
    
    subscript (r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start...end]
    }
}
