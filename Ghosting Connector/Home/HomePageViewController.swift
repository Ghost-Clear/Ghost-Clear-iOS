//
//  HomePageViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/8/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import Charts
import CoreBluetooth
class HomePageViewController: UIViewController {
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var viewGoalsButton: UIButton!
	@IBOutlet weak var viewWorkoutButton: UIButton!
	@IBOutlet weak var chartPageControl: UIPageControl!
	var namesFromCore = [Name]()
    var name = ""
    var days: [String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    @IBOutlet weak var welcomeLabel: UILabel!
    var numWorkouts = [0,0,0,0,0,0,0]
    override func viewDidLoad() {
        super.viewDidLoad()
		viewGoalsButton.imageView?.contentMode = .scaleAspectFit
		viewWorkoutButton.imageView?.contentMode = .scaleAspectFit
    }
    override func viewWillAppear(_ animated: Bool) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let nameFromCore = try? context.fetch(Name.fetchRequest()){
                let allNamesFromCore = nameFromCore as! [Name]
                namesFromCore = allNamesFromCore
                if namesFromCore.count != 0{
                    welcomeLabel.text = "Welcome " + namesFromCore[0].name! + "!"
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsViewControllerSegue"{
           if let childVC = segue.destination as? SettingsViewController {
            childVC.homeController = self
            }
        }
		if segue.identifier == "WorkoutButtonsPageViewControllerSegue"{
			if let childVC = segue.destination as? WorkoutButtonsPageViewController {
				childVC.parentView = self
			}
		}
		if segue.identifier == "HomeChartPageViewControllerSegue"{
			if let childVC = segue.destination as? HomeChartPageViewController {
				childVC.parentView = self
			}
		}
    }
}

