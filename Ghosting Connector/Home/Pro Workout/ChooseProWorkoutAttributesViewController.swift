//
//  ChooseProWorkoutAttributesViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/10/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class ChooseProWorkoutAttributesViewController: UIViewController {
	var chosenMatch : Match!
	@IBOutlet weak var matchNameLabel: UILabel!
	@IBOutlet weak var lengthOfMatchLabel: UILabel!
	@IBOutlet weak var numGamesLabel: UILabel!
	@IBOutlet weak var player1Button: UIButton!
	@IBOutlet weak var player2Button: UIButton!
	@IBOutlet weak var player1Name: UILabel!
	@IBOutlet weak var player2Name: UILabel!
	@IBOutlet weak var easyButton: UIButton!
	@IBOutlet weak var mediumButton: UIButton!
	@IBOutlet weak var hardButton: UIButton!
	@IBOutlet weak var proButton: UIButton!
	@IBOutlet weak var startGhostButton: UIButton!
	var player1Selected = true
	var difficulty = "easy"
	override func viewDidLoad() {
        super.viewDidLoad()
		player1Button.contentMode = .scaleAspectFit
		player2Button.contentMode = .scaleAspectFit
		easyButton.contentMode = .scaleAspectFit
		mediumButton.contentMode = .scaleAspectFit
		hardButton.contentMode = .scaleAspectFit
		proButton.contentMode = .scaleAspectFit
		startGhostButton.contentMode = .scaleAspectFit
		matchNameLabel.text = chosenMatch.matchName
		var minutes : Int! = 0
		var seconds : Int! = chosenMatch.totalTimeInSeconds
		var hours : Int! = 0
		if seconds >= 60{
			minutes += seconds / 60
			seconds -= minutes * 60
		}
		if minutes >= 60{
			hours += minutes / 60
			minutes -= hours * 60
		}
		lengthOfMatchLabel.text = " Est. Length of Match :        "
		lengthOfMatchLabel.text! += String(hours) + " : "
		lengthOfMatchLabel.text! += String(minutes) +  " : " + String(seconds)
		numGamesLabel.text = "Number of Games :        "
		numGamesLabel.text! += String(chosenMatch.numGames)
		player1Name.text = chosenMatch.player1Name
		player2Name.text = chosenMatch.player2Name
		if chosenMatch.player1Nationality == "egypt"{
			player1Button.setImage(UIImage(named: "selectedEgypt"), for: .normal)
		}
		if chosenMatch.player2Nationality == "egypt"{
			player2Button.setImage(UIImage(named: "unselectedEgypt"), for: .normal)
		}
    }
	@IBAction func goBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func player1Select(_ sender: Any) {
		player1Selected = true
		if chosenMatch.player1Nationality == "egypt"{
		player1Button.setImage(UIImage(named: "selectedEgypt"), for: .normal)
		}
		else if chosenMatch.player1Nationality == "france"{
			player1Button.setImage(UIImage(named: "selectedFrance"), for: .normal)
		}
		if chosenMatch.player2Nationality == "egypt"{
			player2Button.setImage(UIImage(named: "unselectedEgypt"), for: .normal)
		}
		else if chosenMatch.player2Nationality == "france"{
			player2Button.setImage(UIImage(named: "unselectedFrance"), for: .normal)
		}
	}
	@IBAction func player2Select(_ sender: Any) {
		player1Selected = false
		if chosenMatch.player2Nationality == "egypt"{
			player2Button.setImage(UIImage(named: "selectedEgypt"), for: .normal)
		}
		else if chosenMatch.player2Nationality == "france"{
			player2Button.setImage(UIImage(named: "selectedFrance"), for: .normal)
		}
		if chosenMatch.player1Nationality == "egypt"{
			player1Button.setImage(UIImage(named: "unselectedEgypt"), for: .normal)
		}
		else if chosenMatch.player1Nationality == "france"{
			player1Button.setImage(UIImage(named: "unselectedFrance"), for: .normal)
		}
	}
	@IBAction func easy(_ sender: Any) {
		difficulty = "easy"
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		easyButton.setImage(UIImage(named: "fullEasy"), for: .normal)
		mediumButton.setImage(UIImage(named: "blankMedium"), for: .normal)
		hardButton.setImage(UIImage(named: "blankHard"), for: .normal)
		proButton.setImage(UIImage(named: "blankPro"), for: .normal)
	}
	@IBAction func medium(_ sender: Any) {
		difficulty = "medium"
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		easyButton.setImage(UIImage(named: "blankEasy"), for: .normal)
		mediumButton.setImage(UIImage(named: "fullMedium"), for: .normal)
		hardButton.setImage(UIImage(named: "blankHard"), for: .normal)
		proButton.setImage(UIImage(named: "blankPro"), for: .normal)
	}
	@IBAction func hard(_ sender: Any) {
		difficulty = "hard"
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		easyButton.setImage(UIImage(named: "blankEasy"), for: .normal)
		mediumButton.setImage(UIImage(named: "blankMedium"), for: .normal)
		hardButton.setImage(UIImage(named: "fullHard"), for: .normal)
		proButton.setImage(UIImage(named: "blankPro"), for: .normal)
	}
	@IBAction func pro(_ sender: Any) {
		difficulty = "pro"
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		easyButton.setImage(UIImage(named: "blankEasy"), for: .normal)
		mediumButton.setImage(UIImage(named: "blankMedium"), for: .normal)
		hardButton.setImage(UIImage(named: "blankHard"), for: .normal)
		proButton.setImage(UIImage(named: "fullPro"), for: .normal)
	}
	@IBAction func startGhost(_ sender: Any) {
		performSegue(withIdentifier: "DoProWorkoutViewControllerSegue", sender: nil)
	}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "DoProWorkoutViewControllerSegue" {
			if let childVC = segue.destination as? DoProWorkoutViewController {
				childVC.chosenMatch = chosenMatch
				childVC.isPlayer1 = player1Selected
				childVC.difficulty = difficulty
			}
		}
    }
    

}
