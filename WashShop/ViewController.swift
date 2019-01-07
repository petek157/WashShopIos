//
//  ViewController.swift
//  WashShop
//
//  Created by Peter Koruga on 1/5/19.
//  Copyright © 2019 Peter Koruga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var washDoorButton: UIButton!
    @IBOutlet weak var mechDoorButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceIdLabel: UILabel!
    
    var shopDevice: ParticleDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if ParticleCloud.sharedInstance().isAuthenticated {
            loginButton.isUserInteractionEnabled = false
            logoutButton.isUserInteractionEnabled = true
            washDoorButton.isUserInteractionEnabled = true
            mechDoorButton.isUserInteractionEnabled = true
        } else {
            loginButton.isUserInteractionEnabled = true
            logoutButton.isUserInteractionEnabled = false
            washDoorButton.isUserInteractionEnabled = false
            mechDoorButton.isUserInteractionEnabled = false
        }

    }

    func getWashShop() {
        ParticleCloud.sharedInstance().getDevices { (devices:[ParticleDevice]?, error:Error?) -> Void in
            if let _ = error {
                print("Check your internet connectivity")
            }
            else {
                if let d = devices {
                    for device in d {
                        if device.name == "garage_doors" {
                            self.shopDevice = device
                            
                            if let name = self.shopDevice?.name {
                                self.deviceNameLabel.text = name
                            }
                            
                            if let id = self.shopDevice?.id {
                                self.deviceIdLabel.text = id
                            }
                            
                            self.washDoorButton.isUserInteractionEnabled = true
                            self.mechDoorButton.isUserInteractionEnabled = true
                            break
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func washDoorButtonPressed(_ sender: Any) {
        
        //let funcArgs = ["D7",1]
        var task = shopDevice!.callFunction("tleftdoor", withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Wash Door Toggled")
            } else {
                print("Wash Door Error: \(error)")
            }
        }
        var bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
        // ..do something with bytesToReceive
        
    }
    
    @IBAction func mechDoorButtonPressed(_ sender: Any) {
        
        var task = shopDevice!.callFunction("trightdoor", withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Mech Door Toggled")
            } else {
                print("Mech Door Error: \(error)")
            }
        }
        var bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
        // ..do something with bytesToReceive
    
    }
    
    func loginUser() {
        ParticleCloud.sharedInstance().login(withUser: "petek157@hotmail.com", password: "PK79CNKB") { (error) in
            if let e = error {
                print("Particle Error: \(e)")
            } else {
                print("Logged In")
                
                self.getWashShop()
                
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        loginUser()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        ParticleCloud.sharedInstance().logout()
        print("Logged Out")
        washDoorButton.isUserInteractionEnabled = false
        mechDoorButton.isUserInteractionEnabled = false
    }
}

