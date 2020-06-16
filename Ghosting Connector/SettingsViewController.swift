//
//  SettingsViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/16/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var homeController: HomePageViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        homeController.reloadInputViews()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
