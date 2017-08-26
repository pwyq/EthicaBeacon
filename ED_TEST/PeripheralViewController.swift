//
//  PeripheralViewController.swift
//  ED_TEST
//
//  Created by yanqing on 6/6/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

/* To broadcast iPhone as iBeacon (foreground and background)
 In background mode, signal will disappear after a few seconds
 When bring back again from background mode, it will continue broadcasting
 
 bug:
 when stop button pressed, app will crash --fixed
*/

import Foundation
import UIKit
import CoreBluetooth

class PeripheralViewController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    var localBeacon : CLBeaconRegion!
    var beaconPeripheralData : NSDictionary!
    var peripheralManager : CBPeripheralManager!
    
    // acts as an intermediary between your app and the iOS Bluetooth stack
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        var statusMessage = ""
        
        switch peripheral.state {
        case .poweredOn:
            statusMessage = "Bluetooth Status: Turned On"
            
        case .poweredOff:
            statusMessage = "Bluetooth Status: Turned Off"
            
        case .resetting:
            statusMessage = "Bluetooth Status: Resetting"
            
        case .unauthorized:
            statusMessage = "Bluetooth Status: Not Authorized"
            
        case .unsupported:
            statusMessage = "Bluetooth Status: Not Supported"
            
        default:
            statusMessage = "Bluetooth Status: Unknown"
        }
        
        print(statusMessage)
        
        if peripheral.state == .poweredOn {
            print("Prepare to start Advertising")
            peripheralManager.startAdvertising(beaconPeripheralData as! [String : AnyObject]!)
            print("Advertising started")
        }
        else if peripheral.state == .poweredOff {
            print("Prepare to stop Advertising")
            peripheralManager.stopAdvertising()
            print("Advertising stopped")
        }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        initLocalBeacon()
    }
    @IBAction func stopButton(_ sender: UIButton) {
        stopLocalBeacon()
    }    
    
    // creates the beacon and starts broadcasting
    func initLocalBeacon() {
        print("initLocalBeacon() got called")
        if localBeacon != nil {
            stopLocalBeacon()
        }
        stateText.text = "Broadcasting"
        
        let localBeaconUUID = "0A0AC4F4-5C5C-4A6B-9BDF-C55BBEA42973" // proximityUUID
        let localBeaconMajor : CLBeaconMajorValue = 1111
        let localBeaconMinor : CLBeaconMinorValue = 2222
        let localBeaconID = "com.test.myDeviceRegion"
        
        let uuid = UUID(uuidString: localBeaconUUID)!
        localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: localBeaconID)
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        print("initLocalBeacon() ended")
    }
    // stops the beacon
    func stopLocalBeacon() {
        print("stopLocalBeacon() got called")
        stateText.text = "Idling"
        if self.peripheralManager != nil
        {
            peripheralManager.stopAdvertising()
            peripheralManager = nil
            beaconPeripheralData = nil
            localBeacon = nil
        }
        print("stopLocalBeacon() ended")
    }
    
    override func viewDidLoad() {
        print("Enter Peripheral View Controller")
        super.viewDidLoad()
        
        descriptionLabel.isScrollEnabled = false
    }
    
    
    @IBAction func returnToMain() {
        print("Return to previous VC. Leave Peripheral View Controller.")
        if localBeacon != nil {
            stopLocalBeacon()
        }
        dismiss(animated: true, completion: nil)
    }
}
