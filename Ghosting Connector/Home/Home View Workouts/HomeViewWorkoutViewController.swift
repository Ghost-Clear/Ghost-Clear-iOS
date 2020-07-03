//
//  ViewWorkoutDetailViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/29/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
class HomeViewWorkoutViewController: UIViewController {
	var viewingWorkout : Workout!
	@IBOutlet weak var workoutTypeLabel: UILabel!
	@IBOutlet weak var averageTimeLabel: UILabel!
	@IBOutlet weak var totalTimeLabel: UILabel!
	@IBOutlet weak var averageGhostsLabel: UILabel!
	@IBOutlet weak var totalGhostsLabel: UILabel!
	@IBOutlet weak var ghostedCornersLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var setsLabel: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
		averageTimeLabel.text = viewingWorkout.avgTimeOn
		totalTimeLabel.text = viewingWorkout.totalTimeOn
		averageGhostsLabel.text = String(viewingWorkout.avgGhosts)
		totalGhostsLabel.text = String(viewingWorkout.totalGhosts)
		ghostedCornersLabel.text = viewingWorkout.ghostedCorners
		let date = viewingWorkout.date!
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale.current
		dateFormatter.dateStyle = .full
		dateLabel.text = dateFormatter.string(from: date)
		workoutTypeLabel.text = viewingWorkout.type! + " Workout"
		setsLabel.text = String(viewingWorkout.sets)
    }
	@IBAction func goBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
}
