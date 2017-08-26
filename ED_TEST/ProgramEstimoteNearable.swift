//
//  EstimoteNearableMajor.swift
//  ED_TEST
//
//  Created by yanqing on 6/30/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

class ProgramEstimoteNearable: ESTBeaconConnection
{
    
    // USELESS
    func modifyMajor()
    {
        writeMajor(6666) { (uint16, error) in
            guard error == nil else {
                print("\(String(describing: error)) occurred.")
                return
            }
        }
    }
}
