//
//  allInOneViewController.swift
//  ED_TEST
//
//  Created by yanqing on 6/8/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import UIKit
import CoreLocation // iBeacon-tech is part of the CoreLocation framework


let iBeaconUUID = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
let iBeaconRegion = CLBeaconRegion(proximityUUID: iBeaconUUID!, identifier: "Test beacon region")


class allInOneViewController: UIViewController, CLLocationManagerDelegate, EddystoneScannerDelegate {
    
    @IBOutlet weak var detectStateLabel: UITextField!
    @IBOutlet weak var detectSwitchLabel: UISwitch!
    
    var locationManager = CLLocationManager()
    var eddystoneScanner : EddystoneScanner!
    
    //++++++++++++++++++++++++++++++++
    //         Find iBeacons
    //++++++++++++++++++++++++++++++++
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion)
    {
        if beacons.count > 0 {
            print(beacons)
            for i in 0..<beacons.count
            {
                print("Beacon's identifier: \(beacons[i])")
            }
        } else {
            print("No iBeacon has been found.")
        }
    }
    
    func startLocationScanning() {
        locationManager.startMonitoring(for: iBeaconRegion)
        locationManager.startRangingBeacons(in: iBeaconRegion)
    }
    
    func stopLocationScanning() {
        print("-- Prepares to stop iBeacon scanning. --")
        locationManager.stopMonitoring(for: iBeaconRegion)
        locationManager.stopRangingBeacons(in: iBeaconRegion)
        print("== iBeacon scanning ended. ==")
    }
    
    //++++++++++++++++++++++++++++++++
    //      Find Eddystone Beacons
    //++++++++++++++++++++++++++++++++
    
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
    
    @IBAction func detectSwitch(_ sender: UISwitch) {
        detectStateLabel.text = sender.isOn ? "Detecting" : "Switch ON to detect"
        
        if sender.isOn {
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
                if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                    if CLLocationManager.isRangingAvailable() {
                        startLocationScanning()
                    }
                }
            }
            else {
                locationManager.requestAlwaysAuthorization()
            }
            
            self.eddystoneScanner.startEddystoneScanning()
            
        }
        else {
            stopLocationScanning()
            self.eddystoneScanner.stopEddystoneScanning()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Enter all in one View Controller.")

        locationManager.delegate = self
        
        self.eddystoneScanner = EddystoneScanner()
        self.eddystoneScanner!.delegate = self
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground),
                                       name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appMovedToBackground() {
        print("\n\t *** App moved to background. ***")
    }
    
    
    @IBAction func returnToMain() {
        print("Return to previous VC.")
        if detectSwitchLabel.isOn {
            eddystoneScanner.stopEddystoneScanning()
            stopLocationScanning()
        }
        dismiss(animated: true, completion: nil)
    }
}
