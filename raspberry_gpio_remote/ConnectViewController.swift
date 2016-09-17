//
//  ConnectViewController.swift
//  swift_udp_client
//
//  Created by Matz Persson on 14/09/2016.
//  Copyright © 2016 Headstation. All rights reserved.
//
//  This project works hand in hand with server side Raspberry GPIO Simulator. Check it on https://github.com/matzpersson/raspberry-gpio-simulator.git

import UIKit

class ConnectViewController: UIViewController {

    @IBOutlet weak var broadcastAddress: UITextField!
    @IBOutlet weak var broadcastPort: UITextField!
    @IBOutlet weak var tcpAddress: UITextField!
    @IBOutlet weak var tcpPort: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        
        broadcastAddress.text = defaults.stringForKey("broadcastAddress")
        broadcastPort.text = defaults.stringForKey("broadcastPort")
        tcpAddress.text = defaults.stringForKey("tcpAddress")
        tcpPort.text = defaults.stringForKey("tcpPort")
        
    }
    

    @IBAction func connectButton(sender: UIButton) {
        
        if broadcastAddress.text! == "" || broadcastPort.text! == ""  || tcpAddress.text! == "" || tcpPort.text! == "" {

            let alert = UIAlertController(title: "Oops", message: "Need both IP Address and Port for both UDP and TCP services...", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "No worries, got it", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        } else {

            defaults.setObject(broadcastAddress.text!, forKey: "broadcastAddress")
            defaults.setObject(broadcastPort.text!, forKey: "broadcastPort")
            defaults.setObject(tcpAddress.text!, forKey: "tcpAddress")
            defaults.setObject(tcpPort.text!, forKey: "tcpPort")

            self.performSegueWithIdentifier("connectedSegue", sender: self)
        
        }
        
    }

}

