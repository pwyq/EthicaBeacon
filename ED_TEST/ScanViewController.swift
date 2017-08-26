//
//  ScanViewController.swift
//  ED_TEST
//
//  Created by yanqing on 6/29/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import UIKit
//import CoreLocation   // this has been imported in another file

class ScanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate
{
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                          Properties
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    let locationMananger = CLLocationManager()

    let ETHICA_PREFIX_UUID: String = "4D0395FF-6470-44AC-9550-A27B3E63" // Ethica Data Beacon, without the last four hex values.
    
    var beaconFoundList: Array<CLBeacon>!
    var uuidArray = [String?](repeating: nil, count: 20)    // Maximum detectable amount of Beacon region is 20.
    var beaconIDArray = [String?](repeating: nil, count: 20)
    var proximityUUIDArray = [UUID?](repeating: nil, count: 20)
    var regionArray = [CLRegion?](repeating: nil, count: 20)
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                  UI Connection to Storyboard
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    @IBOutlet weak var tableViewLabel: UITableView!
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //             Calculation Methods for Beacon Info
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    func calcMinor(_ subjectID: Int) -> Int
    {
        return (subjectID & 0x0000FFFF)
    }
    
    func calcMajor(_ typeID: Int, _ subjectID: Int) -> Int
    {
        return (typeID << 4) | ((subjectID & 0x000F0000) >> 16)
    }
    
    func calcUUID(_ studyID: Int) -> String
    {
        let hexStudyID = padTo4(String(studyID, radix: 16))
        let studyUUID = ETHICA_PREFIX_UUID + hexStudyID.uppercased()
        return studyUUID
    }
    
    func calcStudyID(_ uuid: String) -> Int
    {
        let last4 = uuid.substring(from:uuid.index(uuid.endIndex, offsetBy: -4))
        return (Int(last4, radix:16))!
    }
    
    func calcTypeID(_ major: Int) -> Int
    {
        return (major >> 4)
    }
    
    func calcSubjectID(_ major: Int, _ minor: Int) -> Int
    {
        return (((major << 16) & 0x000FFFFF) | minor)
    }
    
