//
//  UIViewController+Helpers.swift
//  ED_TEST
//
//  Created by yanqing on 6/16/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

/*
 
 This Swift file is used to place reuseable code for Submenu-Group
 
 */

import UIKit

extension UIViewController
{
    func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            if self.view.frame.origin.y == 0
            {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            if self.view.frame.origin.y != 0
            {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func addDoneButton(textField : CustomUITextField)
    {
        // Set a done button when user ending input
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        numberToolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        textField.inputAccessoryView = numberToolbar
    }
    
    func doneClicked()
    {
        view.endEditing(true)
        print("done button clicked.")
    }
    
    @IBAction func returnToPreVC()
    {
        print("Leaving \(self.className).")
        dismiss(animated: true, completion: nil)
    }
}
