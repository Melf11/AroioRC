# AroioRC

This App is a remotecontrol for the settings section on <a href="https://www.abacus-electronics.de/produkte/streaming/aroioos.html">ABACUS-electronics AroioOS</a> products. Without an aroio product you can navigate through the app but there will be no functionality. 
This app is in beta state and there is some more beautification and a few functionalitys left.

Thank you!
Melf

- you can clone it an run it on iOS 11 devices (no simulator because of Hotspot Configuration) with "AroioRM.xcworkspace" in Xcode, you have to change project path in Podfile to your folder
- if you want to use Simulator or native iOS 10 or lower, follow instructions in AddNewAroioViewController.swift at MARK: "for iOS 10 or lower"
- if you want to become a TestFlight Beta Tester please mail me at melf.stoecken@gmail.com

- in aroioOS put AroioOSextensions in "/mnt/mmcblk0p1/custom_overlay/" via sftp and reboot, after reboot connect via ssh and run
```
perl /appReceiver.pl
```
to watch a through the app video download AppThrough.mp4

Screenshot Examples:

<p align="center">
  <img src="https://github.com/Melf11/AroioRC/blob/master/Scrennshots/02_IPad_AddWiFiHotspot.JPG" width="350"/>
  <img src="https://github.com/Melf11/AroioRC/blob/master/Scrennshots/02_IPad_Convolution.JPG" width="350"/>
  <img src="https://github.com/Melf11/AroioRC/blob/master/Scrennshots/02_IPad_Network.JPG" width="350"/>
  <img src="https://github.com/Melf11/AroioRC/blob/master/Scrennshots/02_IPad_TableView.JPG" width="350"/>
</p>
