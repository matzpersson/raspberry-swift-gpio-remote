# Swift Raspberry GPIO Remote
Control your Raspberry from a Swift application using UDP and TCP Sockets. Works together with python scripts on https://github.com/matzpersson/raspberry-gpio-sockets.git

# Dependicies
This code is dependent on CocoaAsyncSocket on https://github.com/robbiehanson/CocoaAsyncSocket. Requires a 

Install using CocoaPods by adding this line to your Podfile:

````ruby
use_frameworks! # Add this if you are targeting iOS 8+ or using Swift
pod 'CocoaAsyncSocket'  
````

# Overview
The app creates two connections to the server side Python scripts.
# Usage
Launch from Workspace file, type in connection details and wait for incoming messages. Use UDP Broadcasting Server https://github.com/matzpersson/udp-broadcasting.git to broadcast test messages.

