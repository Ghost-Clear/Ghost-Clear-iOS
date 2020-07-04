//
//  HowToConnectViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/16/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
class BluetoothGuideViewController: UIViewController {
	@IBOutlet weak var resetButton: UIButton!
	override func viewDidLoad() {
        super.viewDidLoad()
		resetButton.imageView?.contentMode = .scaleAspectFit
    }
    @IBAction func refresh(_ sender: Any) {
		// deletes all Bluetooth device information from Core Data
		let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
		notificationFeedbackGenerator.prepare()
		notificationFeedbackGenerator.notificationOccurred(.success)
		resetAllRecords(in: "BLEkey");
		let alertVC = UIAlertController(title: "Bluetooth reset", message: "Your bluetooth information has successfully been reset.", preferredStyle: UIAlertController.Style.alert)
		let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
			alertVC.dismiss(animated: true, completion: nil)
			self.dismiss(animated: true, completion: nil)
		})
		alertVC.addAction(action)
		self.present(alertVC, animated: true, completion: nil)
    }
	func resetAllRecords(in entity : String)
	{
		let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
		do
		{
			try context.execute(deleteRequest)
			try context.save()
		}
		catch
		{
			print ("There was an error")
		}
	}
}
