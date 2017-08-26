
//
//  EstimoteViewController.swift
//  ED_TEST
//
//  Created by yanqing on 6/9/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import Foundation
import UIKit

let testUUID = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
let testRegion = CLBeaconRegion(proximityUUID: testUUID!, identifier: "Test estimote beacon region")

//Estimote Connectivity packet


class EstimoteViewController: UIViewController, ESTBeaconManagerDelegate, UITextFieldDelegate, ESTDeviceManagerDelegate, ESTDeviceConnectableDelegate{
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                      Attributes
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    @IBOutlet weak var majorInputLabel: CustomUITextField!
    @IBOutlet weak var minorInputLabel: CustomUITextField!
    
    @IBOutlet weak var testLabel: UITextField!
    @IBOutlet weak var submitButtonLabel: UIButton!
    @IBOutlet weak var scanButtonLabel: UIButton!
    
    let estimoteBeaconManager = ESTBeaconManager()  // add a property to hold the beacon manager and instantiate it

    var deviceManager: ESTDeviceManager!
    var device: ESTDeviceLocationBeacon!
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                      UI Buttons
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    @IBAction func submitButton(_ sender: UIButton) {
        // when button being clicked
        if sender.isEnabled {
            scanButtonLabel.isEnabled = true
            print("Scan button is enabled")
            
            storeUserInput(storeName: "Minor value", customTF: minorInputLabel)
            storeUserInput(storeName: "Major value", customTF: majorInputLabel)
            
            beaconSettingModify()
        }
    }    
    
