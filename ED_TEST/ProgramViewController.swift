//
//  ProgramViewController.swift
//  ED_TEST
//
//  Created by yanqing on 6/29/17.
//  Copyright © 2017 EthicaData. All rights reserved.
//

import UIKit

class ProgramViewController: UIViewController, UITextFieldDelegate
{
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                  UI Connection to Storyboard
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    @IBOutlet weak var beaconCompanyDisplayLabel: UITextField!
    @IBOutlet weak var logBoxLabel: UITextView!
    @IBOutlet weak var beaconCompanyPickerLabel: UIPickerView!
    
    @IBOutlet weak var beaconIDLabel: UITextField!
    @IBOutlet weak var beaconIDInputLabel: CustomUITextField!
    
    @IBOutlet weak var studyIDLabel: UITextField!
    @IBOutlet weak var studyIDInputLabel: CustomUITextField!
    
    @IBOutlet weak var participantIDLabel: UITextField!
    @IBOutlet weak var participantIDInputLabel: CustomUITextField!
    
    @IBOutlet weak var programButtonLabel: UIButton!
    
    @IBOutlet weak var tableViewLabel: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Button
    @IBAction func programButton(_ sender: Any) {
        print("Program Button tapped.")
        
        guard let studyID = studyIDInputLabel.text, isValidStudyID(studyID) else {
            self.logMessage("Error: Invalid study ID.")
            return
        }
        guard let participantID = participantIDInputLabel.text, isValidParticipantID(participantID) else {
            self.logMessage("Error: Invalid participant ID.")
            return
        }
        
        if beaconCompanyDisplayLabel.text == "Kontakt.io"
        {
            kontaktDevice.modifyBeaconSettings()
        }
//        else if beaconCompanyDisplayLabel.text == "Estimote Nearable"
//        {
//            
//        }
        else if beaconCompanyDisplayLabel.text == "Estimote Location Beacon"
        {
            // TODO
        }
        else if beaconCompanyDisplayLabel.text == "Default Testing"
        {
            print("test")
        }
        else
        {
            print("Error occurred at programButton()")
        }
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                          Properties
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    let dateFormatter = DateFormatter()

    let beaconCompanies = ["Default Testing", "Estimote Location Beacon", "Estimote Nearable", "Kontakt.io"]
    
    // Create instance of beacon class(es)
    let estimoteNearable = EstimoteNearable()
    let kontaktDevice = KontaktDevice()
    let kontaktBeacon = KontaktBeacon()
    
    let testList = ["Test Beacon #1", "Test Beacon #2", "Test Beacon #3", "Test Beacon #4", "Test Beacon #5", "Test Beacon #6", "Test Beacon #7", "Test Beacon #8", "Test Beacon #9"]
    
    let locationBeaconList = ["Location Beacon #1", "Location Beacon #2", "Location Beacon #3"]
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                          UI
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    // When user tap on the target textField
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.beaconCompanyDisplayLabel
        {
            self.tableViewLabel.isHidden = true
            self.beaconCompanyPickerLabel.isHidden = false
            textField.endEditing(true)
        }
    }
    
    func initializeLabelSettings()
    {
        addDoneButton(textField: studyIDInputLabel)
        addDoneButton(textField: participantIDInputLabel)
        addDoneButton(textField: beaconIDInputLabel)
        
        // Move the view of TextField to a proper position while user typing.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Set the full width of separator in UITableView
        self.tableViewLabel.separatorInset = .zero
        self.tableViewLabel.layoutMargins = .zero
        
        self.beaconCompanyPickerLabel.layer.zPosition = 1   // bring the view to the most front
        tableViewLabel.tableFooterView = UIView()   // remove empty cells
    }
    
