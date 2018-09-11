//
//  ViewController.swift
//  AlfieSoundProject
//
//  Created by Amanda Demetrio on 9/8/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    var player = AVAudioPlayer()
    
    @IBOutlet weak var alfieImageLabel: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let img = UIImage(named: "IMG_1037.JPG")
        if (alfieImageLabel) != nil {
            alfieImageLabel.image = img
        }
        if motionManager.isDeviceMotionAvailable {
            print("We can detect device motion")
            startReadingMotionData()
        }
        else {
            print("We cannot detect device motion")
        }
    }
    
    func startReadingMotionData() {
        motionManager.deviceMotionUpdateInterval = 1
        motionManager.startDeviceMotionUpdates(to: opQueue) {
            (data: CMDeviceMotion?, error: Error?) in
            
            if let mydata = data {
                
                if self.degrees(mydata.attitude.roll) > 20.0 {
                    self.playAudio(resourceName: "AlfieBone")
                    //print("right turn")
                }
                
                else if self.degrees(mydata.attitude.roll) < -20.0 {
                    self.playAudio(resourceName: "AlfieEh")
                    //print("left turn")
                }
                
                else if self.degrees(mydata.attitude.pitch) < -20.0 {
                    self.playAudio(resourceName: "AlfieGoodBoy")
                    //print("forward turn")
                }
                
                else if self.degrees(mydata.attitude.pitch) > 20.0 {
                    self.playAudio(resourceName: "AlfieStop")
                    //print("backwards turn")
                }
            }
        }
    }
    
    func degrees(_ radians: Double) -> Double {
        return 180/Double.pi * radians
    }
    
    func playAudio(resourceName: String) {
        print("got inside play audio")
        let path = Bundle.main.path(forResource: resourceName, ofType : "m4a")!
        print(path)
        let url = URL(fileURLWithPath : path)
        print(url)
        do {
            print("got inside do")
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player.prepareToPlay();
            self.player.play()
        } catch {
            print ("There is an issue with this code!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

