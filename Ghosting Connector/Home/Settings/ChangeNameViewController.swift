//
//  changeNameViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/16/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
class ChangeNameViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var applyChangesButton: UIButton!
	@IBOutlet var nameField: UITextField!
	override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
		applyChangesButton.imageView?.contentMode = .scaleAspectFit
        nameField.attributedPlaceholder = NSAttributedString(string: "Your First Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          view.endEditing(true)
      }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
	// stops the user from typing space for a single word input
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if (string == " ") {
			return false
		}
		return true
	}
    @IBAction func applyChange(_ sender: Any) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Name")
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
            let name = Name(context: context)
            name.name = nameField.text!
        }
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        self.dismiss(animated: true, completion: nil)
    }
}
