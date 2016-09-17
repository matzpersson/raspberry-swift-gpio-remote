# Swift Raspberry GPIO Remote
Control your Raspberry from a Swift application using UDP and TCP Sockets. Works together with python scripts on https://github.com/matzpersson/raspberry-gpio-sockets.git

![Alt text](http://headstation.com/wp-content/uploads/2016/09/iphone_gpio_remote_300.png)

# Dependicies
This code is dependent on CocoaAsyncSocket on https://github.com/robbiehanson/CocoaAsyncSocket. 

Install using CocoaPods by adding this line to your Podfile:

````ruby
use_frameworks! # Add this if you are targeting iOS 8+ or using Swift
pod 'CocoaAsyncSocket'  
````

# Overview
The app creates two connections to the server side Python scripts. One TCP Socket used as a point-to-point control interface enabling the app to change values on GPIO outputs. It also has a UDP Socket which the app uses to listen to for any changes on outputs or inputs on the GPIO.

I used the local broadcast address for the UDP connection. On my network this was 172.16.1.255. TCP address on my network was 172.16.1.51.

Before you start the app, you will need to install the python server side scripts as shown on https://github.com/matzpersson/raspberry-gpio-sockets.git


# Usage
Launch from Workspace file, type in connection details and wait for incoming messages. 

# Copyright
Copyright 2016 Headstation. (http://headstation.com) All rights reserved. It is free software and may be redistributed under the terms specified in the LICENSE file (Apache License 2.0). 
