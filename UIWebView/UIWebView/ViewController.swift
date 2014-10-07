//
//  ViewController.swift
//  UIWebView
//
//  Created by gulingfeng on 14-10-6.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var test = UIWebView()
        test.loadHTMLString("<html><head></head><body><font size='6' color='red'>Test</font><img class='test' width=100% height=100% src=''></body></html>", baseURL: nil)
        test.frame = CGRect(x: 50, y: 100, width: 200, height: 300)
        test.alpha = 1
        test.opaque = false
        test.backgroundColor = UIColor.clearColor()
        
        test.delegate = self
        
        self.view.addSubview(test)
        
        var count1 = 0
        var count2 = 0
        var count3 = 0
        var t=0 as UInt32
        for i in 1...100000
        {
            //random from 1 to 100
            var r = arc4random_uniform(100)+1
            if r<=80 && r>t
            {
                count1++
            }else if r>80 && r<=90 {
                count2++
            }else if r>90 && r<=100 {
                count3++
            }
        }
        println("count1:\(count1) count2:\(count2) count3:\(count3)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //pragma mark - UIWebViewDelegate methods
    func webViewDidFinishLoad(webView: UIWebView){
        var imgPath = NSBundle.mainBundle().resourcePath
        print("imgPage:\(imgPath)")
        imgPath = imgPath?.stringByReplacingOccurrencesOfString("/", withString: "//", options: nil, range: nil)
        imgPath = imgPath?.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: nil, range: nil)
        print("imgPage:\(imgPath)")
        
        //run JAVA Script to load image
        var js = "document.images[0].src='file:/"+imgPath!+"//human_1.png'"
        webView.stringByEvaluatingJavaScriptFromString(js)
    }
}

