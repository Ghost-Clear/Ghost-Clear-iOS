//
//  SettingsViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/16/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
class SettingsViewController: UIViewController {
    var homeController: HomePageViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        homeController.reloadInputViews()
    }
	@IBAction func changeYourName(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	@IBAction func Bluetooth(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	@IBAction func preparationTime(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
}
