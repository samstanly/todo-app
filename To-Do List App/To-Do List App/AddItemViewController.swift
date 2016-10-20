//
//  ViewController.swift
//  To-Do List App
//
//  Created by Sam Steady on 10/18/16.
//  Copyright © 2016 Sam Steady. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var ItemTextField: UITextField!
    
    @IBAction func AddItem(_ sender: AnyObject) {
        if(ItemTextField.text! == "") {
            let alert = UIAlertController(title: "No item name", message: "Please provide a valid, non-empty name for this item", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let foundList = UserDefaults.standard.object(forKey: "list")
        let foundChecked = UserDefaults.standard.object(forKey: "checked")
        
        var listArray:[String]
        var checked:[Bool]
        
        if let tempArray = foundList as? [String] {
            listArray = tempArray
            listArray.append(ItemTextField.text!)
        } else {
            listArray = ([ItemTextField.text!])
        }
        
        if let tempChecked = foundChecked as? [Bool] {
            checked = tempChecked
            checked.append(false)
        } else {
            checked = ([false])
        }

        
        
        UserDefaults.standard.set(listArray, forKey: "list")
        UserDefaults.standard.set(checked, forKey: "checked")
        ItemTextField.text = ""
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
