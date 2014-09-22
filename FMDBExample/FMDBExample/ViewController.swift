//
//  ViewController.swift
//  FMDBExample
//
//  Created by gulingfeng on 14-9-22.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        testDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func testDB()
    {
        println("start testdb")
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let db = FMDatabase(path: appDelegate.dbFilePath)
        
        if db.open()
        {
            println("open db ok")
        }else{
            println("open db failed")
            return
        }
        let create="create table test_db (name text,keyword text)"
        let queryTable = "select count(1) from test_db"
        var tableResult = db.executeQuery(queryTable, withArgumentsInArray: nil)
        var success = false
        if tableResult == nil || !tableResult.next()
        {
            success = db.executeUpdate(create, withArgumentsInArray: nil)
            if success
            {
                println("create success")
            }
        }else{
            println("table is already created")
        }
        
        let insertSql = "insert into test_db (name,keyword) values('xiaoming','keyword xiaoming')"
        success = db.executeUpdate(insertSql, withArgumentsInArray: nil)
        if success
        {
            println("insert success")
        }
        let updateSql = "update test_db set keyword='new xiaoming keyword' where name='xiaoming'"
        success = db.executeUpdate(updateSql, withArgumentsInArray: nil)
        if success
        {
            println("update success")
        }
        let querySql = "select * from test_db"
        let result = db.executeQuery(querySql, withArgumentsInArray: nil)
        while result.next()
        {
            let name = result.stringForColumn("name")
            let keyword = result.stringForColumn("keyword")
            println("name: \(name) keyword: \(keyword)")
        }
    }



}

