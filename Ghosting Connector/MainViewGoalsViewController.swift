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
    @IBOutlet weak var des: UILabel!
}
class MainViewGoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var goalsFromCoreData = [Goal]()
     var count = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewGoal", for: indexPath) as!  GoalView
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
        let currentGoal = goalsFromCoreData[indexPath.row]
        if(currentGoal.isCompleted){
            cell.back.image =  UIImage(named: "greenRectangle")
        }
        else{
            cell.back.image = UIImage(named: "redRectangle")
        }
        var cellText: String
        cellText = "    "
        cellText = cellText + String(goalsFromCoreData[indexPath.row].ghosts)
        if goalsFromCoreData[indexPath.row].ghosts == 1{
             cellText = cellText + " ghost in "
        }
        else{
            cellText = cellText + " ghosts in "
        }
        if goalsFromCoreData[indexPath.row].minutes == 1{
            cellText = cellText + String(goalsFromCoreData[indexPath.row].minutes)
            cellText = cellText + " minute and "
        }
        else{
            cellText = cellText + String(goalsFromCoreData[indexPath.row].minutes)
            cellText = cellText + " minutes and "
        }
        if goalsFromCoreData[indexPath.row].seconds == 1{
            cellText = cellText + String(goalsFromCoreData[indexPath.row].seconds)
                       cellText = cellText + " second"
        }
        else{
            cellText = cellText + String(goalsFromCoreData[indexPath.row].seconds)
            cellText = cellText + " seconds"
        }
        //cell.textLabel?.textColor = UIColor.white
        cell.des?.text = cellText
        //cell.textLabel?.layer.cornerRadius = 15.0
        //cell.textLabel?.clipsToBounds = true
        // Configure the cell...
        
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
    
    var childView: ViewYourGoalsTableViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
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
          } else if editingStyle == .insert {
              // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
          }

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showGoalTables" {
          if let childVC = segue.destination as? ViewYourGoalsTableViewController {
            //Some property on ChildVC that needs to be set
            childVC.tableView.dataSource = self
            childVC.tableView.delegate = self
            childVC.tableView.reloadData()
            childView = childVC
          }
        }
            if segue.identifier == "addSingular" {
              if let childVC = segue.destination as? AddGoalViewController {
                //Some property on ChildVC that needs to be set
                childVC.mainSetGoalsView = self
              }
            }
    }
    

}

