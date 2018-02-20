# AroioRC

This App is a Remotecontroll for the settingssection on ABACUS-electronics AroioOS products. Without an aroio product you can navigate through the app but there will be no functionality. 

- This app is in beta state, you can clone it an run it on iOS 11 devices (no simulator) with "AroioRM.xcworkspace" in Xcode, you have to change path in Podfile to your folder
- if you want to use Simulator or native iOS 10 or lower, follow instructions in AddNewAroioViewController.swift at MARK: "for iOS 10 or lower"
- if you want to become a TestFlight Beta Tester please mail me at melf.stoecken@gmail.com

- in aroioOS put AroioOSextensions in "/mnt/mmcblk0p1/custom_overlay/" via sftp and reboot, after reboot connect via ssh and run
```
perl /appReceiver.pl
```

Screenshot Examples:

<p align="center">
  <img src="https://github.com/Melf11/AroioRC/blob/master/Scrennshots/02_IPad_AddWiFiHotspot.JPG" width="350"/>
  <img src="https://github.com/Melf11/AroioRC/blob/master/Scrennshots/02_IPad_Convolution.JPG" width="350"/>
  <img src="https://github.com/Melf11/AroioRC/blob/master/Scrennshots/02_IPad_Network.JPG" width="350"/>
  <img src="https://github.com/Melf11/AroioRC/blob/master/Scrennshots/02_IPad_TableView.JPG" width="350"/>
</p>

AppThrough Video:

<video src="AppThrough.mp4" width="320" height="200" controls preload></video>
