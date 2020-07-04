//
//  CircularProgressViewControllerViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/2/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import M13Checkbox
class TimedWorkoutConnectionProgressViewControllerViewController: UIViewController {
	@IBOutlet var circleView : CircularProgressView!
	@IBOutlet weak var checkBox: M13Checkbox!
	@IBOutlet weak var containingView: UIView!
	@IBOutlet weak var connectionLabel: UILabel!
	var parentView : DoTimedWorkoutViewController!
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	override func viewWillAppear(_ animated: Bool) {
		connectionLabel.text = "Connecting"
		containingView.layer.cornerRadius = 30
		checkBox.isHidden = true
		circleView.trackColor = UIColor.clear
		circleView.progressColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
		circleView.setProgressWithAnimation(duration: 2.0, value: 1)
		checkBox.isEnabled = false
		checkBox.animationDuration = 1
		checkBox.checkmarkLineWidth = 5.0
		checkBox.boxLineWidth = 5.0
		DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
			self.checkBox.isHidden = false
			if (self.parentView.FR && self.parentView.FRPeripheral == nil) || (self.parentView.FL && self.parentView.FLPeripheral == nil) || (self.parentView.CR && self.parentView.CRPeripheral == nil) || (self.parentView.CL && self.parentView.CLPeripheral == nil) || (self.parentView.LR && self.parentView.LRPeripheral == nil) || (self.parentView.LL && self.parentView.LLPeripheral == nil){
				self.checkBox.tintColor = UIColor(red: 255/256, green: 61/256, blue: 83/256, alpha: 1)
				self.checkBox.setCheckState(.mixed, animated: true)
				self.parentView.didConnect = false
				self.checkBox.stateChangeAnimation = .bounce(.stroke)
				self.circleView.progressColor = UIColor(red: 255/256, green: 61/256, blue: 83/256, alpha: 1)
				let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
				notificationFeedbackGenerator.prepare()
				notificationFeedbackGenerator.notificationOccurred(.error)
				self.connectionLabel.text = "Connection Failed"
			}
			else{
				self.checkBox.tintColor = UIColor(red: 26/256, green: 230/256, blue: 100/256, alpha: 1)
				self.checkBox.setCheckState(.checked, animated: true)
				self.parentView.didConnect = true
				self.circleView.progressColor = UIColor(red: 26/256, green: 230/256, blue: 100/256, alpha: 1)
				let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
				notificationFeedbackGenerator.prepare()
				notificationFeedbackGenerator.notificationOccurred(.success)
				self.connectionLabel.text = "Connected To Devices"
			}
			
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 3.3) {
			self.dismiss(animated: true, completion: nil)
		}
	}
}
