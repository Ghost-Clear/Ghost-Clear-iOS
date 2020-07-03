//
//  ChangePreperationViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/29/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
class ChangePreperationTimeViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var applyChangesButton: UIButton!
	override func viewDidLoad() {
        super.viewDidLoad()
		applyChangesButton.imageView?.contentMode = .scaleAspectFit
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
		if secondsLabel.text == ""{
			secondsLabel.text = "0"
		}
		if minutesLabel.text == ""{
			minutesLabel.text = "0"
		}
	}
	func textFieldDidEndEditing(_ textField: UITextField) {
		if secondsLabel.text == ""{
			secondsLabel.text = "0"
		}
		if minutesLabel.text == ""{
			minutesLabel.text = "0"
		}
	}
	@objc func keyboardWillHide(notification: NSNotification) {
		if secondsLabel.text == ""{
			secondsLabel.text = "0"
		}
		if minutesLabel.text == ""{
			minutesLabel.text = "0"
		}
	}
	@IBOutlet weak var minutesLabel: UITextField!
	@IBOutlet weak var secondsLabel: UITextField!
	
	@IBAction func minutesTapped(_ sender: Any) {
		if secondsLabel.text == ""{
			secondsLabel.text = "0"
		}
	}
	@IBAction func secondsTapped(_ sender: Any) {
		if minutesLabel.text == ""{
			minutesLabel.text = "0"
		}
	}
	@IBAction func applyChanges(_ sender: Any) {
		if minutesLabel.text == "" || secondsLabel.text == "" || (secondsLabel.text! as NSString).integerValue > 59 || (minutesLabel.text! as NSString).integerValue > 59{
			let alertVC = UIAlertController(title: "Values not in range", message: "Make sure that your minutes and seconds are between 0 and 59.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
				alertVC.dismiss(animated: true, completion: nil)
				//add segue
			})
			alertVC.addAction(action)
			self.present(alertVC, animated: true, completion: nil)
			}
		else if (secondsLabel.text! as NSString).integerValue <= 5 && (minutesLabel.text! as NSString).integerValue == 0{
			let alertVC = UIAlertController(title: "Values not in range", message: "Make sure that your perperation time is at least 5 seconds.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
				alertVC.dismiss(animated: true, completion: nil)
				//add segue
			})
			alertVC.addAction(action)
			self.present(alertVC, animated: true, completion: nil)
		}
		else{
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PrepTime")
		
		// Configure Fetch Request
		fetchRequest.includesPropertyValues = false
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			do {
				let items = try context.fetch(fetchRequest) as! [NSManagedObject]
				
				for item in items {
					context.delete(item)
				}
				
				
				try context.save()
				
			} catch {
				
			}
		}
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			let prep = PrepTime(context: context)
			prep.minutes = Int16((minutesLabel.text! as NSString).integerValue)
			prep.seconds = Int16((secondsLabel.text! as NSString).integerValue)
		}
		(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
		self.dismiss(animated: true, completion: nil)
		}
		// Configure Fetch Request
		
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