    func padTo4(_ temp: String) -> String
    {
        let length = temp.characters.count
        if length == 3
        {
            return ("0" + temp)
        }
        else if length == 2
        {
            return ("00" + temp)
        }
        else if length == 1
        {
            return ("000" + temp)
        }
        return temp
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                    Validation Methods
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    // Check if inputted UUID is valid. Will return true if the UUID is valid.
    func isValidUUID(_ inputUUID: String) -> Bool
    {
        return (NSUUID.init(uuidString: inputUUID) != nil)
    }
    
    // Will return true if these two beacons' UUID, Major and Minor matched
    func isSameBeacon(_ beacon1: CLBeacon, _ beacon2: CLBeacon) -> Bool
    {
        if beacon1.proximityUUID == beacon2.proximityUUID
        {
            if (beacon1.major == beacon2.major) && (beacon1.minor == beacon2.minor)
            {
                return true
            }
        }
        return false
    }
    
    // This method should only be used when the two input Beacons are the exact same one (same UUID, Major and Minor value)
    // Will return true if the beacon is at a different distance to user's device since last scanning.
    func isBeaconMoved(_ last: CLBeacon, _ now: CLBeacon) -> Bool
    {
        if (last.rssi != now.rssi) || (last.proximity != now.proximity)
        {
            return true
        }
        return false
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                          Monitoring
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    /*
     `uuid` is iBeacon ProximityUUID, valid format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
     `index` is the position of the uuid in the local array
     `canOverwrite` is the permission to overwrite an non-empty index
     */
    func addNewRegion(_ inputUUID: String, _ index: Int, _ canOverwrite: Bool)
    {
        let uuid = inputUUID.uppercased()   // Convert string to uppercased
        
        guard 0 <= index, index <= 20 else {
            print("Error: UUID index out of array range.")
            return
        }
        
        guard self.isValidUUID(uuid) == true else {
            print("Error: Invlid UUID received.")
            return
        }
        
        if (uuidArray[index] != nil)
        {
            guard canOverwrite == true else {
                print("Error: Target index is occupied. Need permission to overwrite")
                return
            }
            print("\(inputUUID) will overwrite uuidArray[\(index)]")
        }
        
        uuidArray[index] = uuid
        proximityUUIDArray[index] = UUID(uuidString: uuidArray[index]!)
        beaconIDArray[index] = "The \(index)th beacon ID."
        regionArray[index] = CLBeaconRegion(proximityUUID: proximityUUIDArray[index]!, identifier: beaconIDArray[index]!)
    }
    
    func testMonitoring()
    {
        var count = 0
        for temp in 200..<220
        {
            let hex = padTo4(String(temp, radix: 16).uppercased())
            let uuid = ETHICA_PREFIX_UUID + hex
            addNewRegion(uuid, count, false)
            count += 1
        }
    }
    
    func initializeMonitoring()
    {
        for (index, region) in regionArray.enumerated()
        {
            if regionArray[index] != nil
            {
                self.locationMananger.startMonitoring(for: region!)
                self.locationMananger.startRangingBeacons(in: region as! CLBeaconRegion)
                print("Start monitoring in \(String(describing: region))")
            }
        }
    }
    
    func stopScanning()
    {
        for region in regionArray
        {
            if region != nil
            {
                print("Stop scanning in \(String(describing: region))")
                self.locationMananger.stopMonitoring(for: region!)
                self.locationMananger.stopRangingBeacons(in: region as! CLBeaconRegion)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion)
    {
        print("\(region) has been successfully monitored.")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion)
    {
        if beacons.count > 0
        {
            // Check if `beaconFoundList` is empty; if it's empty, add one element to it so that we can do comparing later
            if beaconFoundList.count == 0
            {
                beaconFoundList.append(beacons.first!)  // Add the first element of `beacons` to `beaconFoundList`
            }
            
            for newBeacon in beacons
            {
                var isMatched: Bool = false
                for foundBeacon in beaconFoundList
                {
                    if isSameBeacon(newBeacon, foundBeacon) == true
                    {
                        isMatched = true    // Meaning this beacon is already on the list, should exit this iteration
                        
                        if isBeaconMoved(foundBeacon, newBeacon) == true
                        {
                            if let index = beaconFoundList.index(of: foundBeacon)
                            {
                                beaconFoundList.remove(at: index)
                                beaconFoundList.append(newBeacon)
                                print("\(newBeacon) info has been updated.")
                            }
                        }
                        break
                    }
                }
                // If `isMatched` is still false after iterating, meaning the beacon is new to the list. Should add it to the list.
                if isMatched == false
                {
                    beaconFoundList.append(newBeacon)
                    print("\(newBeacon) has been add to the list.")
                }
            }
            self.tableViewLabel.reloadData()
        }
        else
        {
            print("NO BEACON FOUND")
        }
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                         Table View
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return beaconFoundList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let beaconCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let beacon = self.beaconFoundList[indexPath.row] as CLBeacon
        
        let studyID = calcStudyID(String(describing: beacon.proximityUUID))
        let typeID = calcTypeID(Int(beacon.major))
        let subjectID = calcSubjectID(Int(beacon.major), Int(beacon.minor))
        
        beaconCell.detailTextLabel?.numberOfLines = 0   // Remove the limitation of number of lines, enalbing displaying multiple lines of text.
        beaconCell.textLabel?.text = "Ethica Beacon"
        beaconCell.detailTextLabel?.text = "UUID: \n\(beacon.proximityUUID)" +
                                           "\nMajor: \(beacon.major) Minor: \(beacon.minor) RSSI: \(beacon.rssi)" +
                                           "\nStudyID: \(studyID) TypeID: \(typeID) SubjectID: \(subjectID)"
        return beaconCell
    }
    
    // Adjust the height of table cell.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                      Other System Functions
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationMananger.delegate = self
        locationMananger.requestWhenInUseAuthorization()
        
        beaconFoundList = []    // Initialized local beacon array
        
        testMonitoring()
//        addNewRegion("B9407F30-F5F8-466E-AFF9-25556B57FE6D", 0, false)
        initializeMonitoring()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func returnToPreVC() {
        super.returnToPreVC()
        stopScanning()
    }
}
