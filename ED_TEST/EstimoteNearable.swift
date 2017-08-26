//
//  EstimoteNearable.swift
//  ED_TEST
//
//  Created by yanqing on 6/30/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

class EstimoteNearable: ESTBeaconConnection ,ESTNearableManagerDelegate,
    ESTDeviceManagerDelegate, ESTDeviceConnectableDelegate
{
    var nearableList:Array<ESTNearable>!
    var nearableManager:ESTNearableManager!
    var deviceManager: ESTDeviceManager!    // Declare EST Device Manager
    var nearableDevice: ESTDeviceNearable!  // Declare a nearable device
    var isNearableConnected: Bool!
    var nearableBroadcastingScheme: ESTBroadcastingScheme = ESTBroadcastingScheme.iBeacon   // Set to `iBeacon` mode
    
    var viewController: ProgramViewController!    // Used to reference to ProgramBeaconViewController
    
    func initializeNearableRanging()
    {
        nearableList = []
        nearableManager = ESTNearableManager()
        nearableManager.delegate = self
        nearableManager.startRanging(for: ESTNearableType.all)
    }
    
    func stopNearableRanging()
    {
        nearableManager.stopRanging(for: ESTNearableType.all)
    }
    
    func nearableManager(_ manager: ESTNearableManager, didRangeNearables nearables: [ESTNearable], with type: ESTNearableType) {
        self.nearableList = nearables as Array<ESTNearable>
        self.viewController.tableViewLabel.reloadData()
        print(nearables)
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                      EST Device Methods
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    func connectEstimoteNearableBeacon()
    {
        self.viewController.logMessage("Start connecting Estimote Nearable Beacon")
        activateESTDeviceManager()
        
        let deviceIdentifier = ModifyUserDefaults().getBeaconID(storeName: "Nearable ID")
        let deviceFilter = ESTDeviceFilterNearable(identifier: deviceIdentifier!)
        deviceManager.startDeviceDiscovery(with: deviceFilter)
    }
    
    func activateESTDeviceManager()
    {
        deviceManager = ESTDeviceManager()
        deviceManager.delegate = self
        print("ESTDeviceManager activated!")
    }
    
    func deviceManager(_ manager: ESTDeviceManager, didDiscover devices: [ESTDevice])
    {
        guard let device = devices.first as? ESTDeviceNearable else {
            self.viewController.logMessage("Please nudge the nearable for connecting.")
            return
        }
        deviceManager.stopDeviceDiscovery()
        nearableDevice = device
        nearableDevice.delegate = self
        nearableDevice.connect()
        print("EST DEVICE Connecting starts at deviceManager.")
    }
    
    func estDeviceConnectionDidSucceed(_ device: ESTDeviceConnectable)
    {
        // After beacon is connected successfully, enable program button
        isNearableConnected = true
        self.viewController.enableProgramming(bool: isNearableConnected)
        self.viewController.logMessage("Nearable connected successfully!")
    }
    
    func estDevice(_ device: ESTDeviceConnectable, didDisconnectWithError error: Error?)
    {
        print("Disconnected with error: \(String(describing: error))")
        isNearableConnected = false
        self.viewController.enableProgramming(bool: isNearableConnected)
        self.viewController.logMessage("Beacon disconnected. Try reconnecting.")
    }
    
    func estDevice(_ device: ESTDeviceConnectable, didFailConnectionWithError error: Error)
    {
        print("EST Connection Status is: \(device.connectionStatus.rawValue)")
        print("EST Connection failed with error: \(error)")
        self.viewController.logMessage("Fail to connect!")
    }
}
