//
//  DetailViewController.swift
//  TryNavi
//
//  Created by gulingfeng on 15/6/18.
//  Copyright (c) 2015年 gulingfeng. All rights reserved.
//

import UIKit
import CoreBluetooth

class DetailViewController: UIViewController {

    @IBOutlet weak var DeviceName: UILabel!
    @IBOutlet weak var DeviceUUID: UILabel!
    
    @IBOutlet weak var SavedDeviceName: UITextField!
    @IBOutlet weak var ReadDeviceName: UILabel!
    @IBOutlet weak var ReadDeviceUUID: UILabel!
    
    var cb : CBPeripheral!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.DeviceName.text = cb.name
        self.DeviceUUID.text = cb.identifier.UUIDString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveDevice(sender: UIButton) {
        Util.shared.printLog("SaveDevice")
        var key = self.SavedDeviceName.text
        if key == nil || key == ""
        {
            key = cb.identifier.UUIDString
        }
        Util.shared.printLog("key:\(key)")

        Util.shared.saveDevice(key, cb: cb)
        self.ReadDeviceName.text = ""
        self.ReadDeviceUUID.text = ""
    }
    
    @IBAction func ReadDevice(sender: UIButton) {
        Util.shared.printLog("ReadDevice")
        var key = self.SavedDeviceName.text
        if key == nil || key == ""
        {
            key = cb.identifier.UUIDString
        }
        var data = Util.shared.readDevice(key)
        if data != nil
        {
            self.ReadDeviceName.text = data!["name"]
            self.ReadDeviceUUID.text = data!["UUID"]
        }else{
            var alert = UIAlertView(title: "Error", message: "There's no data", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if self.SavedDeviceName.exclusiveTouch == false
        {
            self.SavedDeviceName.resignFirstResponder()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
