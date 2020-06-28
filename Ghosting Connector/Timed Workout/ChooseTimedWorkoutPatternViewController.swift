//
//  ChooseTimedWorkoutPatternViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/24/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class ChooseTimedWorkoutPatternViewController: UIViewController {
	var isFL = false
	var isFR = false
	var isCR = false
	var isCL = false
	var isLL = false
	var isLR = false
	var numSets : Int!
	var isRandomized = true
	var offMinutes: Int!
	var onMinutes : Int!
	var offSeconds : Int!
	var onSeconds : Int!
	var count = 0
	@IBOutlet weak var FLLabel: UILabel!
	@IBOutlet weak var FRLabel: UILabel!
	@IBOutlet weak var CLLabel: UILabel!
	@IBOutlet weak var CRLabel: UILabel!
	@IBOutlet weak var LLLabel: UILabel!
	@IBOutlet weak var LRLabel: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
		frontRight.setBackgroundImage(nil, for: .normal)
		frontLeft.setBackgroundImage(nil, for: .normal)
		centerRight.setBackgroundImage(nil, for: .normal)
		centerLeft.setBackgroundImage(nil, for: .normal)
		lowerLeft.setBackgroundImage(nil, for: .normal)
		lowerRight.setBackgroundImage(nil, for: .normal)
		FLLabel.text = ""
		FRLabel.text = ""
		CLLabel.text = ""
		CRLabel.text = ""
		LLLabel.text = ""
		LRLabel.text = ""
		
        // Do any additional setup after loading the view.
    }
	func redoNumbers(number : Int){
		if frontLeft.currentBackgroundImage != nil && (FLLabel.text! as NSString).integerValue > number {
			FLLabel.text = String((FLLabel.text! as NSString).integerValue - 1)
		}
		if frontRight.currentBackgroundImage != nil && (FRLabel.text! as NSString).integerValue > number{
			FRLabel.text = String((FRLabel.text! as NSString).integerValue - 1)
		}
		if centerRight.currentBackgroundImage != nil && (CRLabel.text! as NSString).integerValue > number{
			CRLabel.text = String((CRLabel.text! as NSString).integerValue - 1)
		}
		if centerLeft.currentBackgroundImage != nil && (CLLabel.text! as NSString).integerValue > number{
			CLLabel.text = String((CLLabel.text! as NSString).integerValue - 1)
		}
		if lowerLeft.currentBackgroundImage != nil && (LLLabel.text! as NSString).integerValue > number{
			LLLabel.text = String((LLLabel.text! as NSString).integerValue - 1)
		}
		if lowerRight.currentBackgroundImage != nil && (LRLabel.text! as NSString).integerValue > number{
			LRLabel.text = String((LRLabel.text! as NSString).integerValue - 1)
		}
	}
	@IBAction func goBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	@IBOutlet var frontLeft: UIButton!
	@IBAction func FL(_ sender: Any) {
		if isFL{
			frontLeft.setBackgroundImage(nil, for: .normal)
			isFL = false
			count -= 1
			redoNumbers(number: (FLLabel.text! as NSString).integerValue)
			FLLabel.text = ""
		}
		else{
			isFL = true
			frontLeft.setBackgroundImage(UIImage(named: "Ellipse 15"), for: .normal)
			count += 1
			if !isRandomized{
				FLLabel.text = String(count)}
		}
	}
	@IBOutlet var frontRight: UIButton!
	
	@IBAction func resetSelection(_ sender: Any) {
		isFR = false
		isFL = false
		isCR = false
		isCL = false
		isLR = false
		isLL = false
		frontRight.setBackgroundImage(nil, for: .normal)
		frontLeft.setBackgroundImage(nil, for: .normal)
		centerRight.setBackgroundImage(nil, for: .normal)
		centerLeft.setBackgroundImage(nil, for: .normal)
		lowerLeft.setBackgroundImage(nil, for: .normal)
		lowerRight.setBackgroundImage(nil, for: .normal)
		FLLabel.text = ""
		FRLabel.text = ""
		CLLabel.text = ""
		CRLabel.text = ""
		LLLabel.text = ""
		LRLabel.text = ""
		
		count = 0
	}
	@IBAction func FR(_ sender: Any) {
		if isFR{
			frontRight.setBackgroundImage(nil, for: .normal)
			isFR = false
			count -= 1
			redoNumbers(number: (FRLabel.text! as NSString).integerValue)
			FRLabel.text = ""
		}
		else{
			isFR = true
			count += 1
			frontRight.setBackgroundImage(UIImage(named: "Ellipse 15"), for: .normal)
			if !isRandomized{
				FRLabel.text = String(count)}
		}
	}
	
	@IBAction func CL(_ sender: Any) {
		if isCL{
			centerLeft.setBackgroundImage(nil, for: .normal)
			isCL = false
			count -= 1
			redoNumbers(number: (CLLabel.text! as NSString).integerValue)
			CLLabel.text = ""
		}
		else{
			isCL = true
			centerLeft.setBackgroundImage(UIImage(named: "Ellipse 15"), for: .normal)
			count += 1
			if !isRandomized{
				CLLabel.text = String(count)}
		}
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	@IBOutlet var lowerLeft: UIButton!
	@IBOutlet var centerLeft: UIButton!
	@IBAction func LL(_ sender: Any) {
		if isLL{
			lowerLeft.setBackgroundImage(nil, for: .normal)
			count -= 1
			redoNumbers(number: (LLLabel.text! as NSString).integerValue)
			isLL = false
			LLLabel.text = ""
		}
		else{
			isLL = true
			lowerLeft.setBackgroundImage(UIImage(named: "Ellipse 15"), for: .normal)
			count += 1
			if !isRandomized{
				LLLabel.text = String(count)}
		}
	}
	
	
	@IBOutlet var centerRight: UIButton!
	@IBAction func CR(_ sender: Any) {
		if isCR{
			centerRight.setBackgroundImage(nil, for: .normal)
			isCR = false
			count -= 1
			redoNumbers(number: (CRLabel.text! as NSString).integerValue)
			CRLabel.text = ""
		}
		else{
			isCR = true
			centerRight.setBackgroundImage(UIImage(named: "Ellipse 15"), for: .normal)
			count += 1
			if !isRandomized{
				CRLabel.text = String(count)}
		}
	}
	
	
	
	
	@IBOutlet var lowerRight: UIButton!
	@IBAction func LR(_ sender: Any) {
		if isLR{
			lowerRight.setBackgroundImage(nil, for: .normal)
			isLR = false
			count -= 1
			redoNumbers(number: (LRLabel.text! as NSString).integerValue)
			LRLabel.text = ""
		}
		else{
			isLR = true
			lowerRight.setBackgroundImage(UIImage(named: "Ellipse 15"), for: .normal)
			count += 1
			if !isRandomized{
				LRLabel.text = String(count)}
		}
	}
	
	@IBAction func startGhost(_ sender: Any) {
		if !isFR && !isFL && !isCR && !isCL && !isLR && !isLL{
			let alertVC = UIAlertController(title: "Invalid Pattern", message: "MMakle sure that you choose atleast 1 place to ghost to.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
				self.dismiss(animated: true, completion: nil)
				//add segue
		
			})
			alertVC.addAction(action)
			self.present(alertVC, animated: true, completion: nil)
		}
		else{
			performSegue(withIdentifier: "startWorkout", sender: nil)
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
				var order : [String]! = []
				for _ in 0...count-1 {
					order.append("")
				}
				if !isRandomized{
					if FRLabel.text != "" && frontRight.currentBackgroundImage != nil{
						order[((FRLabel.text!) as NSString).integerValue-1] = "FR"
					}
					if FLLabel.text != "" && frontLeft.currentBackgroundImage != nil{
						order[((FLLabel.text!) as NSString).integerValue-1] = "FL"
					}
					if CLLabel.text != "" && centerLeft.currentBackgroundImage != nil{
						order[((CLLabel.text!) as NSString).integerValue-1] = "CL"
					}
					if CRLabel.text != "" && centerRight.currentBackgroundImage != nil{
						order[((CRLabel.text!) as NSString).integerValue-1] = "CR"
					}
					if LRLabel.text != "" && lowerRight.currentBackgroundImage != nil{
						order[((LRLabel.text!) as NSString).integerValue-1] = "LR"
					}
					if LLLabel.text != "" && lowerLeft.currentBackgroundImage != nil{
						order[((LLLabel.text!) as NSString).integerValue-1] = "LL"
					}
				}
				else {
					var which = 0
					if isFR{
						order[which] = "FR"
						which += 1
					}
					if isFL{
						order[which] = "FL"
						which += 1
					}
					if isCR{
						order[which] = "CR"
						which += 1
					}
					if isCL{
						order[which] = "Cl"
						which += 1
					}
					if isLR{
						order[which] = "LR"
						which += 1
					}
					if isLL{
						order[which] = "LL"
						which += 1
					}
				}
				print(order!)
				childVC.order = order
				
			}
		}
    }
    

}
