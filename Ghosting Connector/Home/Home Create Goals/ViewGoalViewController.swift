//
//  ViewGoalViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/1/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
import M13Checkbox
class ViewGoalViewController: UIViewController {
	var viewingGoal : Goal!
	@IBOutlet weak var checkBox: M13Checkbox!
	@IBOutlet weak var setField: UILabel!
	@IBOutlet weak var ghostsField: UILabel!
	@IBOutlet weak var minutesOnField: UILabel!
	@IBOutlet weak var secondsOnField: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
		checkBox.isEnabled = false
		checkBox.animationDuration = 1
		secondsOnField.text = String(viewingGoal.seconds)
		minutesOnField.text = String(viewingGoal.minutes)
		setField.text = String(viewingGoal.sets)
		ghostsField.text = String(viewingGoal.ghosts)
		checkBox.checkmarkLineWidth = 5.0
		checkBox.boxLineWidth = 5.0
		
    }
	override func viewWillAppear(_ animated: Bool) {
		if !viewingGoal.isCompleted{
			checkBox.setCheckState(.mixed, animated: true)
			checkBox.tintColor = UIColor(red: 255/256, green: 61/256, blue: 83/256, alpha: 1)
		}
		else{
			checkBox.setCheckState(.checked, animated: true)
			checkBox.tintColor = UIColor(red: 26/256, green: 230/256, blue: 100/256, alpha: 1)
		}
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
