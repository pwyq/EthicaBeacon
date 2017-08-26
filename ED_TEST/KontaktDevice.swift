//
//  KontaktDevice.swift
//  ED_TEST
//
//  Created by yanqing on 7/4/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import KontaktSDK

class KontaktDevice: KTKDevicesManager, KTKDevicesManagerDelegate, KTKDeviceConnectionDelegate
{
    var kontaktDeviceList: Array<KTKNearbyDevice>!
    var kontaktDeviceManager: KTKDevicesManager!
    var isKTKDeviceConnected: Bool!

    var viewController: ProgramViewController!    // Used to reference to ProgramBeaconViewController
    
    func initializeKontaktDetecting()
    {
        kontaktDeviceManager = KTKDevicesManager(delegate: self)
        kontaktDeviceList = []
        kontaktDeviceManager.startDevicesDiscovery()
    }
    
    func connectKontaktDevice()
    {
        self.viewController.logMessage("Start connecting Kontakt Beacon.")
        
        let deviceIdentifier = ModifyUserDefaults().getBeaconID(storeName: "Kontakt ID")
        
        
        if let device = kontaktDeviceList?.filter({$0.uniqueID == deviceIdentifier}).first
        {
            let connection = KTKDeviceConnection(nearbyDevice: device)
            
            connection.readConfiguration() { configuration, error in
                if error == nil, let config = configuration
                {
                    self.isKTKDeviceConnected = true
                    self.viewController.enableProgramming(bool: self.isKTKDeviceConnected)
                    print("Advertising interval for beacon \(config.uniqueID!) is \(config.advertisingInterval!)ms")
                    self.viewController.logMessage("\(config.uniqueID!) connected successfully!")
                    self.viewController.logMessage("\(config.uniqueID!) major is \(config.major!), minor is \(config.minor!)")
                }
            }
        }
    }
    
    func modifyBeaconSettings()
    {
        let deviceIdentifier = ModifyUserDefaults().getBeaconID(storeName: "Kontakt ID")
        
        if let device = kontaktDeviceList?.filter({$0.uniqueID == deviceIdentifier}).first
        {
            let connection = KTKDeviceConnection(nearbyDevice: device)
            let newConfiguration = KTKDeviceConfiguration(uniqueID: device.uniqueID!)
            
            let savedMajor = ModifyUserDefaults().getStoredUserInput(storeName: "Study ID")
            let savedMinor = ModifyUserDefaults().getStoredUserInput(storeName: "Participant ID")
//            let savedUUID = ModifyUserDefaults().getBeaconID(storeName: "Beacon ID")
            
            newConfiguration.major = savedMajor as NSNumber?
            newConfiguration.minor = savedMinor as NSNumber?
//            newConfiguration.proximityUUID = savedUUID
            
            connection.write(newConfiguration, completion: { (synchronized, configuration, error) in
                if error == nil
                {
                    self.viewController.logMessage("Configuration applied.")
                    /*
                     The `synchronized` parameter tells you whether the Kontakt.io Cloud API has been notified about the changes on your beacon.
                     If it's `false` (this usually happens when you don't have an Internet access when connecting to a beacon)
                     you should save `configuration` (if available) or your original `KTKDeviceConfiguration` object and attempt synchronization once again.
                     */
                    if !synchronized
                    {
                        // TODO, use https://developer.kontakt.io/ios-sdk/quickstart/api-client/ to deal with pending configurations
                        
                        self.viewController.logMessage("Please try re-configure.")
                    }
                }
            })
        }
    }

    // This function does not got called somehow
    func deviceConnectionDidConnect(_ connection: KTKDeviceConnection)
    {
        self.isKTKDeviceConnected = true
        self.viewController.enableProgramming(bool: isKTKDeviceConnected)
        self.viewController.logMessage("Kontakt Beacon connected successfully!")
    }

    // This function does not got called somehow
    func deviceConnectionDidDisconnect(_ connection: KTKDeviceConnection, withError error: Error?)
    {
        print("KTK Connection failed with error: \(String(describing: error))")
        self.isKTKDeviceConnected = false
        self.viewController.enableProgramming(bool: isKTKDeviceConnected)
        self.viewController.logMessage("Fail to connect!")
    }
    
    
    func devicesManager(_ manager: KTKDevicesManager, didDiscover devices: [KTKNearbyDevice]?) {
        
        guard let nearbyDevices = devices else {
            return
        }
        self.kontaktDeviceList = devices! as Array<KTKNearbyDevice>
        self.viewController.tableViewLabel.reloadData()
        
        for device in nearbyDevices
        {
            if let uniqueID = device.uniqueID
            {
                print("Detected a beacon \(uniqueID)")
                print("battery level: \(device.batteryLevel) firmwareVersion: \(device.firmwareVersion) name: \(String(describing: device.name))")
                print("model: \(device.model) peripheral: \(device.peripheral) rssi: \(device.rssi)")
            }
            else
            {
                print("Detected a beacon with an unknown Unique ID.")
            }
        }
    }
}
