//
//  ViewController.swift
//  TryNavi
//
//  Created by gulingfeng on 15/5/29.
//  Copyright (c) 2015年 gulingfeng. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController, AVAudioRecorderDelegate {

    var recorder:AVAudioRecorder!
    var player:AVAudioPlayer!
    
    var audioSession = AVAudioSession.sharedInstance()
    
    @IBOutlet weak var Switch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioSession.setActive(true, error: nil)
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        recorder = AVAudioRecorder(URL: NSURL(fileURLWithPath: "\(path)/sound.wav"), settings: nil, error: nil)
        recorder.delegate = self
        Util.shared.printLog("\(recorder.prepareToRecord())")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="next")
        {
            var sc = segue.destinationViewController as! SecondViewController
            if Switch.on
            {
                sc.data = "on"
            }else
            {
                sc.data = "off"
            }
            
        }
        
        
    }
    
    @IBAction func startRecord(sender: UIButton) {
        Util.shared.printLog("\(recorder.record())")
    }
    
    @IBAction func stopRecord(sender: UIButton) {
        recorder.stop()
        Util.shared.printLog("stop record")
    }
    
    @IBAction func playSound(sender: UIButton) {
        player = AVAudioPlayer(contentsOfURL: recorder.url, error: nil)
        player.prepareToPlay()
        player.volume = 2
        player.play()
        Util.shared.printLog("player play")
    }
}

