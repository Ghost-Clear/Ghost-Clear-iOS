//
//  ChooseNumberedWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/24/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class ChooseNumberWorkoutPatternViewController: UIViewController {
	var isFL = false
	var isFR = false
	var isCR = false
	var isCL = false
	var isLL = false
	var isLR = false
	var FLcount = 0
	var FRcount = 0
	var CLcount = 0
	var CRcount = 0
	var LLcount = 0
	var LRcount = 0
	var isRandomized = true
	var minutesOff : Int!
	var secondsOff : Int!
	var numSets: Int!
	var numGhosts : Int!
	var count = 0
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var startGhostButton: UIButton!
	@IBOutlet weak var gridImage: UIImageView!
	@IBOutlet var frontRight: UIButton!
	@IBOutlet var frontLeft: UIButton!
	@IBOutlet var lowerLeft: UIButton!
	@IBOutlet var centerLeft: UIButton!
	@IBOutlet var centerRight: UIButton!
	@IBOutlet var lowerRight: UIButton!
	@IBOutlet weak var orderLabel: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
		resetButton.imageView?.contentMode = .scaleAspectFit
		startGhostButton.imageView?.contentMode = .scaleAspectFit
		gridImage.image = UIImage(named: "000000")
		if isRandomized{
			orderLabel.isHidden = true
		}
		else{
			orderLabel.isHidden = false
			orderLabel.text = ""
		}
    }
	func redoNumbers(number : Int){
		if isFL && FLcount > number {
			FLcount -= 1
		}
		if isFR && FRcount > number{
			FRcount -= 1
		}
		if isCR && CRcount > number{
			CRcount -= 1
		}
		if isCL && CLcount > number{
			CLcount -= 1
		}
		if isLL && LLcount > number{
			LLcount -= 1
		}
		if isLR && LRcount > number{
			LRcount -= 1
		}
	}
	func getImageBinaryName() -> String{
		var toReturn = ""
		if isLR{
			toReturn += "1"
		}
		else{
			toReturn += "0"
		}
		if isLL{
			toReturn += "1"
		}
		else{
			toReturn += "0"
		}
		if isCR{
			toReturn += "1"
		}
		else{
			toReturn += "0"
		}
		if isCL{
			toReturn += "1"
		}
		else{
			toReturn += "0"
		}
		if isFR{
			toReturn += "1"
		}
		else{
			toReturn += "0"
		}
		if isFL{
			toReturn += "1"
		}
		else{
			toReturn += "0"
		}
		return toReturn
	}
	@IBAction func resetSelection(_ sender: Any) {
		let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
		impactFeedbackgenerator.prepare()
		impactFeedbackgenerator.impactOccurred()
		isFR = false
		isFL = false
		isCR = false
		isCL = false
		isLR = false
		isLL = false
		gridImage.image = UIImage(named: "000000")
		orderLabel.text = ""
		count = 0
	}
	@IBAction func FL(_ sender: Any) {
		let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .rigid)
		impactFeedbackgenerator.prepare()
		impactFeedbackgenerator.impactOccurred()
		if isFL{
			isFL = false
			count -= 1
			redoNumbers(number: FLcount)
			FLcount = 0
		}
		else{
			isFL = true
			count += 1
			if !isRandomized{
				FLcount = count
			}
			}
		let getImage : String! = getImageBinaryName()
		gridImage.image = UIImage(named: getImage)
		if count != 0{
			orderLabel.text = getOrderLabel()
		}
		else{
			orderLabel.text = ""
		}
	}
	@IBAction func FR(_ sender: Any) {
		let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .rigid)
		impactFeedbackgenerator.prepare()
		impactFeedbackgenerator.impactOccurred()
		if isFR{
			isFR = false
			count -= 1
			redoNumbers(number: FRcount)
			FRcount = 0
		}
		else{
			isFR = true
			count += 1
			if !isRandomized{
				FRcount = count
			}
		}
		let getImage : String! = getImageBinaryName()
		gridImage.image = UIImage(named: getImage)
		if count != 0{
			orderLabel.text = getOrderLabel()
		}
		else{
			orderLabel.text = ""
		}
	}
	@IBAction func CL(_ sender: Any) {
		let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .rigid)
		impactFeedbackgenerator.prepare()
		impactFeedbackgenerator.impactOccurred()
		if isCL{
			isCL = false
			count -= 1
			redoNumbers(number: CLcount)
			CLcount = 0
		}
		else{
			isCL = true
			count += 1
			if !isRandomized{
				CLcount = count
			}
		}
		let getImage : String! = getImageBinaryName()
		gridImage.image = UIImage(named: getImage)
		if count != 0{
			orderLabel.text = getOrderLabel()
		}
		else{
			orderLabel.text = ""
		}
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	@IBAction func LL(_ sender: Any) {
		let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .rigid)
		impactFeedbackgenerator.prepare()
		impactFeedbackgenerator.impactOccurred()
		if isLL{
			isLL = false
			count -= 1
			redoNumbers(number: LLcount)
			LLcount = 0
		}
		else{
			isLL = true
			count += 1
			if !isRandomized{
				LLcount = count
			}
		}
		let getImage : String! = getImageBinaryName()
		gridImage.image = UIImage(named: getImage)
		if count != 0{
			orderLabel.text = getOrderLabel()
		}
		else{
			orderLabel.text = ""
		}
	}
	@IBAction func CR(_ sender: Any) {
		let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .rigid)
		impactFeedbackgenerator.prepare()
		impactFeedbackgenerator.impactOccurred()
		if isCR{
			isCR = false
			count -= 1
			redoNumbers(number: CRcount)
			CRcount = 0
		}
		else{
			isCR = true
			count += 1
			if !isRandomized{
				CRcount = count
			}
		}
		let getImage : String! = getImageBinaryName()
		gridImage.image = UIImage(named: getImage)
		if count != 0{
			orderLabel.text = getOrderLabel()
		}
		else{
			orderLabel.text = ""
		}
	}
	@IBAction func LR(_ sender: Any) {
		let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .rigid)
		impactFeedbackgenerator.prepare()
		impactFeedbackgenerator.impactOccurred()
		if isLR{
			isLR = false
			count -= 1
			redoNumbers(number: LRcount)
			LRcount = 0
		}
		else{
			isLR = true
			count += 1
			if !isRandomized{
				LRcount = count
			}
		}
		let getImage : String! = getImageBinaryName()
		gridImage.image = UIImage(named: getImage)
		if count != 0{
			orderLabel.text = getOrderLabel()
		}
		else{
			orderLabel.text = ""
		}
	}
	@IBAction func startGhost(_ sender: Any) {
		if !isFR && !isFL && !isCR && !isCL && !isLR && !isLL{
			let alertVC = UIAlertController(title: "Invalid Pattern", message: "Make sure that you choose at least 1 place to ghost to.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
				self.dismiss(animated: true, completion: nil)
			})
			alertVC.addAction(action)
			self.present(alertVC, animated: true, completion: nil)
		}
		else{
			performSegue(withIdentifier: "DoNumberWorkoutViewControllerSegue", sender: nil)
		}
	}
	@IBAction func goBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	func getOrderLabel() -> String{
		let o = getOrderArr()
		var toReturn = ""
		var count = 1
		for i in o{
			if i == "FR"{
				toReturn += String(count) + ". " + "Front Right" + " "
			}
			if i == "FL"{
				toReturn += String(count) + ". " + "Front Left" + " "
			}
			if i == "CR"{
				toReturn += String(count) + ". " + "Center Right" + " "
			}
			if i == "CL"{
				toReturn += String(count) + ". " + "Center Left" + " "
			}
			if i == "LR"{
				toReturn += String(count) + ". " + "Back Right" + " "
			}
			if i == "LL"{
				toReturn += String(count) + ". " + "Back Left" + " "
			}
			count += 1
		}
		return toReturn
	}
	func getOrderArr() -> [String]{
		var order : [String]! = []
		for _ in 0...count-1 {
			order.append("")
		}
		if !isRandomized{
			if isFR{
				order[FRcount-1] = "FR"
			}
			if isFL{
				order[FLcount-1] = "FL"
			}
			if isCL{
				order[CLcount-1] = "CL"
			}
			if isCR{
				order[CRcount-1] = "CR"
			}
			if isLR{
				order[LRcount-1] = "LR"
			}
			if isLL{
				order[LLcount-1] = "LL"
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
				order[which] = "CL"
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
		return order
	}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "DoNumberWorkoutViewControllerSegue" {
			if let childVC = segue.destination as? DoNumberWorkoutViewController {
				childVC.numSets = numSets
				childVC.numMinutesOn = 0
				childVC.numMinutesOff = minutesOff
				childVC.isRandom = isRandomized
				childVC.numSecondsOff = secondsOff
				childVC.numSecondsOn = 0
				childVC.FR = isFR
				childVC.FL = isFL
				childVC.CR = isCR
				childVC.CL = isCL
				childVC.LR = isLR
				childVC.LL = isLL
				childVC.ghostsToDo = numGhosts
				var o : [String]! = []
				o = getOrderArr()
				print(o!)
				childVC.order = o
			}
		}
    }
}