    func initializeLogBoxUI()
    {
        let logBorderWidth = CGFloat(2.0)
        let logBorderColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1).cgColor
        logBoxLabel.drawBorder(width: logBorderWidth, color: logBorderColor)
        logBoxLabel.backgroundColor = UIColor(red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 1)
    }
    
    func initializeLabelUI()
    {
        beaconCompanyDisplayLabel.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1)
        beaconCompanyDisplayLabel.textColor = UIColor.white
        
        beaconCompanyPickerLabel.backgroundColor = UIColor(red: 153.0/255, green: 255.0/255, blue: 185.0/255, alpha: 1)
        
        beaconIDLabel.backgroundColor = UIColor(red: 26.0/255, green: 140.0/255, blue: 255.0/255, alpha: 1)
        beaconIDLabel.textColor = UIColor.white
        
        studyIDLabel.backgroundColor = UIColor(red: 102.0/255, green: 179.0/255, blue: 255.0/255, alpha: 1)
        studyIDLabel.textColor = UIColor.white
        
        participantIDLabel.backgroundColor = UIColor(red: 102.0/255, green: 179.0/255, blue: 255.0/255, alpha: 1)
        participantIDLabel.textColor = UIColor.white
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                          Logging Box
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    func logBoxClear()
    {
        print("Double Tapped Detected.")
        logBoxLabel.text = ""
    }
    
    func initializeLogging()
    {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        
        let logBoxTap = UITapGestureRecognizer(target: self, action: #selector(logBoxClear))
        logBoxTap.numberOfTapsRequired = 2
        logBoxLabel.addGestureRecognizer(logBoxTap)
    }
    
    func logMessage(_ message: String)
    {
        logBoxLabel.text = logBoxLabel.text + dateFormatter.string(from: Date()) + ": " + message + "\n"
        let textLength = logBoxLabel.text.lengthOfBytes(using: .utf8)
        let bottom = NSMakeRange(textLength - 1, 1) // loc, len
        logBoxLabel.scrollRangeToVisible(bottom)
        print(message)
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                      Other Methods
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    func enableProgramming(bool: Bool)
    {
        if bool == true
        {
            programButtonLabel.isEnabled = true
            beaconIDInputLabel.isEnabled = true
            studyIDInputLabel.isEnabled = true
            participantIDInputLabel.isEnabled = true
            print("program enabled.")
        }
        else
        {
            programButtonLabel.isEnabled = false
            beaconIDInputLabel.isEnabled = false
            studyIDInputLabel.isEnabled = false
            participantIDInputLabel.isEnabled = false
            print("program disabled.")
        }
    }
    
    func isValidStudyID(_ studyID: String) -> Bool
    {
        guard studyID.isInt == true else {
            return false
        }
        let tempInput = Int(studyID)!
        if (tempInput < 1) || (tempInput > 65535)
        {
            return false
        }
        
        return true
    }
    
    func isValidParticipantID(_ participantID: String) -> Bool
    {
        guard participantID.isInt == true else {
            return false
        }
        let tempInput = Int(participantID)!
        if (tempInput < 1) || (tempInput > 65535)
        {
            return false
        }
        
        return true
    }
    
    override func doneClicked()
    {
        super.doneClicked()
        if studyIDInputLabel.text != ""
        {
            print("User has entered study ID.")
            ModifyUserDefaults().deleteUserDefault("Study ID")
            ModifyUserDefaults().storeUserInput(storeName: "Study ID", customTF: studyIDInputLabel)
        }
        
        if participantIDInputLabel.text != ""
        {
            print("User has entered participant ID.")
            ModifyUserDefaults().deleteUserDefault("Participant ID")
            ModifyUserDefaults().storeUserInput(storeName: "Participant ID", customTF: participantIDInputLabel)
        }
        
        if beaconIDInputLabel.text != ""
        {
            print("User has entered beacon ID.")
            ModifyUserDefaults().deleteUserDefault("Beacon ID")
            ModifyUserDefaults().storeBeaconID(storeName: "Beacon ID", beaconID: beaconIDInputLabel.text!)
        }
    }
    
    override func returnToPreVC()
    {
        super.returnToPreVC()
        ModifyUserDefaults().clearAllUserDefaults()
        updateBeaconScanning()
    }
    
    func imageForNearableType(_ type: ESTNearableType) -> UIImage?
    {
        switch (type)
        {
            case ESTNearableType.bag:
                return  UIImage(named: "sticker_bag")
            case ESTNearableType.bike:
                return UIImage(named: "sticker_bike")
            case ESTNearableType.car:
                return UIImage(named: "sticker_car")
            case ESTNearableType.fridge:
                return UIImage(named: "sticker_fridge")
            case ESTNearableType.bed:
                return UIImage(named: "sticker_bed")
            case ESTNearableType.chair:
                return UIImage(named: "sticker_chair")
            case ESTNearableType.shoe:
                return UIImage(named: "sticker_shoe")
            case ESTNearableType.door:
                return UIImage(named: "sticker_door")
            case ESTNearableType.dog:
                return UIImage(named: "sticker_dog")
            default:
                return UIImage(named: "sticker_grey")
        }
    }
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //                      Other System Functions
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Enter Program View Controller.")
        initializeLabelSettings()
        initializeLogging()
        initializeLogBoxUI()
        initializeLabelUI()
        
        // THIS IS FOR DEBUGGING, can replace with a "SEARCHING..." gif later
        tableViewLabel.backgroundColor = UIColor.cyan
        
        // reference beacon class(es) to this ViewController
        estimoteNearable.viewController = self
        kontaktDevice.viewController = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
