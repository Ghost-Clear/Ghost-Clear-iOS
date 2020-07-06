//
//  SecondButtonSetViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/5/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class SecondButtonSetViewController: UIViewController {
	var parentView : WorkoutButtonsPageViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	@IBAction func beepTest(_ sender: Any) {
		parentView.parentView.performSegue(withIdentifier: "BeepTestWorkoutDescriptionViewControllerSegue", sender: nil)
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
