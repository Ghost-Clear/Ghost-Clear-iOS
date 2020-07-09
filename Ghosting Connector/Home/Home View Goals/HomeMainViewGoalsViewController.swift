//
//  MainViewGoalsViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/9/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreBluetooth
class GoalView: UITableViewCell{
    @IBOutlet var back: UIImageView!
	// des is the description of the label
	@IBOutlet weak var des: UILabel!
}
class HomeMainViewGoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var goalsFromCoreData = [Goal]()
	var count = 0
	var index = 0
	var achievedCount : [Int] = []
	var isAchieved : [Bool] = []
	var isFirstLoad : Bool! = true
	var childView: HomeMainViewGoalsTableViewController!
	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var addButton: UIButton!
	var toEdit : Goal!
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if isFirstLoad{
		cell.alpha = 0
		UIView.animate(withDuration: 0.7, delay: 0.07*Double(indexPath.row), options: .curveEaseIn, animations: {
			cell.alpha = 1
		}, completion: nil)
		}
		if indexPath.row == goalsFromCoreData.count-1{
			isFirstLoad = false
		}
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		index = indexPath.row
		performSegue(withIdentifier: "HomeViewGoalViewControllerSegue", sender: nil)
	}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewGoal", for: indexPath) as!  GoalView
		isAchieved.append(false)
		achievedCount.append(0)
		var allWorkoutsFromCore : [Workout] = []
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			if let wFromCore = try? context.fetch(Workout.fetchRequest()){
				allWorkoutsFromCore = wFromCore as! [Workout]
			}
			
			if let goalsFromCore = try? context.fetch(Goal.fetchRequest()){
                    let goalFromCore = goalsFromCore as! [Goal]
                    print ()
                    count = goalFromCore.count
                    goalsFromCoreData = goalFromCore
                }
                
            }
            goalsFromCoreData.sort{
                return $0.order < $1.order
            }
		goalsFromCoreData[indexPath.row].isCompleted = false
		for workout in allWorkoutsFromCore{
			if goalsFromCoreData[indexPath.row].sets <= workout.sets && workout.totalGhosts >= goalsFromCoreData[indexPath.row].ghosts * goalsFromCoreData[indexPath.row].sets && (goalsFromCoreData[indexPath.row].minutes*60 + goalsFromCoreData[indexPath.row].seconds) * goalsFromCoreData[indexPath.row].sets >= workout.totalTimeOnInSeconds{
				goalsFromCoreData[indexPath.row].isCompleted = true
				isAchieved[indexPath.row] = true
				achievedCount[indexPath.row] += 1
			}
			else{
				goalsFromCoreData[indexPath.row].isCompleted = false
			}
		}
		if(isAchieved[indexPath.row]){
            cell.back.image =  UIImage(named: "Green Rectangle")
        }
        else{
            cell.back.image = UIImage(named: "Red Rectangle")
        }
        var cellText: String
		cellText = " "
		cellText = cellText + String(goalsFromCoreData[indexPath.row].sets)
		if goalsFromCoreData[indexPath.row].sets == 1{
			cellText = cellText + " set of "
		}
		else{
			cellText = cellText + " sets of "
		}
        cellText = cellText + String(goalsFromCoreData[indexPath.row].ghosts)
        if goalsFromCoreData[indexPath.row].ghosts == 1{
             cellText = cellText + " ghost in "
        }
        else{
            cellText = cellText + " ghosts in  "
        }
		cellText += "0 : "
		cellText = cellText + String(goalsFromCoreData[indexPath.row].minutes) + " : "
		cellText = cellText + String(goalsFromCoreData[indexPath.row].seconds) + "  per set"
		
        cell.des?.text = cellText
		cell.des?.font = .systemFont(ofSize: 14)
        cell.des?.adjustsFontSizeToFitWidth = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight:CGFloat = CGFloat()
        cellHeight = 80
        return cellHeight
    }
    @IBAction func doneButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    override func viewDidLoad() {
        super.viewDidLoad()
		addButton.imageView?.contentMode = .scaleAspectFit
		doneButton.imageView?.contentMode = .scaleAspectFit
    }
    override func viewWillAppear(_ animated: Bool) {
		getGoals()
        childView?.tableView.reloadData()
       }
    func getGoals(){
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let goalsFromCore = try? context.fetch(Goal.fetchRequest()){
                let goalFromCore = goalsFromCore as! [Goal]
                count = goalFromCore.count
                goalsFromCoreData = goalFromCore
            }
        }
        goalsFromCoreData.sort{
            return $0.order < $1.order
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
             count -= 1
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let new = self.goalsFromCoreData[indexPath.row]
            self.goalsFromCoreData.remove(at: indexPath.row)
			context.delete(new)
			(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
			self.getGoals()
			}
          }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
			self.count -= 1
			tableView.deleteRows(at: [indexPath], with: .fade)
			if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
				let new = self.goalsFromCoreData[indexPath.row]
				self.goalsFromCoreData.remove(at: indexPath.row)
				context.delete(new)
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
				self.getGoals()
				
			}
		}
		)
		let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
			self.toEdit =  self.goalsFromCoreData[indexPath.row]
			self.performSegue(withIdentifier: "HomeEditGoalViewControllerSegue", sender: nil)
		})
		editAction.backgroundColor = UIColor(red: 255/256, green: 197/256, blue: 66/256, alpha: 1)
		return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	if segue.identifier == "HomeMainViewGoalsTableViewControllerSegue" {
		if let childVC = segue.destination as? HomeMainViewGoalsTableViewController {
		childVC.tableView.dataSource = self
		childVC.tableView.delegate = self
		childVC.tableView.reloadData()
		childView = childVC
		}
	}
	if segue.identifier == "HomeAddGoalViewControllerSegue" {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		if let childVC = segue.destination as? HomeAddGoalViewController {
		childVC.mainSetGoalsView = self
		}
	}
	if segue.identifier == "HomeEditGoalViewControllerSegue" {
		if let childVC = segue.destination as? HomeEditGoalViewController {
			childVC.editingGoal = toEdit
			childVC.parentView = self
		}
	}
	if segue.identifier == "HomeViewGoalViewControllerSegue" {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		if let childVC = segue.destination as? HomeViewGoalViewController {
			childVC.viewingGoal = goalsFromCoreData[index]
			childVC.goalAcheivedCount = achievedCount[index]
			
		}
	}
}
}

