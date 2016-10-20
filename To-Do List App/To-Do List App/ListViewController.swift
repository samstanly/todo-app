//
//  ListViewController.swift
//  To-Do List App
//
//  Created by Sam Steady on 10/18/16.
//  Copyright © 2016 Sam Steady. All rights reserved.


import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    
    var listArray:[String] = []
    
    var checked:[Bool] = []
    
    var timeCompleted:[NSDate] = []

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }


    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell

        cell.textLabel?.text = listArray[indexPath.row]
        
        if !checked[indexPath.row] {
            cell.imageView?.image = UIImage(named: "notchecked")
            cell.textLabel?.textColor = UIColor.black
            
        } else if checked[indexPath.row] {
            cell.imageView?.image = UIImage(named: "check")
            cell.textLabel?.textColor = UIColor.gray
        }
        
        cell.cellButton.tag = indexPath.row
        cell.cellButton.addTarget(self, action: #selector(ListViewController.markAsComplete(_:)), for: .touchUpInside)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    @IBAction func markAsComplete(_ sender: UIButton) {
        checked[sender.tag] = !checked[sender.tag]
        timeCompleted[sender.tag] = NSDate.init()
        UserDefaults.standard.set(checked, forKey: "checked")
        UserDefaults.standard.set(timeCompleted, forKey: "timeCompleted")
        table.reloadData()
        viewWillAppear(true)
        
    }
    
    @IBAction func checkAll(_ sender: AnyObject) {
        if (listArray.count > 0) {
            for i in 0...listArray.count-1 {
                checked[i] = true
            }
            UserDefaults.standard.set(checked, forKey: "checked")
            viewWillAppear(true);
        }
    }
    
    @IBAction func uncheckAll(_ sender: AnyObject) {
        if (listArray.count > 0) {
            for i in 0...listArray.count-1 {
                checked[i] = false
            }
            UserDefaults.standard.set(checked, forKey: "checked")
            viewWillAppear(true);
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let foundArray = UserDefaults.standard.object(forKey: "list")
        let foundChecked = UserDefaults.standard.object(forKey: "checked")
        let foundTime = UserDefaults.standard.object(forKey: "timeCompleted")
        if let tempList = foundArray as? [String] {
            listArray = tempList
        }
        
        if let tempChecked = foundChecked as? [Bool] {
            checked = tempChecked
            
        }
        if let tempFoundTime = foundTime as? [NSDate] {
            timeCompleted = tempFoundTime
        }
        
        var i = 0
        while(true) {
            if (i >= listArray.count) {
                break
            }
            
            if(checked[i] && timeCompleted[i].timeIntervalSinceNow < -86400) {
                listArray.remove(at: i)
                checked.remove(at: i)
                timeCompleted.remove(at: i)
                
                UserDefaults.standard.set(listArray, forKey: "list")
                UserDefaults.standard.set(checked, forKey: "checked")
                UserDefaults.standard.set(timeCompleted, forKey: "timeCompleted")
            } else {
                i+=1
            }
            
        }

        
        table.reloadData()
    }
    
    @IBAction func deleteAll(_ sender: AnyObject) {
        if (listArray.count > 0) {
            let foundDeleted = UserDefaults.standard.object(forKey: "deleted")
            var deletedList = [String]()
            if let tempDeleted = foundDeleted as? [String] {
                deletedList = tempDeleted
                deletedList+=listArray
            } else {
                deletedList = listArray
            }
            
            let foundDeletedStatus = UserDefaults.standard.object(forKey: "deletedStatus")
            var deletedStatus = [Bool]()
            if let tempDeletedStatus = foundDeletedStatus as? [Bool] {
                deletedStatus = tempDeletedStatus
                deletedStatus+=checked
            } else {
                deletedStatus = checked;
            }
            let foundTimeDeleted = UserDefaults.standard.object(forKey: "timeDeleted")
            var timeDeleted = [NSDate]()
            if let tempTimeDeleted = foundTimeDeleted as? [NSDate] {
                timeDeleted = tempTimeDeleted
            }
            for _ in 0...listArray.count-1 {
                timeDeleted.append(NSDate.init())
            }
            
            UserDefaults.standard.set(deletedList, forKey: "deleted")
            UserDefaults.standard.set(deletedStatus, forKey: "deletedStatus")
            UserDefaults.standard.set(timeDeleted, forKey: "timeDeleted")
            
            listArray = [String]()
            checked = [Bool]()
            timeCompleted = [NSDate]()
            
            UserDefaults.standard.set(listArray, forKey: "list")
            UserDefaults.standard.set(checked, forKey: "checked")
            UserDefaults.standard.set(timeCompleted, forKey: "timeCompleted")
            
            table.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let foundDeleted = UserDefaults.standard.object(forKey: "deleted")
            var deletedList = [String]()
            if let tempDeleted = foundDeleted as? [String] {
                deletedList = tempDeleted
                deletedList.append(listArray[indexPath.row])
            } else {
                deletedList = [listArray[indexPath.row]]
            }
            
            let foundDeletedStatus = UserDefaults.standard.object(forKey: "deletedStatus")
            var deletedStatus = [Bool]()
            if let tempDeletedStatus = foundDeletedStatus as? [Bool] {
                deletedStatus = tempDeletedStatus
                deletedStatus.append(checked[indexPath.row])
            } else {
                deletedStatus = [checked[indexPath.row]]
            }
            
            let foundTimeDeleted = UserDefaults.standard.object(forKey: "timeDeleted")
            var timeDeleted = [NSDate]()
            if let tempTimeDeleted = foundTimeDeleted as? [NSDate] {
                timeDeleted = tempTimeDeleted
                timeDeleted.append(NSDate.init())
            } else {
                timeDeleted = [NSDate.init()]
            }
            
            UserDefaults.standard.set(deletedList, forKey: "deleted")
            UserDefaults.standard.set(deletedStatus, forKey: "deletedStatus")
            UserDefaults.standard.set(timeDeleted, forKey: "timeDeleted")

            
            listArray.remove(at: indexPath.row)
            checked.remove(at: indexPath.row)
            timeCompleted.remove(at: indexPath.row)
            
            UserDefaults.standard.set(listArray, forKey: "list")
            UserDefaults.standard.set(checked, forKey: "checked")
            UserDefaults.standard.set(timeCompleted, forKey: "timeCompleted")
            
            table.reloadData()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
