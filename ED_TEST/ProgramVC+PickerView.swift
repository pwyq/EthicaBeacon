//
//  ProgramVC+PickerView.swift
//  ED_TEST
//
//  Created by amin on 6/29/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import UIKit

extension ProgramViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        self.view.endEditing(true)
        return beaconCompanies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return beaconCompanies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.beaconCompanyDisplayLabel.text = self.beaconCompanies[row]
        self.beaconCompanyPickerLabel.isHidden = true
        self.tableViewLabel.isHidden = false
        
        // update beacon sacnning every time user change a Beacon type
        updateBeaconScanning()
        
        if beaconCompanyDisplayLabel.text == "Kontakt.io"
        {
            logMessage("Kontakt Beacon Selected.")
            kontaktDevice.initializeKontaktDetecting()
        }
        else if beaconCompanyDisplayLabel.text == "Estimote Nearable"
        {
            logMessage("Sorry, Estimote Nearable has been disabled for now.")
//            estimoteNearable.initializeNearableRanging()
        }
        else if beaconCompanyDisplayLabel.text == "Estimote Location Beacon"
        {
            logMessage("Estimote Location Beacon Selected.")
        }
        else if beaconCompanyDisplayLabel.text == "Default Testing"
        {
            logMessage("Default Testing Selected.")
        }
        else
        {
            logMessage("Error occurred at beacon model picker.")
        }

        self.tableViewLabel.reloadData()
    }
}
