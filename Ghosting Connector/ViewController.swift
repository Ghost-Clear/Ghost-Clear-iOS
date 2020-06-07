//
//  ViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 4/25/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController {
    let mqttClient = CocoaMQTT(clientID:"iosDevice", host: "192.168.1.37",port: 1883)
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        mqttClient.connect();
        // Do any additional setup after loading the view.
        mainToggle.setOn(false, animated: true)
        lightImage.image = UIImage(systemName: "lightbulb")
        
}

    override func viewDidDisappear(_ animated: Bool) {
        mqttClient.disconnect();
        mqttClient.publish("rpi/gpio", withString: "off")
    }

    @IBOutlet weak var mainToggle: UISwitch!
    
    
    @IBAction func toggle(_ sender: Any) {
        if mainToggle.isOn{
    lightImage.image = UIImage(systemName: "lightbulb.fill")
            mqttClient.publish("rpi/gpio", withString: "on")
       }
    else{
        lightImage.image = UIImage(systemName: "lightbulb")
            mqttClient.publish("rpi/gpio", withString: "off")
        }
    }
    
    
   
    
  
    

    @IBOutlet weak var lightImage: UIImageView!
    
}

