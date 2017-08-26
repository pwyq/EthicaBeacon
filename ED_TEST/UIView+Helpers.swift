//
//  UIView+Helpers.swift
//  ED_TEST
//
//  Created by yanqing on 6/29/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import UIKit

extension UIView {
    func drawBorder(width: CGFloat, color: CGColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
}
