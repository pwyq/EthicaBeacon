//  iBeaconScanViewController.swift
//  ED_TEST
//
//  Created by yanqing on 6/8/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import UIKit
import CoreLocation // iBeacon-tech is part of the CoreLocation framework

// Defines a region using specific uuid
// EstimoteBeacon(beetRoot) proximityUUID: B9407F30-F5F8-466E-AFF9-25556B57FE6D; Major: 53474; Minor: .....
// EstimoteBeacon(lemon   ) proximityUUID: B9407F30-F5F8-466E-AFF9-25556B57FE6D; Major: 32074; Minor: 43997
// EstimoteBeacon(candy   ) proximityUUID: B9407F30-F5F8-466E-AFF9-25556B57FE6D; Major: 34713; Minor: 12437
// amin's iPhone5           proximityUUID: 8492E75F-4FD6-469D-B132-043FE94921D8; Major: 2394;  Minor: 20493
// yanqing's iPhone6        proximityUUID: 8492E75F-4FD6-469D-B132-043FE94921D8; Major: 2394;  Minor: 3289

// Specific UUID(s) need to be pre-implemented to be scanned
let estimoteUUID = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
//    let iPhoneUUID = UUID(uuidString: "8492E75F-4FD6-469D-B132-043FE94921D8")
//    let testUUID = UUID(uuidString: "0A0AC4F4-5C5C-4A6B-9BDF-C55BBEA42973")

let region1 = CLBeaconRegion(proximityUUID: estimoteUUID!, identifier: "Estimote beacon")
//    let region2 = CLBeaconRegion(proximityUUID: iPhoneUUID!, identifier: "virtual beacon on iPhone")
//    let region3 = CLBeaconRegion(proximityUUID: testUUID!, identifier: "TESTING")

class iBeaconScanViewController: UIViewController, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var detectStateLabel: UITextField!
    @IBOutlet weak var detectSwitchLabel: UISwitch!
    
    var locationManager = CLLocationManager()  // Create an instance of a CL Manager to use CL
    
    let minorColors = [
        1234: UIColor(red: 142/255, green: 38/255, blue: 141/255, alpha: 1),
        43997: UIColor(red: 239/255, green: 234/255, blue: 74/255, alpha: 1),
        12437: UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1),
        11111: UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1)
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Enter iBeacon Scan View Controller")
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground),
                                       name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    func appMovedToBackground() {
        print("App moved to background!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion)
    {
        print(beacons)
        
        if beacons.count > 0 {
            let closetBeacon = beacons[0] as CLBeacon
            updateDistance(closetBeacon.proximity)
            
//            let testBeacons = beacons as [CLBeacon]
//            for beacon in testBeacons {
//                print("\nBeacon Found: Major: \(beacon.major); Minor: \(beacon.minor).")
//            }
        } else {
            updateDistance(.unknown)
            print("No iBeacon has been found.")
        }
    }
    
    func startScanning() {
        locationManager.startMonitoring(for: region1)
        locationManager.startRangingBeacons(in: region1)
    }
    
    func stopScanning() {
        locationManager.stopMonitoring(for: region1)
        locationManager.stopRangingBeacons(in: region1)
        self.view.backgroundColor = UIColor.white
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
            }
        }
    }
    @IBAction func detectSwitch(_ sender: UISwitch) {
        detectStateLabel.text = sender.isOn ? "Detecting" : "Switch ON to detect"
        
        if sender.isOn {
            locationManager.delegate = self
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
                if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                    if CLLocationManager.isRangingAvailable() {
                        startScanning()
                    }
                }
            }
            else {
                locationManager.requestAlwaysAuthorization()
            }
        }
        else {
            stopScanning()
        }
    }
    
    @IBAction func returnToMain() {
        print("Return to previous VC.")
        
        if detectSwitchLabel.isOn {
            stopScanning()
        }
        
        dismiss(animated: true, completion: nil)
    }
}
