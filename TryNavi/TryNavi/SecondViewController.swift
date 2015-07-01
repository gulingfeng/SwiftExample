//
//  ViewController.swift
//  TryNavi
//
//  Created by gulingfeng on 15/5/29.
//  Copyright (c) 2015年 gulingfeng. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var switchState: UILabel!
    var data:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        switchState.text=data
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

