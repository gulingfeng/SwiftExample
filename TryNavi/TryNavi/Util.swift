//
//  Util.swift
//  TryNavi
//
//  Created by gulingfeng on 15/6/22.
//  Copyright (c) 2015年 gulingfeng. All rights reserved.
//

import Foundation
import CoreBluetooth

class Util : NSObject{
    let deveiceDataFileName = "DeviceData.archive"
    let deviceListFileName = "deviceList.archive"
    let settingDataFileName = "settingData.archive"
    var dateFormatter:NSDateFormatter!
    var allSavedDevices = [String:BlueToothDevice]()
    
    class var shared:Util {
        return Inner.instance
    }
    
    struct Inner {
        static var instance = Util()
        
    }
    
    override init()
    {
        super.init()
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.FullStyle
    }
    
    func printLog(msg: String)
    {
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss SSSS"
        var date = dateFormatter.stringFromDate(NSDate())
        println("\(date): \(msg)")
    }
    
    func saveDevice(key: String,cb: CBPeripheral)
    {
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var filePath = documentFolderPath.stringByAppendingPathComponent(deveiceDataFileName)
        printLog("key:\(key),filePath:\(filePath)")
        var data = NSMutableData()
        var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        var device = BlueToothDevice(keyName: key, deviceName: cb.name, UUID: cb.identifier.UUIDString, needTrack: true)
        //archiver.encodeObject(["name":cb.name,"UUID":cb.identifier.UUIDString], forKey: key)
        //archiver.encodeObject(device, forKey: key)
        allSavedDevices[key] = device
        archiver.encodeObject(allSavedDevices, forKey: "AllDevices")
        archiver.finishEncoding()
        data.writeToFile(filePath, atomically: true)
    }
    
    func readDevice(key: String) -> [String:String]?
    {
        readAllDevices()
        /*
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var filePath = documentFolderPath.stringByAppendingPathComponent(deveiceDataFileName)
        printLog("key:\(key),filePath:\(filePath)")
        var unArchiverData = NSData(contentsOfFile: filePath)
        var unArchiver = NSKeyedUnarchiver(forReadingWithData: unArchiverData!)
        var decodeData = unArchiver.decodeObjectForKey(key) as? BlueToothDevice
        */
        var decodeData = allSavedDevices[key]
        if (decodeData != nil)
        {
            var name = decodeData?.UUID
            printLog(name!)
        }
        return ["name":decodeData!.deviceName,"UUID":decodeData!.UUID]
    }
    
    func readAllDevices()
    {
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var filePath = documentFolderPath.stringByAppendingPathComponent(deveiceDataFileName)
        printLog("filePath:\(filePath)")

        var unArchiverData = NSData(contentsOfFile: filePath)
        var unArchiver = NSKeyedUnarchiver(forReadingWithData: unArchiverData!)
        var decodeData = unArchiver.decodeObjectForKey("AllDevices") as? [String:BlueToothDevice]

        
        if decodeData != nil
        {
            allSavedDevices = decodeData!
            for (keyName,device) in allSavedDevices
            {
                printLog("\(keyName),name:\(device.deviceName),UUID:\(device.UUID)")
            }
        }
    }
}

class BlueToothDevice: NSObject,NSCoding
{
    var keyName:String
    var deviceName:String
    var UUID:String
    var needTrack:Bool

    init(keyName:String,deviceName:String,UUID:String,needTrack:Bool)
    {
        self.keyName = keyName
        self.deviceName = deviceName
        self.UUID = UUID
        self.needTrack = needTrack
    }
    
    required init(coder aDecoder: NSCoder)
    {
        keyName = aDecoder.decodeObjectForKey("keyName") as! String
        deviceName = aDecoder.decodeObjectForKey("deviceName") as! String
        UUID = aDecoder.decodeObjectForKey("UUID") as! String
        needTrack = aDecoder.decodeBoolForKey("needTrack")
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.keyName, forKey: "keyName")
        aCoder.encodeObject(self.deviceName, forKey: "deviceName")
        aCoder.encodeObject(self.UUID, forKey: "UUID")
        aCoder.encodeBool(self.needTrack, forKey: "needTrack")
    }
}