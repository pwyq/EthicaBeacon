//
//  ModifyUserDefaults.swift
//  ED_TEST
//
//  Created by yanqing on 6/26/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

class ModifyUserDefaults
{
    func clearAllUserDefaults()
    {
        print("UserDefaults Before clearing: \(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)")
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print("UserDefaults After clearing: \(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)")
    }
    
    func deleteUserDefault(_ key: String)
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        print("\(key) has been removed.")
        defaults.synchronize()
    }
    
    // Check if inputted string exists
    func isValidKeyName(_ checkingString: String) -> Bool
    {
        return UserDefaults.standard.object(forKey: checkingString) != nil  // Will return true if the string exists
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                 UserDefaults Storing
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    // Store Beacon Identifier (usually it's a hex-string) with a given name, from a textField
    func storeBeaconID(storeName: String, beaconID: String)
    {
        guard self.isValidKeyName(storeName) != true else
        {
            print("Error - BeaconID failed to store: This User default key already exists, try use another name.")
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(beaconID, forKey: storeName)
        print("\(beaconID) has been stored in UserDefaults `\(storeName)`.")
    }
    
    // Store user interger input with a given name, from a textField
    func storeUserInput(storeName: String, customTF: CustomUITextField)
    {
        guard self.isValidKeyName(storeName) != true else
        {
            print("Error - User Input failed to store: This User default key already exists, try use another name.")
            return
        }
        
        let defaults = UserDefaults.standard    // To store and receive user data
        let tempInput = Int(customTF.text!)!
        defaults.setValue(tempInput, forKey: storeName)
        print("\(String(describing: customTF.text)) has been stored in UserDefaults`\(storeName)`.")
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                 UserDefaults Getting
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    // Get Beacon Identifier with the given name
    func getBeaconID(storeName: String) -> String?
    {
        guard self.isValidKeyName(storeName) == true else
        {
            print("Error - Failed to get beaconID: Target UserDefault Key does not exists.")
            return nil
        }
        
        let defaults = UserDefaults.standard
        let savedString:String = defaults.string(forKey: storeName)!
        print("UserDefaults saved string is: \(String(describing: savedString))")
        return savedString
    }
    
    // Get user integer input with the given name
    func getStoredUserInput(storeName: String) -> Int?
    {
        guard self.isValidKeyName(storeName) == true else
        {
            print("Error - Failed to get Stored Value: Target UserDefault Key does not exists.")
            return nil
        }
        
        let defaults = UserDefaults.standard
        let savedValue = defaults.integer(forKey: storeName)
        print("UserDefaults saved value is: \(savedValue)")
        return savedValue
    }
}
