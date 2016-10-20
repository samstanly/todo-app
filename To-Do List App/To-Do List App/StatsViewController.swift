//
//  StatsViewController.swift
//  To-Do List App
//
//  Created by Sam Steady on 10/19/16.
//  Copyright © 2016 Sam Steady. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet weak var numTasks: UILabel!
    
    override func viewDidLoad() {
        var checked = [Bool]()
        let foundChecked = UserDefaults.standard.object(forKey: "checked")
        if let tempChecked = foundChecked as? [Bool] {
            checked = tempChecked
        }
        var numChecked = 0
        if (checked.count > 0) {
            for i in 0...checked.count-1 {
                if(checked[i]) {
                    numChecked += 1
                }
            }
        }
        numTasks.text = String(numChecked)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
