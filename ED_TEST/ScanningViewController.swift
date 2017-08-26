//
//  ScanningViewController.swift
//  ED_TEST
//
//  Created by yanqing on 6/6/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import UIKit
import UserNotifications
import CoreBluetooth

struct PeripheralInfo{
    var peripheral: CBPeripheral?
    var lastRSSI: NSNumber?
    var isConnectable: Bool?
}

class ScanningViewController: UIViewController {
    
    @IBOutlet weak var scanStateLabel: UITextField!
    @IBOutlet weak var scanSwitchLabel: UISwitch!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    var centralManager: CBCentralManager?
    var peripherals: [PeripheralInfo] = []
    var selectedPeripheral: CBPeripheral?
    
    @IBAction func scanSwitch(_ sender: UISwitch) {
        scanStateLabel.text = sender.isOn ? "Stop Scanning" : "Start Scanning"
        
        if sender.isOn {
            print("-- Prepare to scan for Peripheral --")
            startScanning()
            print("== Peripheral scanning is ON ==")
        }
        else {
            if centralManager!.isScanning {
                centralManager?.stopScan()
                print("== Stop Peripheral Scanning ==")
            }
        }
    }
    
    override func viewDidLoad() {
        print("Enter Scanning View Controller")
        super.viewDidLoad()
        
        descriptionLabel.isScrollEnabled = false 
        
        // Initialize CoreBluetooth Central Manager
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    func startScanning() {
        peripherals = [] // reset
        self.centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]) // set 'nil' to return all discovered peripherals
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 10)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
            if self.centralManager!.isScanning {
                print("test11111111")
                self.centralManager?.stopScan()
                print("test2222222")
            }
        })
    }
    
    @IBAction func returnToMain() {
        print("Return to previous VC.")
        dismiss(animated: true, completion: nil)
    }
    
}

extension ScanningViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn) {
            startScanning()
        }
        else {
            // TODO: alert user that BLE is not turned on
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        for (index, foundPeripoherals) in peripherals.enumerated() {
            if foundPeripoherals.peripheral?.identifier == peripheral.identifier {
                peripherals[index].lastRSSI = RSSI
                return
            }
        }
        
        let isConnectable = advertisementData["kCBAdvDataIsConnectable"] as! Bool
        let peripheralInfo = PeripheralInfo(peripheral: peripheral, lastRSSI: RSSI, isConnectable: isConnectable)
        peripherals.append(peripheralInfo)
        print("------------------------")
        print(peripheralInfo)
        print("------------------------\n")
    }
}
