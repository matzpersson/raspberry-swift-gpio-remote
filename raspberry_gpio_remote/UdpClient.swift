//
//  UdpSocket.swift
//  raspberry_gpio_remote
//
//  Created by Matz Persson on 16/09/2016.
//  Copyright © 2016 Headstation. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class UdpClient {
    
    func start(parent: GCDAsyncUdpSocketDelegate, address: String, port: UInt16) -> GCDAsyncUdpSocket{
        
        let socket = GCDAsyncUdpSocket(delegate: parent, delegateQueue: dispatch_get_main_queue())
        
        // -- Enable IP4 only
        socket.setIPv6Enabled(false)
        socket.setIPv4Enabled(true)
 
        do {
            
            try socket.bindToPort(port)
            try socket.enableBroadcast(true)
            try socket.beginReceiving()
            

            
        } catch _ as NSError {
            
            print("Issue with setting up listener")
            
        }
        
        return socket
        
    }
}
