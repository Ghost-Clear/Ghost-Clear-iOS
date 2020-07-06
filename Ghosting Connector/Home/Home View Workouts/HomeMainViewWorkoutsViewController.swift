//
//  MainViewWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/29/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
class workoutCell : UITableViewCell{
	@IBOutlet var icon : UIImageView!
	@IBOutlet var cellText : UILabel!
}
class HomeMainViewWorkoutsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
	@IBOutlet weak var doneButton: UIButton!
	var childView : UITableViewController!
	var workoutsFromCoreData = [Workout]()
	var indexToSend : Int!
	var isFirstLoad : Bool! = true
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if isFirstLoad{
		cell.alpha = 0
		UIView.animate(withDuration: 0.7, delay: 0.07*Double(indexPath.row), options: .curveEaseIn, animations: {
			cell.alpha = 1
		}, completion: nil)
		}
		if indexPath.row == workoutsFromCoreData.count-1{
			isFirstLoad = false
		}
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			if let workoutsFromCore = try? context.fetch(Workout.fetchRequest()){
				let wFromCore = workoutsFromCore as! [Workout]
				workoutsFromCoreData = wFromCore
			}
		}
		return workoutsFromCoreData.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! workoutCell
		let currentWorkout = workoutsFromCoreData[indexPath.row]
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			if let workoutsFromCore = try? context.fetch(Workout.fetchRequest()){
				let wFromCore = workoutsFromCore as! [Workout]
				workoutsFromCoreData = wFromCore
			}
		}
		if currentWorkout.type == "Timed"{
			cell.icon.image = UIImage(named: "Timer Image")
		}
		else if currentWorkout.type == "Number"{
			cell.icon.image = UIImage(named: "Number Image")
		}
		else if currentWorkout.type == "Beep Test"{
			cell.icon.image = UIImage(named: "Bell Image")
		}
		if currentWorkout.type == "Timed" || currentWorkout.type == "Number"{
			cell.cellText.text = String(currentWorkout.avgTimeOn!) + "  on per set for "
			cell.cellText.text! += String(currentWorkout.sets)
			if currentWorkout.sets == 1{
				cell.cellText.text! += " set"
			}
			else{
				cell.cellText.text! += " sets"
			}
		}
		else if currentWorkout.type == "Beep Test"{
			cell.cellText.text! = "Acheived a score of " + currentWorkout.score! + " in  " + currentWorkout.totalTimeOn!
		}
		childView.tableView.rowHeight = 75
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		indexToSend = indexPath.row
		if workoutsFromCoreData[indexPath.row].type == "Timed" || workoutsFromCoreData[indexPath.row].type == "Number"{
			performSegue(withIdentifier: "HomeViewWorkoutViewControllerSegue", sender: nil)
		}
		else{
			performSegue(withIdentifier: "HomeViewBeepTestWorkoutViewControllerSegue", sender: nil)
		}
	}
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
				let new = self.workoutsFromCoreData[indexPath.row]
				self.workoutsFromCoreData.remove(at: indexPath.row)
				context.delete(new)
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
			}
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
		}
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		doneButton.imageView?.contentMode = .scaleAspectFit
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			if let workoutsFromCore = try? context.fetch(Workout.fetchRequest()){
				let wFromCore = workoutsFromCore as! [Workout]
				workoutsFromCoreData = wFromCore
			}
		}
    }
	@IBAction func done(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "HomeMainViewWorkoutsTableViewControllerSegue" {
			if let childVC = segue.destination as? HomeMainViewWorkoutsTableViewController {
				childVC.tableView.dataSource = self
				childVC.tableView.delegate = self
				childVC.tableView.reloadData()
				childView = childVC
			}
		}
		if segue.identifier == "HomeViewWorkoutViewControllerSegue" {
			let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
			selectionFeedbackGenerator.selectionChanged()
			if let childVC = segue.destination as? HomeViewWorkoutViewController {
				childVC.viewingWorkout = workoutsFromCoreData[indexToSend]
			}
		}
		if segue.identifier == "HomeViewBeepTestWorkoutViewControllerSegue" {
			let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
			selectionFeedbackGenerator.selectionChanged()
			if let childVC = segue.destination as? HomeViewBeepTestWorkoutViewController {
				childVC.viewingWorkout = workoutsFromCoreData[indexToSend]
			}
		}
    }
}
