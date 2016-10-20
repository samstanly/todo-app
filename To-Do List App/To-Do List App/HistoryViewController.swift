//
//  HistoryViewController.swift
//  To-Do List App
//
//  Created by Sam Steady on 10/18/16.
//  Copyright © 2016 Sam Steady. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var historyTable: UITableView!
    
    var listArray:[String] = []
    
    var checked:[Bool] = []
    
    var timeDeleted:[NSDate] = []
    
    @IBAction func restoreAll(_ sender: AnyObject) {
        let foundActiveList = UserDefaults.standard.object(forKey: "list")
        var activeList = [String]()
        if let tempActiveList = foundActiveList as? [String] {
            activeList = tempActiveList
            activeList+=listArray
        } else {
            activeList = listArray
        }
        
        let foundActiveStatus = UserDefaults.standard.object(forKey: "checked")
        var checkedActive = [Bool]()
        if let tempCheckedActive = foundActiveStatus as? [Bool] {
            checkedActive = tempCheckedActive
            checkedActive+=checked
        } else {
            checkedActive = checked
        }
        
        let foundTimeCompleted = UserDefaults.standard.object(forKey: "timeCompleted")
        var timeCompleted = [NSDate]()
        if let tempTimeCompleted = foundTimeCompleted as? [NSDate] {
            timeCompleted = tempTimeCompleted
        }
        
        for _ in 0...listArray.count-1 {
            timeCompleted.append(NSDate.init())
        }
        
        UserDefaults.standard.set(activeList, forKey: "list")
        UserDefaults.standard.set(checkedActive, forKey: "checked")
        UserDefaults.standard.set(timeCompleted, forKey: "timeCompleted")
        
        
        listArray = [String]()
        checked = [Bool]()
        timeDeleted = [NSDate]()
        
        UserDefaults.standard.set(listArray, forKey: "deleted")
        UserDefaults.standard.set(checked, forKey: "deletedStatus")
        UserDefaults.standard.set(timeDeleted, forKey: "timeDeleted")
        
        historyTable.reloadData()
    }
    
    @IBAction func clearAll(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure?", message: "This will permanently clear this record of deleted items. This action cannot be undone.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No, cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Yes, clear all", style: .default, handler: { action in
            switch action.style{
            case .default:
                let listArray = [String]()
                let checked = [Bool]()
                let timeDeleted = [NSDate]()
                UserDefaults.standard.set(listArray, forKey: "deleted")
                UserDefaults.standard.set(checked, forKey: "deletedStatus")
                UserDefaults.standard.set(timeDeleted, forKey: "timeDeleted")
                self.viewWillAppear(true);
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
    }
    
    
    
    @IBAction func restoreItem(_ sender: UIButton) {
        let foundActiveList = UserDefaults.standard.object(forKey: "list")
        var activeList = [String]()
        if let tempActiveList = foundActiveList as? [String] {
            activeList = tempActiveList
            activeList.append(listArray[sender.tag])
        } else {
            activeList = [listArray[sender.tag]]
        }
        
        let foundActiveStatus = UserDefaults.standard.object(forKey: "checked")
        var checkedActive = [Bool]()
        if let tempCheckedActive = foundActiveStatus as? [Bool] {
            checkedActive = tempCheckedActive
            checkedActive.append(checked[sender.tag])
        } else {
            checkedActive = [checked[sender.tag]]
        }
        
        let foundTimeCompleted = UserDefaults.standard.object(forKey: "timeCompleted")
        var timeCompleted = [NSDate]()
        if let tempTimeCompleted = foundTimeCompleted as? [NSDate] {
            timeCompleted = tempTimeCompleted
            timeCompleted.append(NSDate.init())
        } else {
            timeCompleted = ([NSDate.init()])
        }
        
        UserDefaults.standard.set(activeList, forKey: "list")
        UserDefaults.standard.set(checkedActive, forKey: "checked")
        UserDefaults.standard.set(timeCompleted, forKey: "timeCompleted")
        
        listArray.remove(at: sender.tag)
        checked.remove(at: sender.tag)
        timeDeleted.remove(at: sender.tag)
        
        UserDefaults.standard.set(listArray, forKey: "deleted")
        UserDefaults.standard.set(checked, forKey: "deletedStatus")
        UserDefaults.standard.set(timeDeleted, forKey: "timeDeleted")
        
        historyTable.reloadData()
        
    }

    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.historyTable.dequeueReusableCell(withIdentifier: "CellDeleted", for: indexPath) as! TableViewCell
        
        cell.textLabel?.text = listArray[indexPath.row]
        cell.textLabel?.backgroundColor = UIColor.clear
        
        if !checked[indexPath.row] {
            cell.imageView?.image = UIImage(named: "notchecked")
            cell.textLabel?.textColor = UIColor.black
        } else if checked[indexPath.row] {
            cell.imageView?.image = UIImage(named: "check")
            cell.textLabel?.textColor = UIColor.gray
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.restoreButton?.tag = indexPath.row
        cell.restoreButton?.addTarget(self, action: #selector(HistoryViewController.restoreItem(_:)), for: .touchUpInside)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let foundArray = UserDefaults.standard.object(forKey: "deleted")
        let foundChecked = UserDefaults.standard.object(forKey: "deletedStatus")
        let foundTimeDeleted = UserDefaults.standard.object(forKey: "timeDeleted")
        if let tempList = foundArray as? [String] {
            listArray = tempList
        }
        
        if let tempChecked = foundChecked as? [Bool] {
            checked = tempChecked
        }
        
        if let tempTimeDeleted = foundTimeDeleted as? [NSDate] {
            timeDeleted = tempTimeDeleted
        }
        
        var i = 0
        while(true) {
            if (i >= listArray.count) {
                break
            }
            
            print(listArray)
            print(checked)
            print(timeDeleted)
            
            if(timeDeleted[i].timeIntervalSinceNow < -86400) {
                listArray.remove(at: i)
                checked.remove(at: i)
                timeDeleted.remove(at: i)
                
                UserDefaults.standard.set(listArray, forKey: "list")
                UserDefaults.standard.set(checked, forKey: "checked")
                UserDefaults.standard.set(timeDeleted, forKey: "timeCompleted")
            } else {
                i+=1
            }
            
        }
        
        historyTable.reloadData()
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
