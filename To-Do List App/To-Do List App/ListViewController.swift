//
//  ListViewController.swift
//  To-Do List App
//
//  Created by Sam Steady on 10/18/16.
//  Copyright © 2016 Sam Steady. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            listArray.remove(at: indexPath.row)
            checked.remove(at: indexPath.row)
            table.reloadData()
            UserDefaults.standard.set(listArray, forKey: "list")
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
