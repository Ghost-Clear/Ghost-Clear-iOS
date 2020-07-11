//
//  DoProWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/10/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreBluetooth
import Foundation
import AppusCircleTimer
import CoreData
import AVFoundation
class DoProWorkoutViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate, AppusCircleTimerDelegate {
	var player : AVAudioPlayer?
	var frtxCharacteristic : CBCharacteristic?
	var frrxCharacteristic : CBCharacteristic?
	var fltxCharacteristic : CBCharacteristic?
	var flrxCharacteristic : CBCharacteristic?
	var crtxCharacteristic : CBCharacteristic?
	var crrxCharacteristic : CBCharacteristic?
	var cltxCharacteristic : CBCharacteristic?
	var clrxCharacteristic : CBCharacteristic?
	var lrtxCharacteristic : CBCharacteristic?
	var lrrxCharacteristic : CBCharacteristic?
	var lltxCharacteristic : CBCharacteristic?
	var llrxCharacteristic : CBCharacteristic?
	var FRPeripheral : CBPeripheral?
	var FLPeripheral : CBPeripheral?
	var CRPeripheral : CBPeripheral?
	var CLPeripheral : CBPeripheral?
	var LRPeripheral : CBPeripheral?
	var LLPeripheral : CBPeripheral?
	var characteristicASCIIValue = NSString()
	var chosenMatch : Match!
	var difficulty : String!
	var isPlayer1 : Bool!
	var didConnect : Bool! = false
	var peripheralCount = 0
	var totalTimeTimer = Timer()
	var isFirstPair : Bool!
	var missedGhostCount = 0
	var whichGameIndex = 0
	var whichPointIndex = 0
	var whichRallyIndex = 0
	var ghostsRemaning = 0
	var totalTime = 0
	var placeArray : [[String]]! = []
	var timeArray : [[Double]]! = []
	var FRname : String!
	var FLname : String!
	var CRname : String!
	var CLname : String!
	var LRname : String!
	var totalGhosts = 0
	var isPrep = true
	var stopSelected = false
	@IBOutlet weak var ghostsRemaningLabel: UILabel!
	@IBOutlet weak var stopButton: UIButton!
	@IBOutlet weak var pauseButton: UIButton!
	@IBOutlet weak var finishButton: UIButton!
	var LLname : String!
	@IBOutlet weak var whichCornerLabel: UILabel!
	@IBOutlet weak var player1PointLabel: UILabel!
	@IBOutlet weak var player2PointLabel: UILabel!
	@IBOutlet weak var player1NameLabel: UILabel!
	@IBOutlet weak var player2NameLabel: UILabel!
	var player1Point = 0
	var player2Point = 0
	@IBOutlet weak var player1GameImage: UIImageView!
	@IBOutlet weak var player2GameImage: UIImageView!
	var player1GameCount = 0
	var player2GameCount = 0
	@IBOutlet var circleTime: AppusCircleTimer!
	func popBack(_ nb: Int) {
		if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
			guard viewControllers.count < nb else {
				self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
				return
			}
		}
	}
	@IBAction func stopWorkout(_ sender: Any) {
		writeValueFR(data: "0")
		writeValueFL(data: "0")
		writeValueCR(data: "0")
		writeValueCL(data: "0")
		writeValueLR(data: "0")
		writeValueLL(data: "0")
		stopSelected = true
		circleTime.isActive = false
		isWaitingForGhost = false
		circleTime.isHidden = true
		circleTime.stop()
		totalTimeTimer.invalidate()
		centralManager.stopScan()
		disconnectAllConnection()
		popBack(3)		
	}
	@objc func UpdateTimer(){
		totalTime += 1
	}
	@IBAction func pause(_ sender: Any) {
		isPaused = !isPaused
		if isPaused{
			pauseButton.setImage(UIImage(named: "Play Button"), for: .normal)
			writeValueFR(data: "0")
			writeValueFL(data: "0")
			writeValueCR(data: "0")
			writeValueCL(data: "0")
			writeValueLR(data: "0")
			writeValueLL(data: "0")
			totalTimeTimer.invalidate()
			circleTime.stop()
		}
		else{
			totalTimeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
			pauseButton.setImage(UIImage(named: "Pause Button"), for: .normal)
			circleTime.resume()
			if isWaitingForGhost{
				if placeArray[whichGameIndex][whichRallyIndex] == "FR"{
					whichCornerLabel.text = "Front Right"
					playSound(sound: "Front-Right")
					writeValueFR(data: "1")
				}
				if placeArray[whichGameIndex][whichRallyIndex] == "FL"{
					whichCornerLabel.text = "Front Left"
					playSound(sound: "Front-Left")
					writeValueFL(data: "1")
				}
				if placeArray[whichGameIndex][whichRallyIndex] == "CR"{
					whichCornerLabel.text = "Center Right"
					playSound(sound: "Center-Right")
					writeValueCR(data: "1")
				}
				if placeArray[whichGameIndex][whichRallyIndex] == "CL"{
					whichCornerLabel.text = "Center Left"
					playSound(sound: "Center-Left")
					writeValueCL(data: "1")
				}
				if placeArray[whichGameIndex][whichRallyIndex] == "LR"{
					whichCornerLabel.text = "Back Right"
					playSound(sound: "Back-Right")
					writeValueLR(data: "1")
				}
				if placeArray[whichGameIndex][whichRallyIndex] == "LL"{
					whichCornerLabel.text = "Back Left"
					playSound(sound: "Back-Left")
					writeValueLL(data: "1")
				}
			}
			
		}
		circleTime.timerLabel?.textColor = .white
	}
	func playSound(sound : String!) {
		guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
		
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)
			player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
			guard let player = player else { return }
			player.play()
		} catch let error {
			print(error.localizedDescription)
		}
	}
	@IBAction func finish(_ sender: Any) {
		if !isPrep{
		circleTime.stop()
		totalTimeTimer.invalidate()
		centralManager.stopScan()
		disconnectAllConnection()
		playSound(sound: "success")
		performSegue(withIdentifier: "ProWorkoutCheckPopupViewControllerSegue", sender: nil)
		let seconds = 1.51
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
			self.performSegue(withIdentifier: "DoneProWorkoutViewControllerSegue", sender: nil)
		}
		}
		else{
			circleTime.stop()
			totalTimeTimer.invalidate()
			centralManager.stopScan()
			disconnectAllConnection()
			popBack(4)
		}
	}
	func circleCounterTimeDidExpire(circleTimer: AppusCircleTimer) {
		print(whichGameIndex)
		print(whichPointIndex)
		print(whichRallyIndex)
		isPrep = false
		if isWaitingForGhost{
			circleTime.stop()
			totalTimeTimer.invalidate()
			isWaitingForGhost = false
			writeValueFR(data: "0")
			writeValueFL(data: "0")
			writeValueCR(data: "0")
			writeValueCL(data: "0")
			writeValueLR(data: "0")
			writeValueLL(data: "0")
			let toGo = getGhostCount(gameIndex: whichGameIndex, rallyindex: whichRallyIndex)
			missedGhostCount += toGo
			whichRallyIndex += toGo
			if whichRallyIndex == placeArray[whichGameIndex].count-1 && whichGameIndex == chosenMatch.numGames - 1{
				if player1GameCount > player2GameCount{
					player1GameImage.image = UIImage(named: "3GamesWon")
				}
				else{
					player2GameImage.image = UIImage(named: "3GamesWon")
				}
				centralManager.stopScan()
				disconnectAllConnection()
				playSound(sound: "success")
				performSegue(withIdentifier: "ProWorkoutCheckPopupViewControllerSegue", sender: nil)
				let seconds = 1.51
				DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
					self.performSegue(withIdentifier: "DoneProWorkoutViewControllerSegue", sender: nil)
				}
			}
			else if whichRallyIndex == placeArray[whichGameIndex].count-1{
				whichGameIndex += 1
				whichRallyIndex = 0
				whichPointIndex = 0
				if player1Point > player2Point{
					player1GameCount += 1
					if player1GameCount == 1{
						player1GameImage.image = UIImage(named: "1GameWon")
					}
					if player1GameCount == 2{
						player1GameImage.image = UIImage(named: "2GamesWon")
					}
					if player1GameCount == 3{
						player1GameImage.image = UIImage(named: "3GamesWon")
					}
				}
				else{
					player2GameCount += 1
					if player2GameCount == 1{
						player2GameImage.image = UIImage(named: "1GameWon")
					}
					if player2GameCount == 2{
						player2GameImage.image = UIImage(named: "2GamesWon")
					}
					if player2GameCount == 3{
						player2GameImage.image = UIImage(named: "3GamesWon")
					}
				}
				player1Point = 0
				player2Point = 0
				player1PointLabel.text = String(player1Point)
				player2PointLabel.text = String(player2Point)
				circleTime.elapsedTime = 0
				circleTime.totalTime = 90
				circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.start()
			}
			else{
				totalTimeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
				whichRallyIndex += 1
				circleTime.elapsedTime = 0
				if difficulty == "easy"{
					circleTime.totalTime = 15
				}
				else if difficulty == "medium"{
					circleTime.totalTime = 12
				}
				else if difficulty == "hard"{
					circleTime.totalTime = 10
				}
				else if difficulty == "pro"{
					circleTime.totalTime = 7
				}
				circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.start()
			}
		}
		else if !isPrep{
			isWaitingForGhost = true
			ghostsRemaning = getGhostCount(gameIndex: whichGameIndex, rallyindex: whichRallyIndex)
			ghostsRemaningLabel.text = String(ghostsRemaning)
			print(ghostsRemaning)
			circleTime.totalTime = chosenMatch.pointTimings[whichGameIndex][whichPointIndex]
			if difficulty == "easy"{
				circleTime.totalTime *= 1.8
			}
			else if difficulty == "medium"{
				circleTime.totalTime *= 1.4
			}
			else if difficulty == "hard"{
				circleTime.totalTime *= 1.1
			}
			else if difficulty == "pro"{
				circleTime.totalTime *= 0.9
			}
			if placeArray[whichGameIndex][whichRallyIndex] == "FR"{
				whichCornerLabel.text = "Front Right"
				playSound(sound: "Front-Right")
				writeValueFR(data: "1")
			}
			if placeArray[whichGameIndex][whichRallyIndex] == "FL"{
				whichCornerLabel.text = "Front Left"
				playSound(sound: "Front-Left")
				writeValueFL(data: "1")
			}
			if placeArray[whichGameIndex][whichRallyIndex] == "CR"{
				whichCornerLabel.text = "Center Right"
				playSound(sound: "Center-Right")
				writeValueCR(data: "1")
			}
			if placeArray[whichGameIndex][whichRallyIndex] == "CL"{
				whichCornerLabel.text = "Center Left"
				playSound(sound: "Center-Left")
				writeValueCL(data: "1")
			}
			if placeArray[whichGameIndex][whichRallyIndex] == "LR"{
				whichCornerLabel.text = "Back Right"
				playSound(sound: "Back-Right")
				writeValueLR(data: "1")
			}
			if placeArray[whichGameIndex][whichRallyIndex] == "LL"{
				whichCornerLabel.text = "Back Left"
				playSound(sound: "Back-Left")
				writeValueLL(data: "1")
			}
			circleTime.elapsedTime = 0
			circleTime.activeColor = UIColor(red: 26/256, green: 231/256, blue: 148/256, alpha: 1)
			circleTime.pauseColor = UIColor(red: 26/256, green: 231/256, blue: 148/256, alpha: 1)
			circleTime.start()
		}
	}
	func getGhostCount(gameIndex : Int!, rallyindex : Int!) -> Int{
		var count = 0
		var j = 0
		for i in placeArray[gameIndex]{
			if (i == "FR" || i == "FL" || i == "CL" || i == "CR" || i == "LL" || i == "LR") && j >= rallyindex && j < placeArray[gameIndex].count{
				count += 1
			}
			else if j >= rallyindex && j < placeArray[gameIndex].count{
				break
			}
			j += 1
		}
		return count
	}
	var centralManager : CBCentralManager!
	var peripheralManager: CBPeripheralManager?
	var RSSIs = [NSNumber]()
	var data = NSMutableData()
	var writeData: String = ""
	var peripherals: [CBPeripheral] = []
	var characteristicValue = [CBUUID: NSData]()
	var timer = Timer()
	var characteristics = [String : CBCharacteristic]()
	var isPaused : Bool! = false
	var isWaitingForGhost : Bool! = false
	override func viewDidLoad() {
		super.viewDidLoad()
		stopButton.contentMode = .scaleAspectFit
		pauseButton.contentMode = .scaleAspectFit
		finishButton.contentMode = .scaleAspectFit
		whichCornerLabel.text = "Get Ready"
		player1NameLabel.text = chosenMatch.player1Name
		player2NameLabel.text = chosenMatch.player2Name
		if isPlayer1{
			placeArray = chosenMatch.player1Places
		}
		else{
			placeArray = chosenMatch.player2Places
		}
		ghostsRemaning = getGhostCount(gameIndex: 0, rallyindex: 0)
		ghostsRemaningLabel.text = String(ghostsRemaning)
		timeArray = chosenMatch.pointTimings
		player1PointLabel.text = "0"
		player2PointLabel.text = "0"
		player1GameImage.image = UIImage(named: "0GamesWon")
		player2GameImage.image = UIImage(named: "0GamesWon")
		circleTime.delegate = self
		circleTime.font = UIFont(name: "System", size: 50 )
		circleTime.isBackwards = true
		circleTime.isActive = false
		circleTime.isHidden = true
		centralManager = CBCentralManager(delegate: self, queue: nil)
		peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
		if allPeripeheralsExist(id: true){
			isFirstPair = false
			if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
				if let keysFromCore = try? context.fetch(BLEkey.fetchRequest()){
					let keyfromcore = keysFromCore as! [BLEkey]
					for key in keyfromcore {
						if key.name == "FR"{
							FRname = key.key
						}
						if key.name == "FL"{
							FLname = key.key
						}
						if key.name == "CR"{
							CRname = key.key
						}
						if key.name == "CL"{
							CLname = key.key
						}
						if key.name == "LR"{
							LRname = key.key
						}
						if key.name == "LL"{
							LLname = key.key
						}
					}
				}
			}
		}
		else{
			isFirstPair = true
		}
		performSegue(withIdentifier: "ProWorkoutConnectionProgressViewControllerSegue", sender: nil)
		DispatchQueue.main.asyncAfter(deadline: .now() + 4.2) {
			if !self.didConnect{
				let alertVC = UIAlertController(title: "Not Connected To Devices", message: "Make sure that your bluetooth is turned on and all 6 devices are available before starting the workout.", preferredStyle: UIAlertController.Style.alert)
				self.centralManager.stopScan()
				let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
					self.dismiss(animated: true, completion: nil)
					self.popBack(2)
					self.disconnectAllConnection()
				})
				alertVC.addAction(action)
				self.present(alertVC, animated: true, completion: nil)
			}
			else{
				self.circleTime.start()
				self.totalTimeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.UpdateTimer), userInfo: nil, repeats: true)
			}
			
		}
	}
	func allPeripeheralsExist(id: Bool) -> Bool {
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BLEkey")
			fetchRequest.includesSubentities = false
			
			var entitiesCount = 0
			
			do {
				entitiesCount = try context.count(for: fetchRequest)
			}
			catch {
				print("error executing fetch request: \(error)")
			}
			
			return entitiesCount == 6
			
		}
		return false
		
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		print("Stop Scanning")
		centralManager?.stopScan()
	}
	
	
	func writeValueFR(data: String){
		let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
		if let blePeripheral = FRPeripheral{
			if let txCharacteristic = frtxCharacteristic {
				blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
			}
		}
	}
	func writeCharacteristicFR(val: Int8){
		var val = val
		let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
		FRPeripheral!.writeValue(ns as Data, for: frtxCharacteristic!, type: CBCharacteristicWriteType.withResponse)
	}
	
	
	func writeValueFL(data: String){
		let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
		if let blePeripheral = FLPeripheral{
			if let txCharacteristic = fltxCharacteristic {
				blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
			}
		}
	}
	func writeCharacteristicFL(val: Int8){
		var val = val
		let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
		FLPeripheral!.writeValue(ns as Data, for: fltxCharacteristic!, type: CBCharacteristicWriteType.withResponse)
	}
	
	
	func writeValueCR(data: String){
		let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
		if let blePeripheral = CRPeripheral{
			if let txCharacteristic = crtxCharacteristic {
				blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
			}
		}
	}
	func writeCharacteristicCR(val: Int8){
		var val = val
		let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
		CRPeripheral!.writeValue(ns as Data, for: crtxCharacteristic!, type: CBCharacteristicWriteType.withResponse)
	}
	
	
	func writeValueCL(data: String){
		let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
		if let blePeripheral = CLPeripheral{
			if let txCharacteristic = cltxCharacteristic {
				blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
			}
		}
	}
	func writeCharacteristicCL(val: Int8){
		var val = val
		let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
		CLPeripheral!.writeValue(ns as Data, for: cltxCharacteristic!, type: CBCharacteristicWriteType.withResponse)
	}
	
	
	func writeValueLL(data: String){
		let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
		if let blePeripheral = LLPeripheral{
			if let txCharacteristic = lltxCharacteristic {
				blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
			}
		}
	}
	func writeCharacteristicLL(val: Int8){
		var val = val
		let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
		LLPeripheral!.writeValue(ns as Data, for: lltxCharacteristic!, type: CBCharacteristicWriteType.withResponse)
	}
	
	
	func writeValueLR(data: String){
		let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
		if let blePeripheral = LRPeripheral{
			if let txCharacteristic = lrtxCharacteristic {
				blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
			}
		}
	}
	func writeCharacteristicLR(val: Int8){
		var val = val
		let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
		LRPeripheral!.writeValue(ns as Data, for: lrtxCharacteristic!, type: CBCharacteristicWriteType.withResponse)
	}
	
	
	func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
		if peripheral.state == .poweredOn {
			return
		}
		print("Peripheral manager is running")
	}
	func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
		print("Device subscribe to characteristic")
	}
	
	func startScan() {
		peripherals = []
		print("Now Scanning...")
		self.timer.invalidate()
		centralManager?.scanForPeripherals(withServices: [BLEService_UUID] , options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
		Timer.scheduledTimer(withTimeInterval: 17, repeats: false) {_ in
			self.cancelScan()
		}
	}
	func cancelScan() {
		self.centralManager?.stopScan()
		print("Scan Stopped")
		print("Number of Peripherals Found: \(peripherals.count)")
	}
	func disconnectFromDevice () {
		stopSelected = true
		if FRPeripheral != nil {
			centralManager?.cancelPeripheralConnection(FRPeripheral!)
		}
		if FLPeripheral != nil {
			centralManager?.cancelPeripheralConnection(FLPeripheral!)
		}
		if CRPeripheral != nil {
			centralManager?.cancelPeripheralConnection(CRPeripheral!)
		}
		if CLPeripheral != nil {
			centralManager?.cancelPeripheralConnection(CLPeripheral!)
		}
		if LRPeripheral != nil {
			centralManager?.cancelPeripheralConnection(LRPeripheral!)
		}
		if LLPeripheral != nil {
			centralManager?.cancelPeripheralConnection(LLPeripheral!)
		}
	}
	func restoreCentralManager() {
		centralManager?.delegate = self
	}
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {
		if !isFirstPair{
			if(peripheral.name == FRname){
				FRPeripheral = peripheral
				FRPeripheral?.delegate = self
				centralManager?.connect(FRPeripheral!, options: nil)
				
			}
			if(peripheral.name == FLname){
				FLPeripheral = peripheral
				FLPeripheral?.delegate = self
				centralManager?.connect(FLPeripheral!, options: nil)
			}
			if(peripheral.name == CRname){
				CRPeripheral = peripheral
				CRPeripheral?.delegate = self
				centralManager?.connect(CRPeripheral!, options: nil)
			}
			if(peripheral.name == CLname){
				CLPeripheral = peripheral
				CLPeripheral?.delegate = self
				centralManager?.connect(CLPeripheral!, options: nil)
			}
			if(peripheral.name == LLname){
				LLPeripheral = peripheral
				LLPeripheral?.delegate = self
				centralManager?.connect(LLPeripheral!, options: nil)
			}
			if(peripheral.name == LRname){
				LRPeripheral = peripheral
				LRPeripheral?.delegate = self
				centralManager?.connect(LRPeripheral!, options: nil)
			}
			self.peripherals.append(peripheral)
			self.RSSIs.append(RSSI)
			peripheral.delegate = self
			print("Peripheral name: \(String(describing: peripheral.name))")
		}
		else{
			
			if(peripheral.name!.prefix(2) == "FR"){
				FRname = peripheral.name
				FRPeripheral = peripheral
				FRPeripheral?.delegate = self
				centralManager?.connect(FRPeripheral!, options: nil)
				if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
					let name = BLEkey(context: context)
					name.key = peripheral.name!
					name.name = "FR"
				}
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
				
			}
			if(peripheral.name!.prefix(2) == "FL"){
				FLname = peripheral.name
				FLPeripheral = peripheral
				FLPeripheral?.delegate = self
				centralManager?.connect(FLPeripheral!, options: nil)
				if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
					let name = BLEkey(context: context)
					name.key = peripheral.name!
					name.name = "FL"
				}
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
			}
			if(peripheral.name!.prefix(2) == "CR"){
				CRname = peripheral.name
				CRPeripheral = peripheral
				CRPeripheral?.delegate = self
				centralManager?.connect(CRPeripheral!, options: nil)
				if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
					let name = BLEkey(context: context)
					name.key = peripheral.name!
					name.name = "CR"
				}
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
			}
			if(peripheral.name!.prefix(2) == "CL"){
				CLname = peripheral.name
				CLPeripheral = peripheral
				CLPeripheral?.delegate = self
				centralManager?.connect(CLPeripheral!, options: nil)
				if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
					let name = BLEkey(context: context)
					name.key = peripheral.name!
					name.name = "CL"
				}
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
			}
			if(peripheral.name!.prefix(2) == "LL"){
				LLname = peripheral.name
				LLPeripheral = peripheral
				LLPeripheral?.delegate = self
				centralManager?.connect(LLPeripheral!, options: nil)
				if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
					let name = BLEkey(context: context)
					name.key = peripheral.name!
					name.name = "LL"
				}
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
			}
			if(peripheral.name!.prefix(2) == "LR"){
				LRname = peripheral.name
				LRPeripheral = peripheral
				LRPeripheral?.delegate = self
				centralManager?.connect(LRPeripheral!, options: nil)
				if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
					let name = BLEkey(context: context)
					name.key = peripheral.name!
					name.name = "LR"
				}
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
			}
			self.peripherals.append(peripheral)
			self.RSSIs.append(RSSI)
			peripheral.delegate = self
			print("Peripheral name: \(String(describing: peripheral.name))")
		}
		
		
		
	}
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		print("*****************************")
		print("Connection complete")
		peripheralCount += 1
		if peripheralCount == 6{
			centralManager?.stopScan()
			print("Scan Stopped")
		}
		data.length = 0
		peripheral.delegate = self
		peripheral.discoverServices([BLEService_UUID])
	}
	
	func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		if error != nil {
			print("Failed to connect to peripheral")
			return
		}
	}
	
	func disconnectAllConnection() {
		stopSelected = true
		if(centralManager != nil && FRPeripheral != nil){
			centralManager.cancelPeripheralConnection(FRPeripheral!)
		}
		if(centralManager != nil && FLPeripheral != nil){
			centralManager.cancelPeripheralConnection(FLPeripheral!)
		}
		if(centralManager != nil && CRPeripheral != nil){
			centralManager.cancelPeripheralConnection(CRPeripheral!)
		}
		if(centralManager != nil && CLPeripheral != nil){
			centralManager.cancelPeripheralConnection(CLPeripheral!)
		}
		if(centralManager != nil && LRPeripheral != nil){
			centralManager.cancelPeripheralConnection(LRPeripheral!)
		}
		if(centralManager != nil && LLPeripheral != nil){
			centralManager.cancelPeripheralConnection(LLPeripheral!)
		}
	}
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		print("*******************************************************")
		
		if ((error) != nil) {
			print("Error discovering services: \(error!.localizedDescription)")
			return
		}
		
		guard let services = peripheral.services else {
			return
		}
		for service in services {
			
			peripheral.discoverCharacteristics(nil, for: service)
		}
		print("Discovered Services: \(services)")
	}
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		
		print("*******************************************************")
		
		if ((error) != nil) {
			print("Error discovering services: \(error!.localizedDescription)")
			return
		}
		
		guard let characteristics = service.characteristics else {
			return
		}
		print("Found \(characteristics.count) characteristics!")
		for characteristic in characteristics {
			if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Rx)  {
				if peripheral.name == "FR" || peripheral.name == FRname{
					frrxCharacteristic = characteristic
					peripheral.setNotifyValue(true, for: frrxCharacteristic!)
				}
				if peripheral.name == "FL" || peripheral.name == FLname{
					flrxCharacteristic = characteristic
					peripheral.setNotifyValue(true, for: flrxCharacteristic!)
				}
				if peripheral.name == "CR" || peripheral.name == CRname{
					crrxCharacteristic = characteristic
					peripheral.setNotifyValue(true, for: crrxCharacteristic!)
				}
				if peripheral.name == "CL" || peripheral.name == CLname{
					clrxCharacteristic = characteristic
					peripheral.setNotifyValue(true, for: clrxCharacteristic!)
				}
				if peripheral.name == "LR" || peripheral.name == LRname{
					lrrxCharacteristic = characteristic
					peripheral.setNotifyValue(true, for: lrrxCharacteristic!)
				}
				if peripheral.name == "LL" || peripheral.name == LLname{
					llrxCharacteristic = characteristic
					peripheral.setNotifyValue(true, for: llrxCharacteristic!)
				}
				peripheral.readValue(for: characteristic)
				print("Rx Characteristic: \(characteristic.uuid)")
			}
			if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Tx){
				if peripheral.name == "FR" || peripheral.name == FRname{
					frtxCharacteristic = characteristic
				}
				if peripheral.name == "FL" || peripheral.name == FLname{
					fltxCharacteristic = characteristic
					
				}
				if peripheral.name == "CR" || peripheral.name == CRname{
					crtxCharacteristic = characteristic
					
				}
				if peripheral.name == "CL" || peripheral.name == CLname{
					cltxCharacteristic = characteristic
					
				}
				if peripheral.name == "LR" || peripheral.name == LRname{
					lrtxCharacteristic = characteristic
					
				}
				if peripheral.name == "LL" || peripheral.name == LLname{
					lltxCharacteristic = characteristic
					
				}
				print("Tx Characteristic: \(characteristic.uuid)")
			}
			peripheral.discoverDescriptors(for: characteristic)
		}
	}
	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		if peripheral.name == "FR" || peripheral.name == FRname{
			guard characteristic == frrxCharacteristic,
				let characteristicValue = characteristic.value,
				let ASCIIstring = NSString(data: characteristicValue,
										   encoding: String.Encoding.utf8.rawValue)
				else { return }
			characteristicASCIIValue = ASCIIstring
		}
		if peripheral.name == "FL" || peripheral.name == FLname{
			guard characteristic == flrxCharacteristic,
				let characteristicValue = characteristic.value,
				let ASCIIstring = NSString(data: characteristicValue,
										   encoding: String.Encoding.utf8.rawValue)
				else { return }
			characteristicASCIIValue = ASCIIstring
		}
		if peripheral.name == "CR" || peripheral.name == CRname{
			guard characteristic == crrxCharacteristic,
				let characteristicValue = characteristic.value,
				let ASCIIstring = NSString(data: characteristicValue,
										   encoding: String.Encoding.utf8.rawValue)
				else { return }
			characteristicASCIIValue = ASCIIstring
		}
		if peripheral.name == "CL" || peripheral.name == CLname{
			guard characteristic == clrxCharacteristic,
				let characteristicValue = characteristic.value,
				let ASCIIstring = NSString(data: characteristicValue,
										   encoding: String.Encoding.utf8.rawValue)
				else { return }
			characteristicASCIIValue = ASCIIstring
		}
		if peripheral.name == "LR" || peripheral.name == LRname{
			guard characteristic == lrrxCharacteristic,
				let characteristicValue = characteristic.value,
				let ASCIIstring = NSString(data: characteristicValue,
										   encoding: String.Encoding.utf8.rawValue)
				else { return }
			characteristicASCIIValue = ASCIIstring
		}
		if peripheral.name == "LL" || peripheral.name == LLname{
			guard characteristic == llrxCharacteristic,
				let characteristicValue = characteristic.value,
				let ASCIIstring = NSString(data: characteristicValue,
										   encoding: String.Encoding.utf8.rawValue)
				else { return }
			characteristicASCIIValue = ASCIIstring
		}
		
		
		
		print("Value Recieved: \((characteristicASCIIValue as String))")
		if peripheral == FRPeripheral{
			if placeArray[whichGameIndex][whichRallyIndex] == "FR" && isWaitingForGhost && !isPaused{
				whichRallyIndex += 1
				ghostsRemaning -= 1
				totalGhosts += 1
				if placeArray[whichGameIndex][whichRallyIndex] == "let"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Let"
					whichPointIndex += 1
				}
				else if placeArray[whichGameIndex][whichRallyIndex] == "1"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Rest"
					if isPlayer1{
						player1Point += 1
						player1PointLabel.text = String(player1Point)
					}
					else{
						player2Point += 1
						player2PointLabel.text = String(player2Point)
					}
					whichPointIndex += 1
				}
				else if placeArray[whichGameIndex][whichRallyIndex] == "0"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Rest"
					
					if isPlayer1{
						player2Point += 1
						player2PointLabel.text = String(player2Point)
					}
					else{
						player1Point += 1
						player1PointLabel.text = String(player1Point)
					}
					whichPointIndex += 1
				}
				else{
					isWaitingForGhost = true
					if placeArray[whichGameIndex][whichRallyIndex] == "FR"{
						whichCornerLabel.text = "Front Right"
						playSound(sound: "Front-Right")
						writeValueFR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "FL"{
						whichCornerLabel.text = "Front Left"
						playSound(sound: "Front-Left")
						writeValueFL(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "CR"{
						whichCornerLabel.text = "Center Right"
						playSound(sound: "Center-Right")
						writeValueCR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "CL"{
						whichCornerLabel.text = "Center Left"
						playSound(sound: "Center-Left")
						writeValueCL(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "LR"{
						whichCornerLabel.text = "Back Right"
						playSound(sound: "Back-Right")
						writeValueLR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "LL"{
						whichCornerLabel.text = "Back Left"
						playSound(sound: "Back-Left")
						writeValueLL(data: "1")
					}
				}
				ghostsRemaningLabel.text = String(ghostsRemaning)
				
			}
		}
		if peripheral == FLPeripheral{
			if placeArray[whichGameIndex][whichRallyIndex] == "FL" && isWaitingForGhost && !isPaused{
				totalGhosts += 1
				whichRallyIndex += 1
				ghostsRemaning -= 1
				if placeArray[whichGameIndex][whichRallyIndex] == "let"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Let"
					
					whichPointIndex += 1
				}
				else if placeArray[whichGameIndex][whichRallyIndex] == "1"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Rest"
					
					if isPlayer1{
						player1Point += 1
						player1PointLabel.text = String(player1Point)
					}
					else{
						player2Point += 1
						player2PointLabel.text = String(player2Point)
					}
					whichPointIndex += 1
				}
				else if placeArray[whichGameIndex][whichRallyIndex] == "0"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Rest"
					
					if isPlayer1{
						player2Point += 1
						player2PointLabel.text = String(player2Point)
					}
					else{
						player1Point += 1
						player1PointLabel.text = String(player1Point)
					}
					whichPointIndex += 1
				}
				else{
					isWaitingForGhost = true
					if placeArray[whichGameIndex][whichRallyIndex] == "FR"{
						whichCornerLabel.text = "Front Right"
						playSound(sound: "Front-Right")
						writeValueFR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "FL"{
						whichCornerLabel.text = "Front Left"
						playSound(sound: "Front-Left")
						writeValueFL(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "CR"{
						whichCornerLabel.text = "Center Right"
						playSound(sound: "Center-Right")
						writeValueCR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "CL"{
						whichCornerLabel.text = "Center Left"
						playSound(sound: "Center-Left")
						writeValueCL(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "LR"{
						whichCornerLabel.text = "Back Right"
						playSound(sound: "Back-Right")
						writeValueLR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "LL"{
						whichCornerLabel.text = "Back Left"
						playSound(sound: "Back-Left")
						writeValueLL(data: "1")
					}
				}
				ghostsRemaningLabel.text = String(ghostsRemaning)
				
			}
		}
		if peripheral == CRPeripheral{
			if placeArray[whichGameIndex][whichRallyIndex] == "CR" && isWaitingForGhost && !isPaused{
				totalGhosts += 1
				whichRallyIndex += 1
				ghostsRemaning -= 1
				if placeArray[whichGameIndex][whichRallyIndex] == "let"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Let"
					whichPointIndex += 1
				}
				else if placeArray[whichGameIndex][whichRallyIndex] == "1"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Rest"
					if isPlayer1{
						player1Point += 1
						player1PointLabel.text = String(player1Point)
					}
					else{
						player2Point += 1
						player2PointLabel.text = String(player2Point)
					}
					whichPointIndex += 1
				}
				else if placeArray[whichGameIndex][whichRallyIndex] == "0"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Rest"
					if isPlayer1{
						player2Point += 1
						player2PointLabel.text = String(player2Point)
					}
					else{
						player1Point += 1
						player1PointLabel.text = String(player1Point)
					}
					whichPointIndex += 1
				}
				else{
					isWaitingForGhost = true
					if placeArray[whichGameIndex][whichRallyIndex] == "FR"{
						whichCornerLabel.text = "Front Right"
						playSound(sound: "Front-Right")
						writeValueFR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "FL"{
						whichCornerLabel.text = "Front Left"
						playSound(sound: "Front-Left")
						writeValueFL(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "CR"{
						whichCornerLabel.text = "Center Right"
						playSound(sound: "Center-Right")
						writeValueCR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "CL"{
						whichCornerLabel.text = "Center Left"
						playSound(sound: "Center-Left")
						writeValueCL(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "LR"{
						whichCornerLabel.text = "Back Right"
						playSound(sound: "Back-Right")
						writeValueLR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "LL"{
						whichCornerLabel.text = "Back Left"
						playSound(sound: "Back-Left")
						writeValueLL(data: "1")
					}
				}
				ghostsRemaningLabel.text = String(ghostsRemaning)
				
			}
		}
		if peripheral == CLPeripheral{
			if placeArray[whichGameIndex][whichRallyIndex] == "CL" && isWaitingForGhost && !isPaused{
				totalGhosts += 1
				whichRallyIndex += 1
				ghostsRemaning -= 1
				if placeArray[whichGameIndex][whichRallyIndex] == "let"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Let"
					whichPointIndex += 1
				}
				else if placeArray[whichGameIndex][whichRallyIndex] == "1"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Rest"
					if isPlayer1{
						player1Point += 1
						player1PointLabel.text = String(player1Point)
					}
					else{
						player2Point += 1
						player2PointLabel.text = String(player2Point)
					}
					whichPointIndex += 1
				}
				else if placeArray[whichGameIndex][whichRallyIndex] == "0"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Rest"
					if isPlayer1{
						player2Point += 1
						player2PointLabel.text = String(player2Point)
					}
					else{
						player1Point += 1
						player1PointLabel.text = String(player1Point)
					}
					whichPointIndex += 1
				}
				else{
					isWaitingForGhost = true
					if placeArray[whichGameIndex][whichRallyIndex] == "FR"{
						whichCornerLabel.text = "Front Right"
						playSound(sound: "Front-Right")
						writeValueFR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "FL"{
						whichCornerLabel.text = "Front Left"
						playSound(sound: "Front-Left")
						writeValueFL(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "CR"{
						whichCornerLabel.text = "Center Right"
						playSound(sound: "Center-Right")
						writeValueCR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "CL"{
						whichCornerLabel.text = "Center Left"
						playSound(sound: "Center-Left")
						writeValueCL(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "LR"{
						whichCornerLabel.text = "Back Right"
						playSound(sound: "Back-Right")
						writeValueLR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "LL"{
						whichCornerLabel.text = "Back Left"
						playSound(sound: "Back-Left")
						writeValueLL(data: "1")
					}
				}
				ghostsRemaningLabel.text = String(ghostsRemaning)
				
			}
		}
		if peripheral == LRPeripheral{
			if placeArray[whichGameIndex][whichRallyIndex] == "LR" && isWaitingForGhost && !isPaused{
				totalGhosts += 1
				whichRallyIndex += 1
				ghostsRemaning -= 1
				if placeArray[whichGameIndex][whichRallyIndex] == "let"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Let"
					whichPointIndex += 1
				}
				else if placeArray[whichGameIndex][whichRallyIndex] == "1"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Rest"
					if isPlayer1{
						player1Point += 1
						player1PointLabel.text = String(player1Point)
					}
					else{
						player2Point += 1
						player2PointLabel.text = String(player2Point)
					}
					whichPointIndex += 1
				}
				else if placeArray[whichGameIndex][whichRallyIndex] == "0"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Rest"
					if isPlayer1{
						player2Point += 1
						player2PointLabel.text = String(player2Point)
					}
					else{
						player1Point += 1
						player1PointLabel.text = String(player1Point)
					}
					whichPointIndex += 1
				}
				else{
					isWaitingForGhost = true
					if placeArray[whichGameIndex][whichRallyIndex] == "FR"{
						whichCornerLabel.text = "Front Right"
						playSound(sound: "Front-Right")
						writeValueFR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "FL"{
						whichCornerLabel.text = "Front Left"
						playSound(sound: "Front-Left")
						writeValueFL(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "CR"{
						whichCornerLabel.text = "Center Right"
						playSound(sound: "Center-Right")
						writeValueCR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "CL"{
						whichCornerLabel.text = "Center Left"
						playSound(sound: "Center-Left")
						writeValueCL(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "LR"{
						whichCornerLabel.text = "Back Right"
						playSound(sound: "Back-Right")
						writeValueLR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "LL"{
						whichCornerLabel.text = "Back Left"
						playSound(sound: "Back-Left")
						writeValueLL(data: "1")
					}
				}
				ghostsRemaningLabel.text = String(ghostsRemaning)
				
			}
		}
		if peripheral == LLPeripheral{
			if placeArray[whichGameIndex][whichRallyIndex] == "LL" && isWaitingForGhost && !isPaused{
				totalGhosts += 1
				whichRallyIndex += 1
				ghostsRemaning -= 1
				if placeArray[whichGameIndex][whichRallyIndex] == "let"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Let"
					whichPointIndex += 1
				}
				else if placeArray[whichGameIndex][whichRallyIndex] == "1"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Rest"
					if isPlayer1{
						player1Point += 1
						player1PointLabel.text = String(player1Point)
					}
					else{
						player2Point += 1
						player2PointLabel.text = String(player2Point)
					}
					whichPointIndex += 1
				}
				else if placeArray[whichGameIndex][whichRallyIndex] == "0"{
					writeValueFR(data: "0")
					writeValueFL(data: "0")
					writeValueCR(data: "0")
					writeValueCL(data: "0")
					writeValueLR(data: "0")
					writeValueLL(data: "0")
					whichCornerLabel.text = "Rest"
					if isPlayer1{
						player2Point += 1
						player2PointLabel.text = String(player2Point)
					}
					else{
						player1Point += 1
						player1PointLabel.text = String(player1Point)
					}
					whichPointIndex += 1
				}
				else{
					isWaitingForGhost = true
					if placeArray[whichGameIndex][whichRallyIndex] == "FR"{
						whichCornerLabel.text = "Front Right"
						playSound(sound: "Front-Right")
						writeValueFR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "FL"{
						whichCornerLabel.text = "Front Left"
						playSound(sound: "Front-Left")
						writeValueFL(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "CR"{
						whichCornerLabel.text = "Center Right"
						playSound(sound: "Center-Right")
						writeValueCR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "CL"{
						whichCornerLabel.text = "Center Left"
						playSound(sound: "Center-Left")
						writeValueCL(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "LR"{
						whichCornerLabel.text = "Back Right"
						playSound(sound: "Back-Right")
						writeValueLR(data: "1")
					}
					if placeArray[whichGameIndex][whichRallyIndex] == "LL"{
						whichCornerLabel.text = "Back Left"
						playSound(sound: "Back-Left")
						writeValueLL(data: "1")
					}
				}
				ghostsRemaningLabel.text = String(ghostsRemaning)
				
			}
		}
		NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: self)
	}
	
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
		print("*******************************************************")
		
		if error != nil {
			print("\(error.debugDescription)")
			return
		}
		guard let descriptors = characteristic.descriptors else { return }
		
		descriptors.forEach { descript in
			print("function name: DidDiscoverDescriptorForChar \(String(describing: descript.description))")
		}
	}
	
	
	func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
		print("*******************************************************")
		
		if (error != nil) {
			print("Error changing notification state:\(String(describing: error?.localizedDescription))")
			
		} else {
			print("Characteristic's value subscribed")
		}
		
		if (characteristic.isNotifying) {
			print ("Subscribed. Notification has begun for: \(characteristic.uuid)")
		}
	}
	
	
	
	func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		print("Disconnected")
		if !stopSelected{
		let alertVC = UIAlertController(title: "Not Connected To Devices", message: "Make sure that your bluetooth is turned on and all 6 devices are available.", preferredStyle: UIAlertController.Style.alert)
		self.centralManager.stopScan()
			self.circleTime.stop()
			self.totalTimeTimer.invalidate()
			self.disconnectAllConnection()
		let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
			self.dismiss(animated: true, completion: nil)
			self.navigationController?.popViewController(animated: true)
		})
		alertVC.addAction(action)
		self.present(alertVC, animated: true, completion: nil)
		}
	}
	
	
	func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		guard error == nil else {
			print("Error discovering services: error")
			return
		}
		print("Message sent")
	}
	
	func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
		guard error == nil else {
			print("Error discovering services: error")
			return
		}
		print("Succeeded!")
	}
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		if central.state == CBManagerState.poweredOn {
			print("Bluetooth Enabled")
			startScan()
			circleTime.font = UIFont(name: "System", size: 50 )
			circleTime.isHidden = false
			circleTime.isActive = true
			if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
				if let prepTime = try? context.fetch(PrepTime.fetchRequest()){
					let pTime = prepTime as! [PrepTime]
					if pTime.count != 0{
						circleTime.totalTime = Double(pTime[0].minutes * 60 + pTime[0].seconds)
						self.totalTime = -1 * Int(circleTime.totalTime) + 1
					}
					else{
						circleTime.totalTime = 10
						self.totalTime = -9
					}
				}
			}
			circleTime.elapsedTime = 0
			return
			
		} else {
			if central.state == CBManagerState.poweredOn && FRPeripheral != nil && FLPeripheral != nil && CRPeripheral != nil && CLPeripheral != nil && FRPeripheral != nil && FLPeripheral != nil {
				print("Bluetooth Enabled")
				circleTime.font = UIFont(name: "System", size: 50 )
				circleTime.isHidden = false
				circleTime.isActive = true
				if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
					if let prepTime = try? context.fetch(PrepTime.fetchRequest()){
						let pTime = prepTime as! [PrepTime]
						if pTime.count != 0{
							circleTime.totalTime = Double(pTime[0].minutes * 60 + pTime[0].seconds)
							self.totalTime = -1 * Int(circleTime.totalTime) + 1
						}
						else{
							circleTime.totalTime = 10
							self.totalTime = -9
						}
					}
				}
				circleTime.elapsedTime = 0
				startScan()
			}
			else{
				print("Bluetooth Disabled- Make sure your Bluetooth is turned on")
				
				let alertVC = UIAlertController(title: "Not Connected To Devices", message: "Make sure that your bluetooth is turned on and all 6 devices are available before starting the workout.", preferredStyle: UIAlertController.Style.alert)
				let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
					self.dismiss(animated: true, completion: nil)
					self.navigationController?.popViewController(animated: true)
				})
				alertVC.addAction(action)
				self.present(alertVC, animated: true, completion: nil)
			}
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		writeValueFR(data: "0")
		writeValueFL(data: "0")
		writeValueCR(data: "0")
		writeValueCL(data: "0")
		writeValueLR(data: "0")
		writeValueLL(data: "0")
		if segue.identifier == "ProWorkoutConnectionProgressViewControllerSegue" {
			if let childVC = segue.destination as? ProWorkoutConnectionProgressViewController {
				childVC.parentView = self
			}
		}
		if segue.identifier == "DoneProWorkoutViewControllerSegue" {
			if let childVC = segue.destination as? DoneProWorkoutViewController {
				totalTimeTimer.invalidate()
				childVC.finishedMatch = chosenMatch
				childVC.totalGhosts = totalGhosts
				childVC.missed = missedGhostCount
				childVC.games = whichGameIndex+1
				var seconds = totalTime
				var minutes = 0
				var hours = 0
				if seconds >= 60{
					minutes += seconds / 60
					seconds -= minutes * 60
				}
				if minutes >= 60{
					hours += minutes / 60
					minutes -= hours * 60
				}
				let totalTimeString = String(hours) + " : " + String(minutes) + " : " + String(seconds)
				childVC.totalTime = totalTimeString
				seconds = totalTime/(whichGameIndex+1)
				hours = 0
				minutes = 0
				if seconds >= 60{
					minutes += seconds / 60
					seconds -= minutes * 60
				}
				if minutes >= 60{
					hours += minutes / 60
					minutes -= hours * 60
				}
				let avgTimeString = String(hours) + " : " + String(minutes) + " : " + String(seconds)
				childVC.avgTime = avgTimeString
				if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
					let workout = Workout(context: context)
					workout.totalGhosts = Int16(totalGhosts)
					workout.totalTimeOnInSeconds = Int64(totalTime)
					workout.totalMissed = Int64(missedGhostCount)
					workout.sets = Int16(whichGameIndex + 1)
					workout.avgTimeOn = avgTimeString
					workout.totalTimeOn = totalTimeString
					workout.avgGhosts = Int16(totalGhosts/(whichGameIndex+1))
					if difficulty == "easy"{
						workout.difficulty = "Easy"
					}
					else if difficulty == "medium"{
						workout.difficulty = "Medium"
					}
					else if difficulty == "hard"{
						workout.difficulty = "Hard"
					}
					else if difficulty == "pro"{
						workout.difficulty = "Pro"
					}
					workout.date = Date()
					workout.ghostedCorners = "All"
					workout.greatestLevel = 0
					workout.matchName = chosenMatch.matchName
					workout.playerNames = chosenMatch.player1Name + " vs " + chosenMatch.player2Name
					workout.type = "Pro"
					workout.score = "N/A"
				}
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
			}
		}
	}
}

fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
