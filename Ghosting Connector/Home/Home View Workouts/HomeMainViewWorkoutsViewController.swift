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
		cell.cellText.text = String(currentWorkout.totalTimeOn!) + "  on per set for "
		cell.cellText.text! += String(currentWorkout.sets)
		if currentWorkout.sets == 1{
			cell.cellText.text! += " set"
		}
		else{
			cell.cellText.text! += " sets"
		}
		childView.tableView.rowHeight = 75
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		indexToSend = indexPath.row
		performSegue(withIdentifier: "HomeViewWorkoutViewControllerSegue", sender: nil)
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
			if let childVC = segue.destination as? HomeViewWorkoutViewController {
				childVC.viewingWorkout = workoutsFromCoreData[indexToSend]
			}
		}
    }
}
