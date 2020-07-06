//
//  DoneBeepTestWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/5/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class DoneBeepTestWorkoutViewController: UIViewController {
	var totalTimeOn : String!
	var beepTestScore: String!
	var greatestLevelAcheived : Int!
	var totalGhost: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
		doneButton.contentMode = .scaleAspectFit
		beepTestScoreLabel.text = beepTestScore
		totalTimeOnLabel.text = totalTimeOn
		totalGhostsLabel.text = String(totalGhost)
		greatestLevelAcheivedLabel.text = String(greatestLevelAcheived)
    }
	func popBack(_ nb: Int) {
		if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
			guard viewControllers.count < nb else {
				self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
				return
			}
		}
	}
	@IBAction func done(_ sender: Any) {
		popBack(4)
	}
	@IBOutlet weak var beepTestScoreLabel: UILabel!
	@IBOutlet weak var totalTimeOnLabel: UILabel!
	@IBOutlet weak var totalGhostsLabel: UILabel!
	@IBOutlet weak var greatestLevelAcheivedLabel: UILabel!
	@IBOutlet weak var doneButton: UIButton!

}
