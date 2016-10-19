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
            
        let list = UserDefaults.standard.object(forKey: "list")
        
        var listArray:[String]
        
        if let tempArray = list as? [String] {
            listArray = tempArray
            listArray.append(ItemTextField.text!)
            
        } else {
            
            listArray = ([ItemTextField.text!])
        }
        
        
        UserDefaults.standard.set(listArray, forKey: "list")
        ItemTextField.text = ""
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
