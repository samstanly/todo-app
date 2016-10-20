//
//  HistoryViewController.swift
//  To-Do List App
//
//  Created by Sam Steady on 10/18/16.
//  Copyright © 2016 Sam Steady. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
        
        UserDefaults.standard.set(activeList, forKey: "list")
        UserDefaults.standard.set(checkedActive, forKey: "checked")
        
        
        listArray = [String]()
        checked = [Bool]()
        
        UserDefaults.standard.set(listArray, forKey: "deleted")
        UserDefaults.standard.set(checked, forKey: "deletedStatus")
        
        historyTable.reloadData()
    }
    
    @IBAction func clearAll(_ sender: AnyObject) {
        let listArray = [String]();
        let checked = [Bool]();
        UserDefaults.standard.set(listArray, forKey: "deleted")
        UserDefaults.standard.set(checked, forKey: "deletedStatus")
        viewWillAppear(true);
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
        
        UserDefaults.standard.set(activeList, forKey: "list")
        UserDefaults.standard.set(checkedActive, forKey: "checked")
        
        
        listArray.remove(at: sender.tag)
        checked.remove(at: sender.tag)
        
        UserDefaults.standard.set(listArray, forKey: "deleted")
        UserDefaults.standard.set(checked, forKey: "deletedStatus")
        
        historyTable.reloadData()
        
    }

    @IBOutlet weak var historyTable: UITableView!
    
    var listArray:[String] = []
    
    var checked:[Bool] = []
    
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
        if let tempList = foundArray as? [String] {
            listArray = tempList
        }
        
        if let tempChecked = foundChecked as? [Bool] {
            checked = tempChecked
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
