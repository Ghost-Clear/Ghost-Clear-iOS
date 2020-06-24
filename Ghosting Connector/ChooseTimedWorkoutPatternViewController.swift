//
//  ChooseTimedWorkoutPatternViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/24/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class ChooseTimedWorkoutPatternViewController: UIViewController {
	var isFL = true
	var isFR = true
	var isCR = true
	var isCL = true
	var isLL = true
	var isLR = true
	var numSets : Int!
	var isRandomized : Bool!
	var offMinutes: Int!
	var onMinutes : Int!
	var offSeconds : Int!
	var onSeconds : Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	@IBAction func goBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	@IBOutlet var frontLeft: UIButton!
	@IBAction func FL(_ sender: Any) {
		if isFL{
			frontLeft.setImage(nil, for: .normal)
			isFL = false
		}
		else{
			isFL = true
			frontLeft.setImage(UIImage(named: "Ellipse 15"), for: .normal)
		}
	}
	@IBOutlet var frontRight: UIButton!
	
	@IBAction func FR(_ sender: Any) {
		if isFR{
			frontRight.setImage(nil, for: .normal)
			isFR = false
		}
		else{
			isFR = true
			frontRight.setImage(UIImage(named: "Ellipse 15"), for: .normal)
		}
	}
	
	@IBAction func CL(_ sender: Any) {
		if isCL{
			centerLeft.setImage(nil, for: .normal)
			isCL = false
		}
		else{
			isCL = true
			centerLeft.setImage(UIImage(named: "Ellipse 15"), for: .normal)
		}
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	@IBOutlet var lowerLeft: UIButton!
	@IBOutlet var centerLeft: UIButton!
	@IBAction func LL(_ sender: Any) {
		if isLL{
			lowerLeft.setImage(nil, for: .normal)
			isLL = false
		}
		else{
			isLL = true
			lowerLeft.setImage(UIImage(named: "Ellipse 15"), for: .normal)
		}
	}
	
	
	@IBOutlet var centerRight: UIButton!
	@IBAction func CR(_ sender: Any) {
		if isCR{
			centerRight.setImage(nil, for: .normal)
			isCR = false
		}
		else{
			isCR = true
			centerRight.setImage(UIImage(named: "Ellipse 15"), for: .normal)
		}
	}
	
	
	
	
	@IBOutlet var lowerRight: UIButton!
	@IBAction func LR(_ sender: Any) {
		if isLR{
			lowerRight.setImage(nil, for: .normal)
			isLR = false
		}
		else{
			isLR = true
			lowerRight.setImage(UIImage(named: "Ellipse 15"), for: .normal)
		}
	}
	


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "startWorkout" {
			if let childVC = segue.destination as? DoTimedWorkoutViewController {
				//Some property on ChildVC that needs to be set
				childVC.numSets = numSets
				childVC.numMinutesOn = onMinutes
				childVC.numMinutesOff = offMinutes
				childVC.isRandom = isRandomized
				childVC.numSecondsOff = offSeconds
				childVC.numSecondsOn = onSeconds
				childVC.FR = isFR
				childVC.FL = isFL
				childVC.CR = isCR
				childVC.CL = isCL
				childVC.LR = isLR
				childVC.LL = isLL
			}
		}
    }
    

}
