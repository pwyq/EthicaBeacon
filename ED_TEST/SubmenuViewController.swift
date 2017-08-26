//
//  SubmenuViewController.swift
//  ED_TEST
//
//  Created by yanqing on 6/9/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import Foundation
import UIKit

class SubmenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Enter Submenu View Controller.")
    }
    
    @IBAction func returnToMain() {
        print("Return to previous VC.")        
        dismiss(animated: true, completion: nil)
    }
}
