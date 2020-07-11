//
//  DoneProWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/11/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
class DoneProWorkoutViewController: UIViewController {
	var finishedMatch : Match!
	var totalGhosts : Int!
	var missed : Int!
	var games : Int!
	var totalTime : String!
	var avgTime : String!
	@IBOutlet weak var totalGhostsLabel: UILabel!
	@IBOutlet weak var avgTimeLabel: UILabel!
	@IBOutlet weak var totalTimeLabel: UILabel!
	@IBOutlet weak var totalGamesLabel: UILabel!
	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var totalMissedLabel: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
		doneButton.contentMode = .scaleAspectFit
		totalGhostsLabel.text = String(totalGhosts)
		avgTimeLabel.text = avgTime
		totalTimeLabel.text = totalTime
		totalGamesLabel.text = String(games)
		totalMissedLabel.text = String(missed)
    }
	@IBAction func done(_ sender: Any) {
		popBack(5)
	}
	func popBack(_ nb: Int) {
		if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
			guard viewControllers.count < nb else {
				self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
				return
			}
		}
	}
}
