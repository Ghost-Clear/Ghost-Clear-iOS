//
//  NumberedWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/10/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreBluetooth
class NumberedWorkoutViewController: UIViewController, UITextFieldDelegate {
    var isRandomized = true
    
	@IBOutlet weak var setsField: UITextField!
	@IBOutlet weak var ghostsField: UITextField!
	@IBOutlet weak var secondsOff: UITextField!
	@IBOutlet weak var minutesOff: UITextField!
	@IBOutlet var blankRandomize: UIButton!
    @IBAction func unRandomize(_ sender: Any) {
        isRandomized = true
        blankRandomize.isHidden = true
        randomizeButton.isHidden = false
        print(isRandomized)
    }
    
	@IBAction func setFieldSelected(_ sender: Any) {
		if ghostsField.text == ""{
			ghostsField.text = "0"
		}
		if setsField.text == ""{
			setsField.text = "0"
		}
		if minutesOff.text == ""{
			minutesOff.text = "0"
		}
		if secondsOff.text == ""{
			secondsOff.text = "0"
		}
		setsField.text = ""
	}
	
	@IBAction func ghostFieldSelected(_ sender: Any) {
		if ghostsField.text == ""{
			ghostsField.text = "0"
		}
		if setsField.text == ""{
			setsField.text = "0"
		}
		if minutesOff.text == ""{
			minutesOff.text = "0"
		}
		if secondsOff.text == ""{
			secondsOff.text = "0"
		}
		ghostsField.text = ""
	}
	@IBAction func minutesOffFieldSelected(_ sender: Any) {
		if ghostsField.text == ""{
			ghostsField.text = "0"
		}
		if setsField.text == ""{
			setsField.text = "0"
		}
		if minutesOff.text == ""{
			minutesOff.text = "0"
		}
		if secondsOff.text == ""{
			secondsOff.text = "0"
		}
		minutesOff.text = ""
	}
	@IBAction func secondsOffFieldSelected(_ sender: Any) {
		if ghostsField.text == ""{
			ghostsField.text = "0"
		}
		if setsField.text == ""{
			setsField.text = "0"
		}
		if minutesOff.text == ""{
			minutesOff.text = "0"
		}
		if secondsOff.text == ""{
			secondsOff.text = "0"
		}
		secondsOff.text = ""
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if ghostsField.text == ""{
			ghostsField.text = "0"
		}
		if setsField.text == ""{
			setsField.text = "0"
		}
		if minutesOff.text == ""{
			minutesOff.text = "0"
		}
		if secondsOff.text == ""{
			secondsOff.text = "0"
		}
	}
	@IBOutlet var randomizeButton: UIButton!
    @IBAction func randomize(_ sender: Any) {
        isRandomized = false
        blankRandomize.isHidden = false
        randomizeButton.isHidden = true
        print(isRandomized)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        blankRandomize.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Do any additional setup after loading the view.
    }
	@objc func keyboardWillHide(notification: NSNotification) {
		if self.view.frame.origin.y != 0 {
			self.view.frame.origin.y = 0
		}
		if ghostsField.text == ""{
			ghostsField.text = "0"
		}
		if setsField.text == ""{
			setsField.text = "0"
		}
		if minutesOff.text == ""{
			minutesOff.text = "0"
		}
		if secondsOff.text == ""{
			secondsOff.text = "0"
		}
	}
	@objc func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0 {
				self.view.frame.origin.y -= (keyboardSize.height - 130)
			}
		}
	}
			
	@IBAction func choosePattern(_ sender: Any) {
		if(((secondsOff.text! as NSString).integerValue) < 60 && ((secondsOff.text! as NSString).integerValue) >= 0 && ((minutesOff.text! as NSString).integerValue) < 60 && ((minutesOff.text! as NSString).integerValue) >= 0 && secondsOff.text! != "" && minutesOff.text! != "" && setsField.text != "" && setsField.text != "0" && ghostsField.text != "0"){
			performSegue(withIdentifier: "chooseNumberedPattern", sender: nil)
		}
		else{
			let alertVC = UIAlertController(title: "Values not in range", message: "Make sure that your minutes and seconds are between 0 and 59 and your ghosts and sets are greater than 0.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
				alertVC.dismiss(animated: true, completion: nil)
				//add segue
			})
			alertVC.addAction(action)
			self.present(alertVC, animated: true, completion: nil)
		}
	}
	
    
    
    
    
    
        // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "chooseNumberedPattern" {
			if let childVC = segue.destination as? ChooseNumberedWorkoutViewController {
				//Some property on ChildVC that needs to be set
				childVC.numSets = (setsField.text! as NSString).integerValue
				childVC.numGhosts = (ghostsField.text! as NSString).integerValue
				childVC.isRandomized = isRandomized
				childVC.minutesOff = (minutesOff.text! as NSString).integerValue
				childVC.secondsOff = (secondsOff.text! as NSString).integerValue
			}
		}
    }
    

}
