//
//  ViewSingularGoalViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/1/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import  M13Checkbox
import CoreData
class InitialViewGoalViewController: UIViewController {
	var viewingGoal : Goal!	
	@IBOutlet weak var setField: UILabel!
	@IBOutlet weak var ghostsField: UILabel!
	@IBOutlet weak var minutesOnField: UILabel!
	@IBOutlet weak var secondsOnField: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		secondsOnField.text = String(viewingGoal.seconds)
		minutesOnField.text = String(viewingGoal.minutes)
		setField.text = String(viewingGoal.sets)
		ghostsField.text = String(viewingGoal.ghosts)		
	}
}
