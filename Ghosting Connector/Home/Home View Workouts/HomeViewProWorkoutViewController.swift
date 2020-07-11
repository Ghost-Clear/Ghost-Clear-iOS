//
//  HomeViewProWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/11/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
class HomeViewProWorkoutViewController: UIViewController {
	var viewingWorkout : Workout!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var totalGamesLabel: UILabel!
	@IBOutlet weak var difficultyLabel: UILabel!
	@IBOutlet weak var playerLabel: UILabel!
	@IBOutlet weak var matchNameLabel: UILabel!
	@IBOutlet weak var totalGhostsLabel: UILabel!
	@IBOutlet weak var totalTimeLabel: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
		let date = viewingWorkout.date!
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale.current
		dateFormatter.dateStyle = .full
		dateLabel.text = dateFormatter.string(from: date)
		totalGamesLabel.text = String(viewingWorkout.sets)
		difficultyLabel.text = viewingWorkout.difficulty
		playerLabel.text = viewingWorkout.playerNames
		matchNameLabel.text = viewingWorkout.matchName
		totalGhostsLabel.text = String(viewingWorkout.totalGhosts)
		totalTimeLabel.text = viewingWorkout.totalTimeOn
    }
	@IBAction func goBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
}
