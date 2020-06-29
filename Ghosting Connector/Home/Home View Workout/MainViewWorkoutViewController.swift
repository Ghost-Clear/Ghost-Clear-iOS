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
class MainViewWorkoutViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
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
			cell.icon.image = UIImage(named: "mdi_av_timer")
		}
		cell.cellText.text = String(currentWorkout.totalTimeOn!) + "  on per set for "
		cell.cellText.text! += String(currentWorkout.sets)
		if currentWorkout.sets == 1{
			cell.cellText.text! += " set"
		}
		else{
			cell.cellText.text! += " sets"
		}
		// Configure the cell...
		childView.tableView.rowHeight = 75
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		indexToSend = indexPath.row
		performSegue(withIdentifier: "showWorkoutDetail", sender: nil)
	}
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
				let new = self.workoutsFromCoreData[indexPath.row]
				self.workoutsFromCoreData.remove(at: indexPath.row)
				context.delete(new)
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
				//self.getGoals()
				
			}
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			if let workoutsFromCore = try? context.fetch(Workout.fetchRequest()){
				let wFromCore = workoutsFromCore as! [Workout]
				workoutsFromCoreData = wFromCore
			}
		}
		
        // Do any additional setup after loading the view.
    }
    

	@IBAction func done(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "showWorkoutTable" {
			if let childVC = segue.destination as? ViewWorkoutTableViewController {
				//Some property on ChildVC that needs to be set
				childVC.tableView.dataSource = self
				childVC.tableView.delegate = self
				childVC.tableView.reloadData()
				childView = childVC
			}
		}
		if segue.identifier == "showWorkoutDetail" {
			if let childVC = segue.destination as? ViewWorkoutDetailViewController {
				//Some property on ChildVC that needs to be set
				childVC.viewingWorkout = workoutsFromCoreData[indexToSend]
			}
		}
    }
    

}
