//
//  InitialLoginViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/8/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreBluetooth
class InitialPageViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var nameTextField: UITextField!
	@objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
    }
	// stops the user from typing space for a single word input
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if (string == " ") {
			return false
		}
		return true
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		nextButton.imageView?.contentMode = .scaleAspectFit
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Your First Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        nameTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func continueFromLoginbutton(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let name = Name(context: context)
            name.name = nameTextField.text
        }
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
