//
//  BeepTestWorkoutDescriptionViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/5/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class BeepTestWorkoutDescriptionViewController: UIViewController {

	@IBAction func goBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	@IBOutlet weak var startGhostButton: UIButton!
	@IBAction func startGhost(_ sender: Any) {
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		startGhostButton.contentMode = .scaleAspectFit
    }
}
