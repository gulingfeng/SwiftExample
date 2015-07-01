//
//  ThirdTableViewController.swift
//  TryNavi
//
//  Created by gulingfeng on 15/6/18.
//  Copyright (c) 2015年 gulingfeng. All rights reserved.
//

import UIKit
import CoreBluetooth

class ThirdTableViewController: UITableViewController {

    var devices = [String:CBPeripheral]()
    override func viewDidLoad() {
        super.viewDidLoad()
        var mcm = BlueTooth.shared.startCentralManager()
        //mcm.scanForPeripheralsWithServices(nil , options: nil)
        self.devices = BlueTooth.shared.cbps
        //self.devices = [Device(name: "test"),Device(name:"test2")]

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "refresh")
        self.tableView.addSubview(refreshControl!)
        //refreshControl?.beginRefreshing()
        //self.tableView.contentInset = UIEdgeInsetsZero
        
        Util.shared.readAllDevices()
        var timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "timerRefresh:", userInfo: nil, repeats: true)
        timer.fire()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func timerRefresh(timer: NSTimer)
    {
        Util.shared.printLog("timerRefresh")
        refreshData()
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch(section)
        {
        case 0:
            title = "New Devices";
        case 1:
            title = "Saved Devices";
        default:
            title = "Other"
        }
        return title
    }

    /*override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let secondCell = tableView.dequeueReusableCellWithIdentifier("SecondCell") as! CustomHeaderCell
        secondCell.backgroundColor = UIColor.cyanColor()
        /*switch(section)
        {
            case 0:
                secondCell.headerLabel.text = "New Devices";
            case 1:
                secondCell.headerLabel.text = "Saved Devices";
            default:
                secondCell.headerLabel.text = "Other"
        }*/
        return secondCell
    }*/

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch (section)
        {
            case 0:
                return self.devices.count
            case 1:
                return Util.shared.allSavedDevices.count
            default:
                return 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        var name:String?
        
        switch (indexPath.section)
        {
        case 0:
            var key = self.devices.keys.array[indexPath.row]
            name = self.devices[key]?.name
            if name == nil || name == ""
            {
                name = self.devices[key]?.identifier.UUIDString
            }
        case 1:
            name = Util.shared.allSavedDevices.values.array[indexPath.row].keyName
        default:
            name = "not found"

        }
        
        cell.textLabel?.text = name
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="ShowDeviceDetail")
        {
            var sc = segue.destinationViewController as! DetailViewController
            var index = self.tableView.indexPathForSelectedRow()
            
            Util.shared.printLog("prepareForSegue section:\(index?.section), index:\(index!.row)")
            sc.cb = self.devices.values.array[index!.row]
            
        }
        
        
    }
    
    func refreshData()
    {
        Util.shared.printLog("refreshData")
        self.devices = BlueTooth.shared.cbps
        refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
