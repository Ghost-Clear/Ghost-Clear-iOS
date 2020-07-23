//
//  SecondButtonSetViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/5/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class SecondButtonSetViewController: UIViewController {
	@IBOutlet weak var beepTestButton: UIButton!
	@IBOutlet weak var playProButton: UIButton!
	var parentView : WorkoutButtonsPageViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
		beepTestButton.contentMode = .redraw
		playProButton.contentMode = .redraw
    }
	override func viewWillAppear(_ animated: Bool) {
		beepTestButton.contentMode = .redraw
		playProButton.contentMode = .redraw
	}
	@IBAction func beepTest(_ sender: Any) {
		parentView.parentView.performSegue(withIdentifier: "BeepTestWorkoutDescriptionViewControllerSegue", sender: nil)
	}
	@IBAction func playPro(_ sender: Any) {
		parentView.parentView.performSegue(withIdentifier: "MainChooseMatchViewControllerSegue", sender: nil)
	}
}
