//
//  HomeViewBeepTestWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/6/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
class HomeViewBeepTestWorkoutViewController: UIViewController {
	var viewingWorkout : Workout!
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var greatestLabel: UILabel!
	@IBOutlet weak var avgTimeLabel: UILabel!
	@IBOutlet weak var totalTimeLabel: UILabel!
	@IBOutlet weak var totalGhostsLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
		scoreLabel.text = viewingWorkout.score
		greatestLabel.text = String(viewingWorkout.greatestLevel)
		avgTimeLabel.text = viewingWorkout.avgTimeOn
		totalTimeLabel.text = viewingWorkout.totalTimeOn
		totalGhostsLabel.text = String(viewingWorkout.totalGhosts)
		let date = viewingWorkout.date!
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale.current
		dateLabel.text = dateFormatter.string(from: date)		
    }
	@IBAction func goBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
}
