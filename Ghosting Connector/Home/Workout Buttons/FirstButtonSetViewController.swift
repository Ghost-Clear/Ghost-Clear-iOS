//
//  FirstButtonSetViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/5/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class FirstButtonSetViewController: UIViewController {
	var parentView : WorkoutButtonsPageViewController!
	@IBOutlet weak var numberWorkoutButton: UIButton!
	@IBOutlet weak var timedWorkoutButton: UIButton!
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
	override func viewWillAppear(_ animated: Bool) {
		timedWorkoutButton.contentMode = .scaleAspectFit
		numberWorkoutButton.contentMode = .scaleAspectFit
	}
	@IBAction func timedWorkout(_ sender: Any) {
		self.parentView.parentView.performSegue(withIdentifier: "ChooseTimedWorkoutAttributesViewControllerSegue", sender: nil)
	}
	@IBAction func numberWorkout(_ sender: Any) {
		self.parentView.parentView.performSegue(withIdentifier: "ChooseNumberWorkoutAttributesViewControllerSegue", sender: nil)
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
