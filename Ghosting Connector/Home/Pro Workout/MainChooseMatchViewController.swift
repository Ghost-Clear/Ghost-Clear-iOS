//
//  MainChooseMatchViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/9/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//
class match{
	init(pointTimings: [[Double]], player1Places: [[String]], player2Places: [[String]], numGames: Int, totalTimeInSeconds: Int, matchName: String, player1Name: String, player2Name: String, player1Nationality: String, player2Nationality: String) {
		self.pointTimings = pointTimings
		self.player1Places = player1Places
		self.player2Places = player2Places
		self.numGames = numGames
		self.totalTimeInSeconds = totalTimeInSeconds
		self.matchName = matchName
		self.player1Name = player1Name
		self.player2Name = player2Name
		self.player1Nationality = player1Nationality
		self.player2Nationality = player2Nationality
	}
	
	let pointTimings : [[Double]]
	let player1Places : [[String]]
	let player2Places : [[String]]
	let numGames : Int
	let totalTimeInSeconds : Int
	let matchName : String
	let player1Name : String
	let player2Name : String
	let player1Nationality : String
	let player2Nationality : String
	
}
import UIKit
class MainChooseMatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath)

		
		return cell
	}
	

	@IBAction func goBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		let nSuite2019Final = match(pointTimings: [[8.7,25.7,18.7,9,4,39.7,14.7,5.7,38.2,34.4,10.2,11.2,21.4,4.95,25.9,2.7,16.2],[40.2, 17.2, 25.7, 27.7, 15.7, 21.7, 11.7, 4.7, 9.7, 7.2, 8.2, 29.4, 2.7, 21.7, 16.7, 4.2, 22.2, 28.7, 24, 30.5, 26.2, 6.7, 40.2, 50.7, 14.1, 24.5, 62.7, 9.6],[11, 29.5, 16.7, 20.4, 32.2, 14.5, 30.9, 10.4, 6.4, 11.8, 11.8, 6.85, 19.9, 5.2, 20.7, 8.4, 12.7, 40, 8.7, 36.5],[44.7, 7.1, 6.7, 16, 21.2, 10.1, 10.7, 13, 13.7, 28.2, 21.7, 32.2, 15.9, 24.2, 87.7, 11.7, 8.7, 14.7],[11.93, 7.7, 13, 29.7, 8, 7.4, 22, 63.7, 20.4, 42.4, 23,4, 6.7, 14.7, 12.7, 10.4, 24.7]], player1Places: [["CR", "LL", "CL", "1", "CR", "LL", "LL", "LL", "LL", "LL", "FL", "LR", "1", "CR", "LL", "LL", "CR", "LL", "CL", "CR", "0", "LL", "LL", "LL", "0", "LR", "LL", "0", "LL", "LL", "LR", "CR", "CL", "FL", "CR", "CR", "LL", "CR", "LR", "LR", "let", "LL", "LL", "CL", "LL", "FL", "0", "LR", "LL", "0", "LL", "LL", "LL", "LL", "LL", "LL", "LL", "LL", "FL", "FL", "CL", "FR", "1", "CR", "LL", "LL", "LL", "LL", "LL", "LL", "FL", "LR", "LR", "LR", "CL", "0", "LL", "LL", "LL", "0", "LR", "LR", "CL", "1", "CR", "CL", "CL", "CR", "LR", "CL", "CL", "LL", "0", "CR", "CL", "0", "LR", "LL", "LL", "CL", "FL", "CR", "FL", "LL", "0", "LL", "1", "CR", "CR", "LL", "FR", "FR", "FR", "CL", "0"],["LL", "LL", "LL", "LL", "CL", "CL", "CL", "CR", "CL", "CR", "LL", "LR", "FR", "CR", "FR", "0", "LR", "CL", "FL", "CL", "FL", "LL", "FL", "1", "CR", "LL", "LL", "FL", "LL", "FL", "FL", "LR", "LL", "FR", "0", "LL", "CL", "CR", "CR", "LL", "LL", "LL", "LL", "1", "CR", "CL", "LL", "FR", "LL", "0", "LL", "LL", "FL", "FL", "LL", "FL", "LL", "CR", "0", "LR", "LL", "LL", "FL", "let", "LR", "0", "LL", "CR", "CR", "1", "CR", "LL", "LL", "0", "LL", "LL", "1", "CR", "LL", "LL", "LL", "LL", "FL", "LL", "CR", "CL", "CL", "FL", "1", "LR", "1", "LL", "CL", "LL", "CL", "LL", "LL", "FL", "FL", "0", "LL", "LL", "LL", "LL", "1", "CR", "LL", "1", "CL", "LR", "LL", "LL", "LR", "LL", "CL", "CR", "1", "CR", "LL", "LL", "LL", "LL", "LL", "LL", "CR", "CL", "let", "CR", "LL", "LL", "FL", "LL", "CL", "CL", "LL", "CR", "CL", "1", "CL", "LR", "LL", "LL", "LL", "LL", "LL", "LR", "0", "LL", "LL", "LR", "LR", "CR", "CL", "CL", "LR", "0", "LR", "LL", "0", "LL", "LL", "LL", "LL", "LL", "FL", "LL", "CR", "LL", "LL", "LL", "LL", "LL", "CR", "1", "CR", "LL", "LL", "LL", "LL", "LL", "LL", "CR", "LL", "CL", "LL", "LL", "LL", "LL", "LL", "LL", "CL", "0", "LL", "LL", "LR", "LL", "let", "LL", "LL", "LL", "LL", "LL", "LL", "LL", "let", "LL", "LL", "LL", "CL", "CL", "LL", "LR", "CL", "LL", "LL", "CL", "LL", "CL", "LL", "LL", "LL", "LL", "LL", "CL", "CR", "LL", "CL", "1", "CR", "LL", "LL", "1"],["CR", "LL", "LL", "FL", "0", "LL", "LL", "LL", "CR", "CR", "CL", "LL", "LR", "FL", "FR", "0", "CR", "LL", "LR", "CL", "FL", "1", "CR", "CR", "CL", "CR", "LL", "CR", "LL", "0", "LL", "LL", "LL", "LR", "LR", "CR", "LL", "CL", "LL", "CL", "0", "LR", "LR", "CL", "CL", "CR", "1", "CR", "CL", "LL", "LL", "LL", "LL", "CR", "CL", "LL", "CL", "0", "LL", "LL", "CL", "1", "CR", "LL", "FL", "1", "CL", "LL", "LL", "CL", "0", "LL", "LL", "CR", "LL", "0", "LL", "CR", "1", "CR", "LL", "LL", "FL", "FR", "CL", "CL", "FL", "1", "CL", "LL", "0", "LL", "LL", "LL", "LL", "LL", "LL", "0", "LR", "LL", "0", "LL", "LR", "FR", "FR", "1", "CR", "LL", "LL", "FL", "CL", "LL", "LL", "CL", "LL", "LL", "LL", "LR", "LR", "CR", "CL", "1", "CL", "LR", "CR", "CR", "1", "CR", "LL", "CL", "FL", "LL", "FR", "CR", "LL", "CL", "CL", "FR", "LL", "FL", "FL", "0"],["LL", "LL", "CR", "LL", "LR", "LR", "CR", "CL", "CR", "CR", "FR", "CR", "CL", "CL", "LL", "CL", "1", "CR", "CL", "CL", "1", "CL", "LR", "CR", "1", "CR", "LL", "CL", "FL", "CL", "FL", "0", "LL", "LL", "LL", "LL", "LL", "CL", "0", "LR", "CR", "LL", "0", "LL", "LL", "FL", "CR", "0", "LR", "LR", "CL", "CR", "FL", "0", "LL", "CR", "CL", "CL", "FL", "1", "CR", "LL", "LL", "CL", "LL", "LL", "CL", "LL", "LL", "FR", "0", "LL", "CR", "CL", "CR", "CL", "LL", "FL", "FL", "1", "CR", "LL", "LL", "LL", "LL", "LL", "LL", "LL", "LL", "LL", "1", "CL", "LL", "LL", "CL", "LL", "CL", "1", "CR", "LL", "LL", "LL", "LR", "LR", "LL", "1", "CL", "LL", "LL", "LL", "FL", "LL", "CL", "LL", "LL", "LL", "LL", "LL", "CL", "LR", "LL", "CL", "LL", "LL", "FL", "LL", "LL", "LR", "LL", "LL", "LL", "LL", "CL", "CL", "FL", "1", "CR", "LL", "LR", "LR", "0", "LL", "LR", "1", "CR", "LR", "LR", "FL", "FL", "CR", "1"],["CR", "LL", "LL", "CL", "1", "CL", "LL", "FL", "let", "CL", "CR", "CL", "CR", "CL", "0", "LL", "LL", "LL", "CL", "CL", "CL", "CL", "CR", "LL", "LL", "0", "LR", "LL", "0", "LL", "LL", "FL", "0", "LR", "LL", "LL", "LL", "LL", "CL", "0", "LL", "LL", "FL", "LR", "CL", "CR", "CL", "LL", "LL", "LL", "CL", "LL", "LL", "LL", "LL", "LL", "FL", "LR", "LL", "CL", "1", "CR", "LL", "LL", "CL", "CL", "LL", "LL", "0", "LL", "LL", "CL", "LL", "FL", "LL", "LL", "LL", "CL", "CR", "LR", "CL", "CL", "1", "CR", "LR", "LL", "LL", "CL", "LL", "LL", "FL", "0", "LL", "LL", "0", "LL", "CL", "LL", "CL", "1", "CR", "LL", "CL", "FL", "LL", "0", "LL", "CL", "LR", "0", "LR", "LL", "FL", "LL", "LL", "CR", "CR", "LL", "0"]], player2Places: [["LL", "LL", "0", "CL", "LL", "LL", "LL", "LL", "LL", "LL", "FL", "CL", "0", "LL", "LL", "LL", "FR", "CL", "FL", "1", "CR", "LL", "LL", "1", "CL", "LL", "CR", "1", "CR", "LL", "FL", "CR", "LL", "FL", "LR", "LR", "LL", "LR", "LR", "LR", "CR", "let", "CR", "LL", "LL", "FL", "LL", "1", "CL", "LL", "1", "CR", "LL", "LL", "LL", "LL", "LL", "LL", "LL", "LL", "FL", "CR", "CL", "0", "LL", "LL", "LL", "LL", "LL", "LL", "LR", "FL", "FL", "CR", "LL", "1", "CR", "LL", "LL", "1", "CL", "LR", "LL", "0", "LL", "LL", "FL", "LL", "CR", "FR", "CL", "CR", "1", "LL", "1", "CL", "LR", "CR", "CL", "FL", "FL", "CR", "CR", "CL", "1", "CR", "0", "LL", "FR", "FR", "FR", "LL", "FR", "1"],["CR", "LL", "CL", "CL", "CL", "CR", "LL", "FL", "FR", "LL", "LR", "CL", "CR", "FL", "CR", "1", "CL", "LL", "FL", "FL", "CL", "CL", "LL", "0", "LL", "LL", "FL", "LR", "CL", "FL", "LR", "LR", "FR", "1", "CR", "CL", "FL", "LR", "FL", "LL", "LL", "LL", "LL", "0", "LL", "FL", "CL", "LL", "FR", "1", "CR", "LL", "FL", "FL", "LR", "CL", "FL", "LL", "1", "CL", "LR", "LL", "CL", "let", "CL", "CL", "1", "CR", "FL", "LL", "0", "LL", "LL", "1", "CR", "CL", "FL", "0", "LL", "LL", "FR", "LL", "FL", "FL", "LL", "LL", "CL", "FL", "0", "CL", "0", "CR", "LL", "LL", "CL", "CL", "LL", "FL", "FL", "CR", "1", "CR", "LL", "LL", "LL", "LL", "0", "LL", "LL", "0", "LR", "LR", "LL", "CL", "LR", "CL", "FL", "0", "LL", "LL", "LL", "CL", "LL", "LL", "CL", "LR", "FR", "let", "LL", "LL", "LL", "FL", "CL", "LL", "FL", "CR", "FR", "0", "LR", "LR", "LL", "LL", "LL", "LL", "CL", "CL", "1", "CR", "LL", "FL", "FR", "FL", "LL", "FL", "CL", "CR", "1", "CL", "CR", "1", "CR", "LL", "LL", "FR", "CL", "CL", "FL", "CL", "CR", "LL", "LL", "LL", "LL", "FL", "0", "LL", "CL", "CL", "LL", "LL", "LL", "FL", "FR", "CR", "LL", "LL", "CL", "LL", "LL", "LL", "CL", "FR", "1", "CR", "LL", "LR", "CR", "let", "CR", "LL", "LL", "LL", "LL", "LL", "LL", "LL", "let", "CR", "LL", "LL", "LL", "LL", "FL", "CL", "LL", "FL", "LL", "CR", "LL", "LL", "FL", "LL", "LL", "LL", "LL", "LL", "FL", "CR", "LL", "FL", "0", "LL", "LL", "CR", "0"],["LL", "CR", "CL", "CR", "1", "CR", "LL", "LL", "LL", "LR", "FR", "LL", "LL", "LR", "CR", "1", "CL", "LR", "CL", "LL", "FL", "LR", "0", "LL", "FR", "FL", "LL", "LL", "FR", "CL", "1", "CR", "LL", "LL", "LL", "CR", "CL", "FR", "LL", "LR", "LL", "1", "CL", "LL", "CL", "LR", "FL", "CR", "0", "LL", "LL", "LL", "LL", "LL", "LL", "FR", "LL", "CL", "FR", "1", "CR", "LL", "LL", "FL", "0", "LL", "FL", "0", "LR", "LL", "CL", "FR", "1", "CR", "LL", "FL", "CR", "CL", "1", "CR", "LL", "LL", "0", "LL", "CL", "LL", "FL", "CL", "LL", "FL", "0", "CR", "CL", "1", "CR", "LL", "LL", "LL", "LL", "LL", "1", "CL", "LL", "CR", "1", "CR", "LL", "CR", "FR", "CL", "0", "CL", "CL", "CL", "FL", "LL", "LL", "FL", "CR", "LL", "LL", "FL", "FL", "LR", "FR", "0", "LR", "LR", "CL", "0", "LL", "LL", "FL", "FL", "CL", "LR", "LR", "CL", "LL", "LL", "CL", "CL", "FL", "1"],["CR", "LL", "LL", "LR", "LL", "CL", "CR", "FR", "FL", "LR", "CR", "CL", "CL", "CL", "LL", "FL", "0", "LL", "LL", "0", "LR", "LR", "0", "LL", "LL", "FL", "LR", "FL", "CL", "1", "CR", "LL", "LL", "LL", "LL", "LL", "FL", "1", "CL", "LL", "LL", "1", "CR", "LL", "CL", "CR", "1", "CL", "LR", "CL", "CR", "FR", "1", "CR", "CL", "LL", "CL", "FL", "FL", "0", "LL", "LL", "CL", "FL", "LL", "CL", "LL", "LL", "LL", "1", "CR", "LL", "FR", "FL", "LR", "LL", "LL", "CL", "FL", "0", "LL", "LL", "LL", "LL", "LL", "FL", "CL", "LL", "LL", "FL", "0", "LR", "LL", "LL", "LL", "LL", "FL", "0", "LL", "LL", "LL", "LL", "CR", "LL", "LL", "0", "CR", "LL", "LL", "CL", "CL", "LL", "FL", "LL", "LL", "LL", "LL", "LL", "FL", "CR", "CL", "LL", "CL", "CL", "FL", "LL", "FL", "LR", "LL", "LL", "LL", "LL", "FL", "FL", "0", "LL", "LL", "LR", "1", "CR", "LL", "FR", "0", "LL", "LR", "FL", "FL", "LR", "0"],["LL", "LL", "LL", "CL", "0", "LR", "CL", "CL", "let", "LR", "LL", "CL", "FR", "1", "CR", "LL", "LL", "LL", "FL", "LL", "FL", "CL", "CL", "FL", "1", "CL", "CL", "FL", "1", "CR", "LL", "FL", "1", "CL", "LL", "LL", "LL", "LL", "LL", "CL", "1", "CR", "LL", "CL", "FL", "CR", "FL", "CL", "LL", "LL", "LL", "LL", "FL", "LL", "LL", "LL", "LL", "LL", "CL", "LR", "LL", "0", "LL", "LL", "CL", "LL", "FL", "LL", "CL", "1", "CR", "LL", "LL", "CL", "CL", "CR", "LL", "LL", "LL", "FL", "LR", "CR", "LL", "FL", "0", "LL", "CR", "LL", "LL", "LL", "LL", "FL", "FL", "1", "CR", "LL", "CL", "1", "CR", "LL", "LL", "LL", "FL", "0", "LL", "CL", "LL", "LL", "1", "CR", "LL", "FL", "CR", "1", "CL", "LL", "FL", "LL", "LL", "FL", "LL", "FR", "CL", "1"]], numGames: 5, totalTimeInSeconds: 4260, matchName: "2019 Netsuite Open Final", player1Name: "Tarek Momen", player2Name: "Mohammed Elshorbagy", player1Nationality: "egypt", player2Nationality: "egypt")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ChooseMatchTableViewControllerSegue" {
			if let childVC = segue.destination as? ChooseMatchTableViewController {
				childVC.tableView.delegate = self
				childVC.tableView.dataSource = self
			}
		}
    }
}
