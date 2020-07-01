//
//  DoneTimedWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/27/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class DoneTimedWorkoutViewController: UIViewController {
	var minutesOn : Int!
	var secondsOn : Int!
	var totalghosts : Int!
	var ghostedCorners : [String]!
	var numSets : Int!
	@IBOutlet weak var doneButton: UIButton!
	override func viewDidLoad() {
        super.viewDidLoad()
		doneButton.imageView?.contentMode = .scaleAspectFit
		var hours : Int! = 0
		if secondsOn >= 60{
			minutesOn += Int(secondsOn / 60)
			secondsOn -= Int(secondsOn / 60) * 60
		}
		if minutesOn >= 60{
			hours = Int(minutesOn / 60)
			minutesOn -= Int(minutesOn / 60) * 60
		}
		totalTimeLabel.text = String(hours) + " : " + String(minutesOn) + " : " + String(secondsOn)
		if numSets == 0{
			averageGhostsLabel.text = String(totalghosts)
		}
		else{
			averageGhostsLabel.text = String(totalghosts / numSets)
		}
		
		totalGhostsLabel.text = String(totalghosts)
		ghostedCornersLabel.text = ""
		var allCorners = ""
		for i in ghostedCorners{
			if i == "FR"{
				allCorners += "Front Right. "
			}
			if i == "FL"{
				allCorners += "Front Left. "
			}
			if i == "CR"{
				allCorners += "Center Right. "
			}
			if i == "CL"{
				allCorners += "Center Left. "
			}
			if i == "LR"{
				allCorners += "Back Right. "
			}
			if i == "LL"{
				allCorners += "Back Left. "
			}
		}
		
		ghostedCornersLabel.text = allCorners
		
        // Do any additional setup after loading the view.
    }
    
	@IBOutlet weak var ghostedCornersLabel: UILabel!
	@IBOutlet weak var totalGhostsLabel: UILabel!
	@IBOutlet weak var averageGhostsLabel: UILabel!
	@IBOutlet weak var totalTimeLabel: UILabel!
	@IBAction func done(_ sender: Any) {
		popBack(5)
	}
	
	func popBack(_ nb: Int) {
		
		if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
			guard viewControllers.count < nb else {
				self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
				return
			}
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
