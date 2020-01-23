//
//  SelectView.swift
//  ResearchProject
//
//  Created by Michael Kelly on 1/23/20.
//  Copyright © 2020 Michael Kelly. All rights reserved.
//

import UIKit
import Foundation
class SelectView: UIView, UITextFieldDelegate
{
    @IBOutlet var table: UITableView!
    @IBOutlet var text: UITextField!
    
    func addStuffToView()
    {
        print("hello")
        text.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        text.resignFirstResponder()
        return true
    }
    
}
