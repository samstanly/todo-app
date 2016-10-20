//
//  ListViewController.swift
//  To-Do List App
//
//  Created by Sam Steady on 10/18/16.
//  Copyright © 2016 Sam Steady. All rights reserved.

//func resetChecks() {
//    for i in 0.. < tableView.numberOfSections {
//        for j in 0.. < tableView.numberOfRowsInSection(i) {
//            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i)) {
//                cell.accessoryType = .None
//            }
//        }
//    }
//}
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBAction func checkAll(_ sender: AnyObject) {
        for i in 0...listArray.count-1 {
            checked[i] = true
        }
        UserDefaults.standard.set(checked, forKey: "checked")
        viewWillAppear(true);
    }
    
    @IBAction func uncheckAll(_ sender: AnyObject) {
        for i in 0...listArray.count-1 {
            checked[i] = false
        }
        UserDefaults.standard.set(checked, forKey: "checked")
        viewWillAppear(true);
    }
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    
    var listArray:[String] = []
    
    var checked:[Bool] = []

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
        print(checked[sender.tag])
        UserDefaults.standard.set(checked, forKey: "checked")
        table.reloadData()
        viewWillAppear(true)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let foundArray = UserDefaults.standard.object(forKey: "list")
        let foundChecked = UserDefaults.standard.object(forKey: "checked")
        if let tempList = foundArray as? [String] {
            listArray = tempList
        }
        
        if let tempChecked = foundChecked as? [Bool] {
            checked = tempChecked
        }
        
        table.reloadData()
    }
    
    @IBAction func deleteAll(_ sender: AnyObject) {
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
        
        UserDefaults.standard.set(deletedList, forKey: "deleted")
        UserDefaults.standard.set(deletedStatus, forKey: "deletedStatus")
        
        
        listArray = [String]();
        checked = [Bool]();
        UserDefaults.standard.set(listArray, forKey: "list")
        UserDefaults.standard.set(listArray, forKey: "checked")
        
        table.reloadData()
        
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
            
            UserDefaults.standard.set(deletedList, forKey: "deleted")
            UserDefaults.standard.set(deletedStatus, forKey: "deletedStatus")

            
            listArray.remove(at: indexPath.row)
            checked.remove(at: indexPath.row)
            UserDefaults.standard.set(listArray, forKey: "list")
            UserDefaults.standard.set(listArray, forKey: "checked")
            
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
