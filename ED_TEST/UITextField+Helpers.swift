//
//  UITextField+Helpers.swift
//  ED_TEST
//
//  Created by yanqing on 6/16/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import UIKit

extension UITextField
{
    // Add a bottom line on user-input box
    func setBottomBorder()
    {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

class CustomUITextField: UITextField
{
//    // Disable paste option for user input
//    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
//    {
//        if action == #selector(UIResponderStandardEditActions.paste(_:))
//        {
//            print("paste has been disabled.")
//            return false
//        }
//        return super.canPerformAction(action, withSender: sender)
//    }
}
