//
//  ViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 4/25/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainToggle.setOn(false, animated: true)
        lightImage.image = UIImage(systemName: "lightbulb")
        
}

    

    @IBOutlet weak var mainToggle: UISwitch!
    
    
    @IBAction func toggle(_ sender: Any) {
        if mainToggle.isOn{
    lightImage.image = UIImage(systemName: "lightbulb.fill")
       }
    else{
        lightImage.image = UIImage(systemName: "lightbulb")
        }
    }
    
    
   
    
  
    
    @IBOutlet weak var lightImage: UIImageView!
    
}

