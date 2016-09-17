//
//  GpioTableViewController
//  swift_udp_client
//
//  Created by Matz Persson on 14/09/2015.
//  Copyright © 2016 Headstation. All rights reserved.
//

//  This project works hand in hand with server side Raspberry GPIO Simulator. Check it on https://github.com/matzpersson/raspberry-gpio-simulator.git

import UIKit
import CocoaAsyncSocket

class GpioTableViewController: UITableViewController, GCDAsyncUdpSocketDelegate, NSStreamDelegate {

    let defaults = NSUserDefaults.standardUserDefaults()
    
    var udpsocket : GCDAsyncUdpSocket?
    var broadcastPort: UInt16 = 54545
    var broadcastAddress: String = ""
    var tcpPort: Int = 9877
    var tcpAddress: String = ""
  
    var inputs: [[String: AnyObject]] = []
    var outputs: [[String: AnyObject]] = []
    
    // -- Data received in buffer
    var buffer = [UInt8](count: 2000, repeatedValue: 0)
    
    let tcpclient = TcpClient()
    let udpclient = UdpClient()
    
    var logCount = 1
    var log: [[String]] = []
    
    @IBOutlet weak var progressActivity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // -- Set Udp client
        broadcastAddress = defaults.stringForKey("broadcastAddress")!
        broadcastPort = UInt16( defaults.integerForKey("broadcastPort") )
        udpsocket = udpclient.start(self, address: broadcastAddress, port: broadcastPort)
        
        // -- Set Tcp client
        tcpAddress = defaults.stringForKey("tcpAddress")!
        tcpPort = Int( defaults.integerForKey("tcpPort") )
        tcpclient.start(self, address: tcpAddress, port: tcpPort)
        tcpclient.initInputs()
        
        progressActivity.hidesWhenStopped = true
        progressActivity.startAnimating()
        
    }

    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            tcpclient.close()
            udpsocket?.close()
        }
    }
    
    func decodeMessage(message: NSDictionary) {
    
        let cmd = message["cmd"] as! String
        
        switch cmd {
            case "outputs":
            
                outputs = message["data"] as! [[String: AnyObject]]
                self.tableView.reloadData()
            
                progressActivity.stopAnimating()
            
            case "inputs":
            
                inputs = message["data"] as! [[String: AnyObject]]
                self.tableView.reloadData()
            
                tcpclient.initOutputs()
            
            
            case "gpio":
                
                var gpio = message["data"] as! [String: AnyObject]

                // If its an input
                if ( gpio["input"] as! Int == 1 ) {
                    
                    for var idx = 0; idx < inputs.count; idx++ {

                        if ( inputs[idx]["tag"] as! String == gpio["tag"] as! String ) {
                            inputs[idx]["value"] = gpio["value"]
                            inputs[idx]["datetime"] = gpio["datetime"]

                            let indexPath = NSIndexPath(forRow: idx, inSection: 0)
                            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                        }
                    }
                    
                } else {
                    
                    for var idx = 0; idx < outputs.count; idx++ {
                        
                        if ( outputs[idx]["tag"] as! String == gpio["tag"] as! String ) {
                            outputs[idx]["value"] = gpio["value"]
                            outputs[idx]["datetime"] = gpio["datetime"]
                            
                            let indexPath = NSIndexPath(forRow: idx, inSection: 1)
                            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                        }
                    }
                }

            
            default: break
        }
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
        switch eventCode {
        case NSStreamEvent.EndEncountered:
            print("Connection stopped by server")
            tcpclient.close()
            udpsocket?.close()
            navigationController?.popViewControllerAnimated(true)

        case NSStreamEvent.ErrorOccurred:
            print("Connection Failed to server")
            tcpclient.close()
            udpsocket?.close()
            navigationController?.popViewControllerAnimated(true)
            
        case NSStreamEvent.HasBytesAvailable:
            
            print("Incoming")
            if aStream == tcpclient.inStream {
                
                let bytesRead = tcpclient.inStream!.read(&buffer, maxLength: buffer.count)
                if (bytesRead > 0) {
 
                    let message = NSString(bytes: &buffer, length: bytesRead, encoding: NSUTF8StringEncoding)  as! String
                    decodeMessage(message.parseJSONString as! NSDictionary)
                    
                }

                
            }
        
        case NSStreamEvent.HasSpaceAvailable:
            print("HasSpaceAvailable")

            
        case NSStreamEvent.None:
            break
            
        case NSStreamEvent.OpenCompleted:
            print("Connected to server")

            
        default:
            break
        }
        
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
        
        var host: NSString?
        var port1: UInt16 = 0
        GCDAsyncUdpSocket.getHost(&host, port: &port1, fromAddress: address)
        
        let message = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        
        decodeMessage( message.parseJSONString as! NSDictionary)
        
    }
    

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return inputs.count
        } else {
            return outputs.count
        }
        
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section == 0) {
            return "Raspberry Inputs"
        } else {
            return "Raspberry Outputs"
        }

    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("inputCell", forIndexPath: indexPath) as! InputTableViewCell

            let idx = indexPath.row
            let input = inputs[idx]
        
            let tag = input["tag"] as! String
            let pin = input["pin"] as! Int
            cell.nameLabel.text = input["name"] as! String
            cell.tagLabel.text = tag + " (Pin " + String(pin) + ")"
            cell.timeLabel.text = input["datetime"] as! String
            
            if input["value"] as! Int == 0 {
                cell.ledImage.backgroundColor = UIColor.redColor()
            } else {
                cell.ledImage.backgroundColor = UIColor.greenColor()
            }
            
            return cell
        
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("outputCell", forIndexPath: indexPath) as! OutputTableViewCell
            let idx = indexPath.row
            let output = outputs[idx]

            let tag = output["tag"] as! String
            let pin = output["pin"] as! Int
            cell.nameLabel.text = output["name"] as! String
            cell.tagLabel.text = tag + " (Pin " + String(pin) + ")"
            
            // -- Set switch
            cell.onSwitch.addTarget(self, action: #selector(switchPress), forControlEvents: .TouchUpInside)
            cell.onSwitch.tag = output["pin"] as! Int
            cell.onSwitch.on = output["value"] as! Bool
            
            cell.ledImage.backgroundColor = UIColor.greenColor()
            UIView.animateWithDuration(1, animations: { () -> Void in
                cell.ledImage.backgroundColor = UIColor.lightGrayColor()
            })
            
            return cell
        }

        
    }
    
    func switchPress(sender: AnyObject) {

        let message = "wo:" + String(sender.tag) + ":" + String(Int(sender.on))
        tcpclient.writeMessage(message)
    }
}