    @IBAction func startScanning(_ sender: UIButton) {
        getBeaconInfo() // Get current beacon info
        startEstimoteScanning()
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                      ESTDevice
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    func deviceManager(_ manager: ESTDeviceManager, didDiscover devices: [ESTDevice]) {
        guard let device = devices.first as? ESTDeviceLocationBeacon else {
            return
        }
        self.deviceManager.stopDeviceDiscovery()
        self.device = device
        self.device.delegate = self
        self.device.connect()
    }
    
    var connectionStatus: ESTConnectionStatus!
    func estDeviceConnectionDidSucceed(_ device: ESTDeviceConnectable) {
        print("Beacon Connected Successfully.")
        print("connection status is: \(connectionStatus)")
        // After beacon is connected successfully, enable submit-button
        submitButtonLabel.isEnabled = true
        print("Submit Button is enabled.")
    }
    
    func estDevice(_ device: ESTDeviceConnectable, didDisconnectWithError error: Error?) {
        print("Disconnected with error: \(String(describing: error))")
    }
    
    func estDevice(_ device: ESTDeviceConnectable, didFailConnectionWithError error: Error) {
        print("Connection failed with error: \(error)")
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                      Modify/Get/Scan Beacon (Info)
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    func beaconSettingModify() {
        
        let savedMajor = getStoredUserInput(storeName: "Major value")
        let savedMinor = getStoredUserInput(storeName: "Minor value")
        
        device.settings?.iBeacon.enable.writeValue(true, completion: { (estSettingIBeaconEnable, error) in
            guard error == nil else {
                print("we had an error: \(error!)")
                return
            }
            print("write Value enabled")
            
        })
        device.settings?.iBeacon.major.writeValue(UInt16(savedMajor), completion: { (estSettingIBeaconMajor, error) in
            guard error == nil else {
                print("we had an error: \(error!)")
                return
            }
            print("Major value has been set to \(savedMajor)!")
        })
        device.settings?.iBeacon.minor.writeValue(UInt16(savedMinor), completion: { (estSettingIBeaconMinor, error) in
            guard error == nil else {
                print("we had an error: \(error!)")
                return
            }
            print("Minor value has been set to \(savedMinor)!")
        })
        
    }
    
    func getBeaconInfo() {
        print("\n\t---- Current Beacon Info ----")
        print("Major value is: \(String(describing: device.settings?.iBeacon.major.getValue()))")   // major is a get-only property
        print("Minor value is: \(String(describing: device.settings?.iBeacon.minor.getValue()))")
        print("status is \(device.connectionStatus.rawValue)")
        print("Connectivity interval is: \(String(describing: device.settings?.connectivity.interval.getValue()))")
        print("device description is: \(device.description)")
        print("device info is:\(String(describing: device.settings?.deviceInfo))")
        print("")
        print("device color is:\(String(describing: device.settings?.deviceInfo.color.getValue()))")
        device.settings?.deviceInfo.developmentMode.readValue(completion: { (estSettingDeviceInfoDevelopmentMode, error) in
            guard error == nil else {
                print("we had an error: \(String(describing: error))")
                return
            }
            print("ahahahaahahahahahahah")
        })
        print("device indoorLocationID identifier is: \(String(describing: device.settings?.deviceInfo.indoorLocationIdentifier.getValue()))")
        print("device indoorLocationName is: \(String(describing: device.settings?.deviceInfo.indoorLocationName.getValue()))")
        print("device name: \(String(describing: device.settings?.deviceInfo.name.getValue()))")
        print("device tag: \(String(describing: device.settings?.deviceInfo.tags.getValue()))")
        print("\t---- Beacon Info End ----\n")
    }
    
    func startEstimoteScanning() {
        self.estimoteBeaconManager.delegate = self  // set the beacon manager's delegate
        self.estimoteBeaconManager.requestWhenInUseAuthorization()
        self.estimoteBeaconManager.startRangingBeacons(in: testRegion)  // ranging only works on foreground
    }
    
    func stopEstimoteScanning() {
        self.estimoteBeaconManager.stopRangingBeacons(in: testRegion)
        print("Estimote Location Beacon Ranging Stopped.")
        clearUserDefaults()
    }

    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                      beaconManager
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    // Tells the delegate that one or more beacons are in range.
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let savedMajor = getStoredUserInput(storeName: "Major value") as NSNumber
        
        for i in 0..<beacons.count {
            // Filtering for target beacons with specific Major and/or Minor value
            if beacons[i].major == savedMajor {
                print(beacons[i])
            }
        }
    }
    
    /*  The beacon manager calls this method when it encounters an error trying to get the beacons data.
        If the user denies your application’s use of the location service, this method reports a kCLErrorDenied error. 
        Upon receiving such an error, you should stop the location service.
    */
    func beaconManager(_ manager: Any, didFailWithError error: Error) {
        print("Beacon data accessing failed with error: \(error)")
    }
    
    // Tells the delegate that a region ranging error occurred.
    func beaconManager(_ manager: Any, rangingBeaconsDidFailFor region: CLBeaconRegion?, withError error: Error) {
        print("Beacon region ranging error occurred with error: \(error); in region: \(String(describing: region))")
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                      Other Functions
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    override func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            if self.view.frame.origin.y == 0
            {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            if self.view.frame.origin.y != 0
            {
                self.view.frame.origin.y += keyboardSize.height/2
            }
        }
    }
    
    override func viewDidLoad() {
        print("Enter Estimote View Controller.")
        super.viewDidLoad()
        
        majorInputLabel.delegate = self as UITextFieldDelegate
        minorInputLabel.delegate = self as UITextFieldDelegate
        
        // Set a bottom line on user-input box
        majorInputLabel.setBottomBorder()
        minorInputLabel.setBottomBorder()
        
        // Add a done Button when user finishing input
        addDoneButton(textField: majorInputLabel)
        addDoneButton(textField: minorInputLabel)
        
        // Move the view of TextField to a proper position while user typing.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.deviceManager = ESTDeviceManager()
        self.deviceManager.delegate = self
        
        let deviceIdentifier = "ad6246a8ef6482136ff28f8681435725"
        let deviceFilter = ESTDeviceFilterLocationBeacon(identifier: deviceIdentifier)
        self.deviceManager.startDeviceDiscovery(with: deviceFilter)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var startString = ""
        if (textField.text != nil) {
            startString += textField.text!
        }
        startString += string
        let userInputInt = Int(startString)
        if (userInputInt! > 65535) || (userInputInt! < 0) {
            return false
        }
        else {
            return true
        }
    }
    
    override func returnToPreVC() {
        super.returnToPreVC()
        stopEstimoteScanning()
    }
}
