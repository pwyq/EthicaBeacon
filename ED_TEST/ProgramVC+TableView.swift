//
//  ProgramVC+TableView.swift
//  ED_TEST
//
//  Created by amin on 6/30/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import UIKit

extension ProgramViewController: UITableViewDelegate, UITableViewDataSource
{
    
    // Call this function when user switches beacon provider OR exit
    func updateBeaconScanning()
    {
        // Question: guard-statement cannot fall-through following conditions
        // Is there any better syntax that can do the job other than if-statement?
        
        if (estimoteNearable.nearableManager != nil)
        {
            estimoteNearable.nearableManager.stopRanging(for: ESTNearableType.all)  // stop scanning
            estimoteNearable.nearableList.removeAll()   // clear array
            tableViewLabel.reloadData() // clear tableView
            estimoteNearable.nearableManager = nil
            print("Nearable ranging stopped; nearableManager has been set to nil.")
        }
        if (estimoteNearable.deviceManager != nil)
        {
            // no need to reload tableView for this one since this deviceManager is only for connecting Estimote's Beacons
            estimoteNearable.deviceManager.stopDeviceDiscovery()
            estimoteNearable.nearableDevice = nil
            estimoteNearable.deviceManager = nil
            print("ESTDevice discovering stopped; ESTDeviceManager has been set to nil.")
        }
//        if (KontaktDevice.kontaktBeaconManager != nil)
//        {
//            KontaktDevice.kontaktBeaconManager.stopRangingBeaconsInAllRegions()
//            KontaktDevice.kontaktList.removeAll()
//            tableViewLabel.reloadData()
//            KontaktDevice.kontaktBeaconManager = nil
//            print("kontakt ranging stopped; Kontakt Beacon manager has been set to nil.")
//        }
        if (kontaktDevice.kontaktDeviceManager != nil)
        {
            kontaktDevice.kontaktDeviceManager.stopDevicesDiscovery()
            kontaktDevice.kontaktDeviceList.removeAll()
            tableViewLabel.reloadData()
            kontaktDevice.kontaktDeviceManager = nil
            print("Kontakt Device discovering stopped; KontaktDeviceManager has been set to nil.")
        }

        print("TableView Cleared. All types of `beacon management` are set to nil.")
    }

    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                          Table View
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        if let beaconModel = beaconCompanyDisplayLabel.text
        {
            switch beaconModel
            {
                case "Kontakt.io":
                    return kontaktDevice.kontaktDeviceList.count
                case "Estimote Location Beacon":
                    return locationBeaconList.count
//                case "Estimote Nearable":
//                    return estimoteNearable.nearableList.count
                default:
                    return testList.count
            }
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if beaconCompanyDisplayLabel.text == "Kontakt.io"
        {
            let kontaktCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "beaconCell")
            let ktkDevice = kontaktDevice.kontaktDeviceList[indexPath.row] as KTKNearbyDevice
            kontaktCell.textLabel?.text = "UniqueID: \(ktkDevice.uniqueID ?? "UNKNOWN")"
            kontaktCell.detailTextLabel?.text = "Battery Level: \(ktkDevice.batteryLevel) RSSI: \(ktkDevice.rssi)"
            return kontaktCell
        }
//        else if beaconCompanyDisplayLabel.text == "Estimote Nearable"
//        {
//            let nearableCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "beaconCell")
//            let nearable = estimoteNearable.nearableList[indexPath.row] as ESTNearable
//            nearableCell.textLabel?.text = "Identifier: \(nearable.identifier)"
//            nearableCell.detailTextLabel?.text = "Type: \(ESTNearableDefinitions.name(for: nearable.type)) RSSI: \(nearable.rssi)"
//            
//            let imageView = UIImageView(frame: CGRect(x: self.view.frame.size.width - 60, y: 30, width: 30, height: 30))
//            imageView.contentMode = UIViewContentMode.scaleAspectFill
//            imageView.image = self.imageForNearableType(nearable.type)
//            nearableCell.contentView.addSubview(imageView)
//            return nearableCell
//        }
        else if beaconCompanyDisplayLabel.text == "Estimote Location Beacon"
        {
            let beaconCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "beaconCell")
            beaconCell.textLabel?.text = locationBeaconList[indexPath.row]
            return beaconCell
            
        }
        else
        {
            let beaconCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "beaconCell")
            beaconCell.textLabel?.text = testList[indexPath.row]
            return beaconCell
        }
    }
    
    // When user select a specific row (i.e., a Beacon) on TableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        
        if beaconCompanyDisplayLabel.text == "Kontakt.io"
        {
            let uniqueID: String = kontaktDevice.kontaktDeviceList[row].uniqueID!
            ModifyUserDefaults().storeBeaconID(storeName: "Kontakt ID", beaconID: uniqueID)
            logMessage("You have selected \(uniqueID)")
            
            kontaktDevice.connectKontaktDevice()
            
        }
//        else if beaconCompanyDisplayLabel.text == "Estimote Nearable"
//        {
//            let beaconID : String = estimoteNearable.nearableList[row].identifier
//            ModifyUserDefaults().storeBeaconID(storeName: "Nearable ID", beaconID: beaconID)
//            logMessage("You have selected \(beaconID)")
//            
//            estimoteNearable.connectEstimoteNearableBeacon()
//        }
        else if beaconCompanyDisplayLabel.text == "Estimote Location Beacon"
        {
            // TODO
            logMessage("3")
            
        }
        else if beaconCompanyDisplayLabel.text == "Default Testing"
        {
            // TODO
            logMessage("4")
        }
        else
        {
            //
            logMessage("Error")
        }
    }
    
    // Define the height-pixel of TableView cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if beaconCompanyDisplayLabel.text == "Kontakt.io"
        {
            return 50
        }
        else if beaconCompanyDisplayLabel.text == "Estimote Location Beacon"
        {
            return 50
        }
//        else if beaconCompanyDisplayLabel.text == "Estimote Nearable"
//        {
//            return 80
//        }
        else
        {
            return 40
        }
    }
}
