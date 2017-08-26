//
//  NSObject+Helpers.swift
//  ED_TEST
//
//  Created by yanqing on 6/19/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

extension NSObject
{
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
