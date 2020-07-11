//
//  PlayerStatsViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/11/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
class PlayerStatsViewController: UIViewController {
	@IBOutlet weak var totalTimeLabel: UILabel!
	var parentView : HomeChartPageViewController!
	@IBOutlet weak var totalGhostsLabel: UILabel!
	@IBOutlet weak var totalWorkoutsLabel: UILabel!
	@IBOutlet weak var beepTestScoreLabel: UILabel!
	var workoutsFromCore : [Workout]!
	override func viewDidLoad() {
        super.viewDidLoad()
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			if let workouts = try? context.fetch(Workout.fetchRequest()){
				workoutsFromCore = (workouts as! [Workout])
			}
		}
		var totalTimeInSeconds = 0
		var totalGhosts = 0
		let totalWorkouts = workoutsFromCore.count
		var bestBeepTestScore : Double! = 0
		for workout in workoutsFromCore{
			totalTimeInSeconds += Int(workout.totalTimeOnInSeconds)
			totalGhosts += Int(workout.totalGhosts)
			if workout.type == "Beep Test"{
				if (workout.score! as NSString).doubleValue > bestBeepTestScore{
					bestBeepTestScore = (workout.score! as NSString).doubleValue
				}
			}
		}
		var seconds = totalTimeInSeconds
		var minutes = 0
		var hours = 0
		if seconds >= 60{
			minutes += Int(seconds / 60)
			seconds -= minutes * 60
		}
		if minutes >= 60{
			hours += Int(minutes / 60)
			minutes -= minutes * 60
		}
		let timeString = String(hours) + " : " + String(minutes) + " : " + String(seconds)
		totalTimeLabel.text = "Total Time Ghosted : " + timeString
		totalGhostsLabel.text = "Total Ghosts : " + String(totalGhosts)
		totalWorkoutsLabel.text = "Total Workouts : " + String(totalWorkouts)
		beepTestScoreLabel.text = "Best Beep Test Score : " + String(bestBeepTestScore)
    }
	override func viewWillAppear(_ animated: Bool) {
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			if let workouts = try? context.fetch(Workout.fetchRequest()){
				workoutsFromCore = (workouts as! [Workout])
			}
		}
		var totalTimeInSeconds = 0
		var totalGhosts = 0
		let totalWorkouts = workoutsFromCore.count
		var bestBeepTestScore : Double! = 0
		for workout in workoutsFromCore{
			totalTimeInSeconds += Int(workout.totalTimeOnInSeconds)
			totalGhosts += Int(workout.totalGhosts)
			if workout.type == "Beep Test"{
				if (workout.score! as NSString).doubleValue > bestBeepTestScore{
					bestBeepTestScore = (workout.score! as NSString).doubleValue
				}
			}
		}
		var seconds = totalTimeInSeconds
		var minutes = 0
		var hours = 0
		if seconds >= 60{
			minutes += Int(seconds / 60)
			seconds -= minutes * 60
		}
		if minutes >= 60{
			hours += Int(minutes / 60)
			minutes -= minutes * 60
		}
		let timeString = String(hours) + " : " + String(minutes) + " : " + String(seconds)
		totalTimeLabel.text = "Total Time Ghosted : " + timeString
		totalGhostsLabel.text = "Total Ghosts : " + String(totalGhosts)
		totalWorkoutsLabel.text = "Total Workouts : " + String(totalWorkouts)
		beepTestScoreLabel.text = "Best Beep Test Score : " + String(bestBeepTestScore)
	}
		
}


