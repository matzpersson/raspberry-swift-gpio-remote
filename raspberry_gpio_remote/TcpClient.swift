//
//  TcpClient.swift
//  raspberry_gpio_remote
//
//  Created by Matz Persson on 16/09/2016.
//  Copyright © 2016 Headstation. All rights reserved.
//

import UIKit

class TcpClient: NSObject  {
    
    var inStream : NSInputStream?
    var outStream: NSOutputStream?
    
    func start(parent: NSStreamDelegate, address: String, port: Int) {
    
        NSStream.getStreamsToHostWithName(address, port: port, inputStream: &inStream, outputStream: &outStream)
        
        inStream?.delegate = parent
        outStream?.delegate = parent
        
        inStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inStream?.open()
        outStream?.open()
        
    }
    
    func writeMessage(message: String) {

        var data : NSData = message.dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        
    }
    
    func initInputs() {
        
        var data : NSData = "inputs".dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    
    }
    
    func initOutputs() {
        
        var data : NSData = "outputs".dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        
    }
    
    func close() {
        
        inStream?.close()
        inStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        outStream?.close()
        outStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)

    }
}

