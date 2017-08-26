//
//  EddystoneViewController.swift
//  ED_TEST
//
//  Created by yanqing on 6/8/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import UIKit

class EddystoneViewController: UIViewController, EddystoneScannerDelegate {
    
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var scanSwitchLabel: UISwitch!
    @IBOutlet weak var scanStateLabel: UITextField!

    var eddystoneBeaconScanner: EddystoneScanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Enter Scanning View Controller")
        
        descriptionLabel.isScrollEnabled = false
        
        self.eddystoneBeaconScanner = EddystoneScanner()
        self.eddystoneBeaconScanner!.delegate = self
        self.eddystoneBeaconScanner!.startEddystoneScanning()
    }
    
    func didFindBeacon(_ beaconScanner: EddystoneScanner, beaconInfo: BeaconInfo) {
        NSLog("FIND: %@", beaconInfo.description)
    }
    func didLoseBeacon(_ beaconScanner: EddystoneScanner, beaconInfo: BeaconInfo) {
        NSLog("LOST: %@", beaconInfo.description)
    }
    func didUpdateBeacon(_ beaconScanner: EddystoneScanner, beaconInfo: BeaconInfo) {
        NSLog("UPDATE: %@", beaconInfo.description)
    }
    func didObserveURLBeacon(_ beaconScanner: EddystoneScanner, URL: Foundation.URL, RSSI: Int) {
        print("URL: \(URL) RSSI: \(RSSI)")
    }
    
    @IBAction func scanSwitch(_ sender: UISwitch) {
        scanStateLabel.text = sender.isOn ? "Stop Scanning" : "Start Scanning"
        
        if sender.isOn {
            print("-- Prepares to scan for Eddystone Beacon --")
            self.eddystoneBeaconScanner.startEddystoneScanning()
            print("== Eddystone scanning is ON ==")
        }
        else {
            if self.eddystoneBeaconScanner.centralManager.isScanning {
                print("-- Prepares to stop Eddystone scan --")
                self.eddystoneBeaconScanner.centralManager.stopScan()
                print("== Eddstone scanning is OFF ==")
            }
        }
    }
    
    @IBAction func returnToMain() {
        print("Return to previous VC.")
        eddystoneBeaconScanner.stopEddystoneScanning()
        
        dismiss(animated: true, completion: nil)
    }
}


