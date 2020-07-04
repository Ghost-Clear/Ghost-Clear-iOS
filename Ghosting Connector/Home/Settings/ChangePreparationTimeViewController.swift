//
//  ChangePreperationViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/29/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
class ChangePreparationTimeViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var applyChangesButton: UIButton!
	@IBOutlet weak var minutesLabel: UITextField!
	@IBOutlet weak var secondsLabel: UITextField!
	override func viewDidLoad() {
        super.viewDidLoad()
		applyChangesButton.imageView?.contentMode = .scaleAspectFit
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
			})
			alertVC.addAction(action)
			self.present(alertVC, animated: true, completion: nil)
			}
		else if (secondsLabel.text! as NSString).integerValue < 5 && (minutesLabel.text! as NSString).integerValue == 0{
			let alertVC = UIAlertController(title: "Values not in range", message: "Make sure that your perperation time is at least 5 seconds.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
				alertVC.dismiss(animated: true, completion: nil)
			})
			alertVC.addAction(action)
			self.present(alertVC, animated: true, completion: nil)
		}
		else{
		// deletes all preperation time data and initializes a new one
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PrepTime")
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
	}
}
