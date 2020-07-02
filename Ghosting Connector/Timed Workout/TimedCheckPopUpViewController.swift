//
//  TimedCheckPopUpViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/2/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import M13Checkbox
class TimedCheckPopUpViewController: UIViewController {
	@IBOutlet weak var checkBoxContainingView: UIView!
	@IBOutlet weak var checkBox: M13Checkbox!
	override func viewDidLoad() {
        super.viewDidLoad()
		checkBox.isEnabled = false
		checkBox.tintColor = UIColor(red: 26/256, green: 230/256, blue: 100/256, alpha: 1)
		checkBox.animationDuration = 1
		checkBox.checkmarkLineWidth = 5.0
		checkBox.boxLineWidth = 5.0
		let seconds = 1.5
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
			// Put your code which should be executed with a delay here
			self.dismiss(animated: true, completion: nil)
		}
        // Do any additional setup after loading the view.
		
    }
	override func viewWillAppear(_ animated: Bool) {
		checkBoxContainingView.layer.cornerRadius = 30
		checkBox.setCheckState(.checked, animated: true)
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
