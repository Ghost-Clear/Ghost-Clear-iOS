//
//  CreateSingularGoalViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/8/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth
class CreateSingularGoalViewController: UIViewController, UITextFieldDelegate {
    var mainSetGoalsView: SetYourGoalsViewController!
    var numGhosts = 0
    var numMinutes = 0
    var numSeconds = 0
    var goalArray = [Goal]()
    @IBOutlet weak var numGhostsField: UITextField!
    @IBOutlet weak var numMinutesField: UITextField!
    @IBOutlet weak var numSecondsField: UITextField!
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
               self.view.addGestureRecognizer(tapGesture)
               numGhostsField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
           numGhostsField.resignFirstResponder()
       }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height - 20)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @IBAction func addGoal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let goal = Goal(context: context)
            goal.seconds = Int64((numSecondsField.text! as NSString).integerValue)
            goal.minutes = Int64((numMinutesField.text! as NSString).integerValue)
            goal.ghosts = Int64((numGhostsField.text! as NSString).integerValue)
            goal.isCompleted = false 
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                if let goalsFromCore = try? context.fetch(Goal.fetchRequest()){
                    let goalFromCore = goalsFromCore as! [Goal]
                    goalArray = goalFromCore
                }
                
            }
            goal.order = Int64(goalArray.count+1)
        }
        //let finalData = joke()
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        mainSetGoalsView.getGoals()
        mainSetGoalsView.childView?.tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
