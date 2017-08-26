//
//  ViewController.swift
//  ED_TEST
//
//  Created by amin on 6/6/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitAppAlert()
    {
        let exitAlert = UIAlertController(title: "Quit Ethica Data?",
                                          message: "Unsaved data will be lost",
                                          preferredStyle: UIAlertControllerStyle.alert)
        
        exitAlert.addAction(UIAlertAction(title: "Ok", style: .default,
                                          handler: { (action: UIAlertAction!) in self.exitApp()
                                            print("Handle Ok logic here")
        }))
        
        exitAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel,
                                          handler: { (action: UIAlertAction!) in print("Handle Cancel Logic here")
        }))
        
        present(exitAlert, animated: true, completion: nil)
    }
    
    // calls this function to exit the Application directly
    func exitApp()
    {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
}

