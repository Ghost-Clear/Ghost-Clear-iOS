//
//  SetYourGoalsViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/8/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreBluetooth
class InitialMainViewGoalsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   var goalsFromCoreData = [Goal]()
    var count = 0
	var toEdit : Goal!
	var index = 0
    var childView: InitialMainViewGoalsTableViewController? = nil
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var FinishButton: UIButton!
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return count
    }

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		index = indexPath.row
		performSegue(withIdentifier: "viewSingularGoal", sender: nil)
	}
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newGoal", for: indexPath)
        var cellText: String  = ""
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
		
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = cellText
		cell.textLabel?.font = .systemFont(ofSize: 15)
		cell.textLabel?.adjustsFontSizeToFitWidth = true
		cell.textLabel?.textAlignment = NSTextAlignment.center
        // Configure the cell...
       
        
       
        return cell
    }
	@IBAction func FinishCreatingGoals(_ sender: Any) {
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			let firstLaunch = IsFirstLaunch(context: context)
			firstLaunch.bool = true
		}
		(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
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
			//do segue here
			self.toEdit =  self.goalsFromCoreData[indexPath.row]
			self.performSegue(withIdentifier: "editSingularGoal", sender: nil)
			
			
		})
		editAction.backgroundColor = UIColor(red: 255/256, green: 197/256, blue: 66/256, alpha: 1)
		return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
	}

     
	
	
	
	
	
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight:CGFloat = CGFloat()
        cellHeight = 80
        return cellHeight
    }
    func getGoals(){
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
		addButton.imageView?.contentMode = .scaleAspectFit
		FinishButton.imageView?.contentMode = .scaleAspectFit
    }
    override func viewWillAppear(_ animated: Bool) {
        getGoals()
        childView?.tableView.reloadData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showTables" {
          if let childVC = segue.destination as? InitialMainViewGoalsTableViewController {
            //Some property on ChildVC that needs to be set
            childVC.tableView.dataSource = self
            childVC.tableView.delegate = self
            childVC.tableView.reloadData()
            childView = childVC
          }
        }
        if segue.identifier == "createSingular" {
          if let childVC = segue.destination as? InitialAddGoalViewController {
            //Some property on ChildVC that needs to be set
            childVC.mainSetGoalsView = self
          }
        }
		if segue.identifier == "editSingularGoal" {
			if let childVC = segue.destination as? InitialEditGoalViewController {
				//Some property on ChildVC that needs to be set
				childVC.editingGoal = toEdit
				childVC.parentView = self
			}
		}
		if segue.identifier == "viewSingularGoal" {
			if let childVC = segue.destination as? InitialViewGoalViewController {
				//Some property on ChildVC that needs to be set
				childVC.viewingGoal = goalsFromCoreData[index]
			}
		}
		
        
    }
    

}
