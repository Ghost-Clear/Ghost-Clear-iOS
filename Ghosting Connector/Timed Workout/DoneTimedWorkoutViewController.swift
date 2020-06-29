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
    override func viewDidLoad() {
        super.viewDidLoad()
		var hours : Int! = 0
		if secondsOn >= 60{
			minutesOn += secondsOn % 60
			secondsOn -= (secondsOn % 60) * 60
		}
		if minutesOn >= 60{
			hours = minutesOn % 60
			minutesOn -= (minutesOn % 60) * 60
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
		for i in ghostedCorners{
			ghostedCornersLabel.text! += i + " "
		}
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
