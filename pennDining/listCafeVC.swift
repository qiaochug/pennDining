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
    
    let sectionTitles: [String] = ["Dining Halls", "Retail Dining"]
    
    var cafenames : [String] = ["1920 Commons", "McClelland Express","New College House","English House","Falk Kosher Dinning"]
    
    var cafenames2 : [String] = ["Tortas Frontera", "Gourmet Grocer","Houston Market","Joe's Café","Mark's Café","Beefsteak","Starbucks"]
    
    var times : [String] = ["CLOSED","CLOSED","CLOSED","CLOSED","CLOSED"]
    
    var times2 : [String] = ["CLOSED","CLOSED","CLOSED","CLOSED","CLOSED", "CLOSED","CLOSED"]
    
    var images = [UIImage(named: "1920Commons"),UIImage(named: "mcclelland"),UIImage(named: "nch"),UIImage(named: "kceh"),UIImage(named: "folkkosher") ]
    
    var images2 = [UIImage(named: "tortas"),UIImage(named: "gourmetgrocer"),UIImage(named: "houston"),UIImage(named: "Penn.JoesCafe-Int5.72W"),UIImage(named: "marks"),UIImage(named: "beefsteak"),UIImage(named: "starbucks") ]
    
    var urls = ["","","","",""]
    var urls2 = ["","","","","","",""]
    
    var today: String = "" //the date of today, updated when view load

    @IBOutlet weak var nb: UINavigationItem!
    @IBOutlet weak var cafes: UITableView!
    
    var sectionData: [Int: [[Any]]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cafes.delegate = self
        cafes.dataSource = self
        
        sectionData = [0:[cafenames,times,images,urls], 1:[cafenames2,times2,images2,urls2]]
        
        today = checkCalendar() //update date
        
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
                            gethours(data: vdict["dateHours"] as! [[String : Any]], indsec: 0, ind:0)
                            sectionData[0]?[3][0] = vdict["facilityURL"] as! String
                        case "McClelland Express":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], indsec: 0, ind:1)
                            sectionData[0]?[3][1] = vdict["facilityURL"] as! String
                        case "New College House":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], indsec: 0, ind:2)
                            sectionData[0]?[3][2] = vdict["facilityURL"] as! String
                        case "English House":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], indsec: 0, ind:3)
                            sectionData[0]?[3][3] = vdict["facilityURL"] as! String
                        case "Falk Kosher Dining":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], indsec: 0, ind:4)
                            sectionData[0]?[3][4] = vdict["facilityURL"] as! String
                        case "Tortas Frontera at the ARCH":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], indsec: 1, ind:0)
                            sectionData[1]?[3][0] = vdict["facilityURL"] as! String
                        case "1920 Gourmet Grocer":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], indsec: 1, ind:1)
                            sectionData[1]?[3][1] = vdict["facilityURL"] as! String
                        case "Houston Market":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], indsec: 1, ind:2)
                            sectionData[1]?[3][2] = vdict["facilityURL"] as! String
                        case "Joe's Café":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], indsec: 1, ind:3)
                            sectionData[1]?[3][3] = vdict["facilityURL"] as! String
                            print("Joe's Café")
                        case "Mark's Café":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], indsec: 1, ind:4)
                            sectionData[1]?[3][4] = vdict["facilityURL"] as! String
                        case "Beefsteak":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], indsec: 1, ind:5)
                            sectionData[1]?[3][5] = vdict["facilityURL"] as! String
                        case "1920 Starbucks":
                            gethours(data: vdict["dateHours"] as! [[String : Any]], indsec: 1, ind:6)
                            sectionData[1]?[3][6] = vdict["facilityURL"] as! String
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
    
    func gethours(data: [[String:Any]], indsec: Int,ind: Int){
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
        sectionData[indsec]?[1][ind] = str
    }
    
    func parseSingle(optime: String, cltime: String)-> String{
        var op: Int
        var cl: Int
        //whether it is morning or afternoon
        var opa : Int = 0
        var cla : Int = 0
        var opt: String = optime
        var clt: String = cltime
        
        op = Int(opt[0...1])!
        cl = Int(clt[0...1])!
        
        if(opt[3...4] == "59"){
            op = op+1
            opt = String(op)+"00:00"
        }
        if(clt[3...4] == "59"){
            cl = cl+1
            clt = String(cl)+"00:00"
        }
        
        if(op >= 12){
            if(op == 24){
                opa = 0
            }else{
                opa = 1
            }
            if(op > 12){
                op = op - 12
            }
        }
        if(cl >= 12){
            if(cl == 24){
                cla = 0
            }else{
                cla = 1
            }
            if(cl > 12){
                cl = cl - 12
            }
        }
        print(op + cl)
        
        if(opt[3] == "3"){
            opt = String(op) + ":30"
        }else{
            opt = String(op)
        }
        if(opa == 0){
            opt = opt + "a"
        }else{
            opt = opt + "p"
        }
        
        if(clt[3] == "3"){
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
        var opt: String = optime
        var clt: String = cltime
        
        op = Int(opt[0...1])!
        cl = Int(clt[0...1])!
        
        if(opt[3...4] == "59"){
            op = op+1
            opt = String(op)+"00:00"
        }
        if(clt[3...4] == "59"){
            cl = cl+1
            clt = String(cl)+"00:00"
        }
        
        if(op > 12){
            op = op - 12
        }
        if(cl > 12){
            cl = cl - 12
        }
        
        if(opt[3] == "3"){
            opt = String(op) + ":30"
        }else{
            opt = String(op)
        }
        
        if(clt[3] == "3"){
            clt = String(cl) + ":30"
        }else{
            clt = String(cl)
        }
        
        return (opt + " - " + clt)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return (sectionData[section]?.first?.count)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.text = sectionTitles[section] as! String
        label.font = UIFont(name: "HelveticaNeue-Light", size: 21)
        label.frame = CGRect(x:24,y:5, width: 200, height: 35)
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.cafes.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customCell
        
        cell.name.text = sectionData[indexPath.section]!.first?[indexPath.row] as! String
        cell.hours.text = sectionData[indexPath.section]![1][indexPath.row] as! String
        cell.photo.image = sectionData[indexPath.section]![2][indexPath.row] as! UIImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        url = URL(string: sectionData[indexPath.section]![3][indexPath.row] as! String)
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
