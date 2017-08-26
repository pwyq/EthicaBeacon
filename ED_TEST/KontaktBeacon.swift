//
//  KontaktBeacon.swift
//  ED_TEST
//
//  Created by yanqing on 7/6/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

class KontaktBeacon: KTKBeaconManager, KTKBeaconManagerDelegate
{
    var kontaktList: Array<CLBeacon>!
    var kontaktBeaconManager: KTKBeaconManager!
    var isKTKBeaconConnected: Bool!
    
    var viewController: ProgramViewController!    // Used to reference to ProgramBeaconViewController
    
    func initializeKontaktDetecting()
    {
        kontaktBeaconManager = KTKBeaconManager(delegate: self)
        kontaktList = []
        let kontaktUUID = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")  // Kontakt default UUID
        let kontaktRegion = KTKBeaconRegion(proximityUUID: kontaktUUID!, identifier: "Kontakt Beacon Pro Region")

        kontaktBeaconManager.startRangingBeacons(in: kontaktRegion)
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didRangeBeacons beacons: [CLBeacon], in region: KTKBeaconRegion) {
        self.kontaktList = beacons as Array<CLBeacon>
        self.viewController.tableViewLabel.reloadData()

        for beacon in beacons {
            print("--------------------------------")
            print("Ranged beacon with Proximity UUID: \(beacon.proximityUUID), Major: \(beacon.major) and Minor: \(beacon.minor) from \(region.identifier) in \(beacon.proximity) proximity")
            print("--------------------------------")
        }
    }
}
