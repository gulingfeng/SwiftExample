//
//  BlueTooth.swift
//  TryNavi
//
//  Created by gulingfeng on 15/6/18.
//  Copyright (c) 2015年 gulingfeng. All rights reserved.
//

import Foundation

import CoreBluetooth

class BlueTooth: NSObject,CBCentralManagerDelegate,CBPeripheralDelegate {
    

    var myCentralManager:CBCentralManager!
    var immediateAlertService:CBService!
    var linkLossAlertService:CBService!
    var linkLossAlertCharacteristic:CBCharacteristic!
    var alertLevelCharacteristic:CBCharacteristic!
    var cbPeripheral:CBPeripheral!
    var cbps = [String:CBPeripheral]()
    
    class var shared:BlueTooth {
        return Inner.instance
    }
    
    struct Inner {
        static var instance = BlueTooth()
        
    }

    override init()
    {
        super.init()
        
    }
    
    //start up a central manager object
    func startCentralManager()->CBCentralManager{
        myCentralManager = CBCentralManager(delegate: self, queue: nil)
        //myCentralManager!.scanForPeripheralsWithServices(nil , options: nil)
        return myCentralManager
        
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!){
        println("CentralManager is initialized")
        
        switch central.state{
        case CBCentralManagerState.Unauthorized:
            println("The app is not authorized to use Bluetooth low energy.")
            //myCentralManager!.stopScan()
            
        case CBCentralManagerState.PoweredOff:
            println("Bluetooth is currently powered off.")
            //myCentralManager!.stopScan()
            
        case CBCentralManagerState.PoweredOn:
            println("Bluetooth is currently powered on and available to use.")
            myCentralManager!.scanForPeripheralsWithServices(nil , options: nil)
            
        default:break
        }
    }
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        println("CenCentalManagerDelegate didDiscoverPeripheral")
        println("Discovered \(peripheral.name)")
        println("peripheral: \(peripheral)")
        println("peripheral identifier.description: \(peripheral.identifier.UUIDString)")
        println("Rssi: \(RSSI)")
        
        cbps.updateValue(peripheral, forKey: peripheral.identifier.UUIDString)
        if peripheral.identifier.UUIDString == "1A91704F-ABE1-206B-1AFE-B94E56A66107"
        {
            println("Stop scan the Ble Devices\(peripheral.identifier.description)")
            //myCentralManager!.stopScan()
            //cbPeripheral = peripheral
        }
        
    }
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        println("CenCentalManagerDelegate didConnectPeripheral")
        println("Connected with \(peripheral)")
        peripheral.delegate = self
        
        peripheral.discoverServices(nil)
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("CenCentalManagerDelegate didFailToConnectPeripheral")
    }
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("CenCentalManagerDelegate didDisconnectPeripheral")
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        println("CBPeripheralDelegate didDiscoverServices")
        for  service in peripheral.services {
            println("Discover service \(service)")
            println("UUID \(service.UUID)")
            if(service.UUID == CBUUID(string: "180D")){
                println("in if UUID=Heart Rate")
                immediateAlertService = (service as! CBService)
                println("immediateAlertService:\(immediateAlertService)")
                
                peripheral.discoverCharacteristics(nil , forService: immediateAlertService)
            }else if(service.UUID == CBUUID(string: "180A")){
                println("in if UUID Battery")
                linkLossAlertService = (service as! CBService)
                println("linkLossAlertService:\(linkLossAlertService)")
                
                peripheral.discoverCharacteristics(nil , forService: linkLossAlertService)
            }
        }
    }
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        for characteristic in service.characteristics{
            println("characteristic:\(characteristic)")
            if(service == immediateAlertService && characteristic.UUID == CBUUID(string: "2A38")){
                println("immediateAlertService Discover characteristic \(characteristic)")
                alertLevelCharacteristic = (characteristic as! CBCharacteristic)
                println("alertLevelCharacteristic:\(alertLevelCharacteristic)")
                cbPeripheral!.readValueForCharacteristic(alertLevelCharacteristic!)
                //immediateAlertCharacter 写入是有问题的
                //                cbPeripheral!.writeValue(NSData(bytes: &alertLevel, length: 1), forCharacteristic: characteristic as CBCharacteristic, type: CBCharacteristicWriteType.WithResponse)
            }else if(service == linkLossAlertService && characteristic.UUID == CBUUID(string: "CA8A")){
                println("linkLossAlertService Discover characteristic \(characteristic)")
                linkLossAlertCharacteristic = (characteristic as! CBCharacteristic)
                println("linkLossAlertCharacteristic:\(linkLossAlertCharacteristic)")
                
                //linkLossAlertCharacteristic 写入没有问题，所以通过这个写入来进行绑定
                //cbPeripheral!.writeValue(NSData(bytes: &alertLevel, length: 1), forCharacteristic: characteristic as CBCharacteristic, type: CBCharacteristicWriteType.WithResponse)
            }
        }
    }
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if(error != nil){
            println("Error Reading characteristic value: \(error.localizedDescription)")
        }else{
            var data = characteristic.value
            println("Update value is \(data)")
        }
        
    }
}
