//
//  DoNumberedWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/24/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreBluetooth
import Foundation
import AppusCircleTimer
import CoreData
import AVFoundation
class DoNumberWorkoutViewController:  UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate, AppusCircleTimerDelegate {
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
	var FR : Bool!
	var FL : Bool!
	var CR : Bool!
	var CL : Bool!
	var LR : Bool!
	var LL : Bool!
	var isRandom : Bool!
	var numSets : Int!
	var numMinutesOn : Int!
	var numSecondsOn : Int!
	var numMinutesOff : Int!
	var numSecondsOff : Int!
	var peripheralCount = 0
	var checkTimer : Timer!
	var isFirstPair : Bool!
	var didConnect : Bool!
	var FRname : String!
	var FLname : String!
	var CRname : String!
	var CLname : String!
	var LRname : String!
	var LLname : String!
	var order : [String]!
	var setsToGo : Int!
	var ghostsToDo : Int!
	var counter = 1
	var stopWatch = Timer()
	var stopWatchIsPlaying = false
	var orderCount = 0
	var totalTimeinSeconds = 0
	var totalGhosts = 0
	var isWaitingForGhost = false
	var nextGhost : String!
	var cornersMet : [String]! = []
	var isRest = true
	var centralManager : CBCentralManager!
	var peripheralManager: CBPeripheralManager?
	var RSSIs = [NSNumber]()
	var data = NSMutableData()
	var writeData: String = ""
	var peripherals: [CBPeripheral] = []
	var characteristicValue = [CBUUID: NSData]()
	var timer = Timer()
	var characteristics = [String : CBCharacteristic]()
	@IBOutlet weak var finishWorkoutButton: UIButton!
	@IBOutlet weak var stopWorkoutButton: UIButton!
	@IBOutlet weak var setsLabel: UILabel!
	@IBOutlet weak var ghostsLabel: UILabel!
	@IBOutlet weak var stopWatchLabel: UILabel!
	@IBOutlet weak var whichGhostLabel: UILabel!
	@IBOutlet var circleTime: AppusCircleTimer!
	@IBOutlet weak var pauseButton: UIButton!
	var isPaused = false
	func popBack(_ nb: Int) {
		if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
			guard viewControllers.count < nb else {
				self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
				return
			}
		}
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
	// function to log when a corner is visited
	func meet(corner : String){
		for c in cornersMet{
			if c == corner{
				return
			}
		}
		cornersMet.append(corner)
	}
	@IBAction func stopWorkout(_ sender: Any) {
		circleTime.isActive = false
		circleTime.isHidden = true
		circleTime.stop()
		stopWatch.invalidate()
		writeValueFR(data: "0")
		writeValueFL(data: "0")
		writeValueCR(data: "0")
		writeValueCL(data: "0")
		writeValueLR(data: "0")
		writeValueLL(data: "0")
		centralManager.stopScan()
		disconnectAllConnection()
		popBack(3)
		
	}
	@IBAction func finishWorkout(_ sender: Any) {
		circleTime.isHidden = true
		circleTime.isActive = false
		if nextGhost == "FR"{
			writeValueFR(data: "0")
		}
		if nextGhost == "FL"{
			writeValueFL(data: "0")
		}
		if nextGhost == "CR"{
			writeValueCR(data: "0")
		}
		if nextGhost == "CL"{
			writeValueCL(data: "0")
		}
		if nextGhost == "LR"{
			writeValueLR(data: "0")
		}
		if nextGhost == "LL"{
			writeValueLL(data: "0")
		}
		circleTime.stop()
		stopWatch.invalidate()
		centralManager.stopScan()
		disconnectAllConnection()
		if numSets == setsToGo && isRest{
			popBack(4)
		}
		else{
			stopWatch.invalidate()
			playSound(sound: "success")
			performSegue(withIdentifier: "NumberWorkoutCheckPopupViewControllerSegue", sender: nil)
			let seconds = 1.51
			DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
				self.performSegue(withIdentifier: "DoneNumberWorkoutViewControllerSegue", sender: nil)
			}
		}
	}
	@IBAction func pause(_ sender: Any) {
		isPaused = !isPaused
		if isPaused{
			pauseButton.setImage( UIImage(named: "Play Button"), for: .normal)
			pauseStopWatch()
			if circleTime.isHidden == false{
				circleTime.stop()
			}
			circleTime.timerLabel?.textColor = UIColor(ciColor: .white)
			stopWatchLabel.textColor = UIColor(red: 75/256, green: 75/256, blue: 75/256, alpha: 1)
			writeValueFR(data: "0")
			writeValueFL(data: "0")
			writeValueCR(data: "0")
			writeValueCL(data: "0")
			writeValueLR(data: "0")
			writeValueLL(data: "0")
		}
		else{
			circleTime.timerLabel?.textColor = UIColor(ciColor: .white)
			stopWatch = Timer()
			stopWatch = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
			stopWatchIsPlaying = true
			stopWatchLabel.textColor = UIColor(red: 63/256, green: 219/256, blue: 156/256, alpha: 1)
			pauseButton.setImage( UIImage(named: "Pause Button"), for: .normal)
			if circleTime.isHidden == false{
				self.circleTime.resume()
			}
			isWaitingForGhost = true
			if nextGhost == "FR" && !isRest{
				writeValueFR(data: "1")
				whichGhostLabel.text = "Front Right"
				playSound(sound: "Front-Right")
			}
			else if nextGhost == "FL" && !isRest{
				writeValueFL(data: "1")
				whichGhostLabel.text = "Front Left"
				playSound(sound: "Front-Left")
			}
			else if nextGhost == "CR" && !isRest{
				writeValueCR(data: "1")
				whichGhostLabel.text = "Center Right"
				playSound(sound: "Center-Right")
			}
			else if nextGhost == "CL" && !isRest{
				writeValueCL(data: "1")
				whichGhostLabel.text = "Center Left"
				playSound(sound: "Center-Left")
			}
			else if nextGhost == "LR" && !isRest{
				writeValueLR(data: "1")
				whichGhostLabel.text = "Back Right"
				playSound(sound: "Back-Right")
			}
			else if nextGhost == "LL" && !isRest{
				writeValueLL(data: "1")
				whichGhostLabel.text = "Back Left"
				playSound(sound: "Back-Left")
			}
		}
	}
	func circleCounterTimeDidExpire(circleTimer: AppusCircleTimer) {
		isRest = false
		circleTime.isActive = false
		circleTime.isHidden = true
		ghostsLabel.text = String(ghostsToDo)
		circleTimer.isHidden = true
		stopWatchLabel.isHidden = false
		resetStopWatch()
		stopWatch = Timer()
		stopWatch = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
			stopWatchIsPlaying = true
		isWaitingForGhost = true
		nextGhost = getNextGhost()
		if nextGhost == "FR"{
			writeValueFR(data: "1")
			whichGhostLabel.text = "Front Right"
			playSound(sound: "Front-Right")
		}
		else if nextGhost == "FL"{
			writeValueFL(data: "1")
			whichGhostLabel.text = "Front Left"
			playSound(sound: "Front-Left")
		}
		else if nextGhost == "CR"{
			writeValueCR(data: "1")
			whichGhostLabel.text = "Center Right"
			playSound(sound: "Center-Right")
		}
		else if nextGhost == "CL"{
			writeValueCL(data: "1")
			whichGhostLabel.text = "Center Left"
			playSound(sound: "Center-Left")
		}
		else if nextGhost == "LR"{
			writeValueLR(data: "1")
			whichGhostLabel.text = "Back Right"
			playSound(sound: "Back-Right")
		}
		else if nextGhost == "LL"{
			writeValueLL(data: "1")
			whichGhostLabel.text = "Back Left"
			playSound(sound: "Back-Left")
		}
	}
	func pauseStopWatch(){
		stopWatch.invalidate()
		stopWatchIsPlaying = false
	}
	func resetStopWatch(){
		stopWatch.invalidate()
		stopWatchIsPlaying = false
		counter = 1
		stopWatchLabel.text = "0 : 0 : 1"
	}
	@objc func UpdateTimer(){
		counter += 1
		totalTimeinSeconds += 1
		var seconds = counter
		var minutes = 0
		var hours = 0
		if seconds >= 60{
			minutes += Int(seconds / 60)
			seconds -= (Int(seconds / 60) * 60)
		}
		if minutes >= 60{
			hours += Int(minutes / 60)
			minutes -= (Int(seconds / 60) * 60)
		}
		stopWatchIsPlaying = true
		stopWatchLabel.text = String(hours)
		stopWatchLabel.text! += " : " + String(minutes) + " : " + String(seconds)
	}
	// function to get the next place to ghost to
	func getNextGhost() -> String!{
		var toReturn : String!
		if isRandom{
			orderCount = Int.random(in: 0..<order.count)
			toReturn = order[orderCount]
		}
		else{
			toReturn = order[orderCount % order.count]
			orderCount += 1
		}
		return toReturn
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		stopWorkoutButton.imageView?.contentMode = .scaleAspectFit
		pauseButton.imageView?.contentMode = .scaleAspectFit
		finishWorkoutButton.imageView?.contentMode = .scaleAspectFit
		whichGhostLabel.text = "Get Ready"
		setsToGo = numSets
		stopWatchLabel.text = "0 : 0 : 1"
		circleTime.delegate = self
		circleTime.timerLabel?.textColor = UIColor(ciColor: .white)
		circleTime.font = UIFont(name: "System", size: 50 )
		circleTime.isBackwards = true
		circleTime.isActive = false
		circleTime.isHidden = true
		stopWatchLabel.isHidden = true
		setsLabel.text = String(setsToGo)
		ghostsLabel.text = String(ghostsToDo)
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
		performSegue(withIdentifier: "NumberWorkoutConnectionProgressViewControllerViewControllerSegue", sender: nil)
		DispatchQueue.main.asyncAfter(deadline: .now() + 4.2) {
			if !self.didConnect{
				let alertVC = UIAlertController(title: "Not Connected To Devices", message: "Make sure that your bluetooth is turned on and all the necessary devices are available before starting the workout.", preferredStyle: UIAlertController.Style.alert)
				self.centralManager.stopScan()
				let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
					self.dismiss(animated: true, completion: nil)
					self.popBack(3)
					self.disconnectAllConnection()
				})
				alertVC.addAction(action)
				self.present(alertVC, animated: true, completion: nil)
			}
			else{
				self.circleTime.start()
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
	// functions to write to the device
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
	func disconnectAllConnection() {
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
		//Only look for services that matches the UUID of the ghsoting device
		peripheral.discoverServices([BLEService_UUID])
	}
	func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		if error != nil {
			print("Failed to connect to peripheral")
			return
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
		// find the read and write characteristics of the device that matches the device UUID
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
		if peripheral == FRPeripheral && nextGhost == "FR" && isWaitingForGhost && !isRest && !isPaused{
			totalGhosts += 1
			ghostsLabel.text = String((ghostsLabel.text! as NSString).integerValue - 1)
			nextGhost = getNextGhost()
			if ghostsLabel.text == "0"{
				playSound(sound: "chime")
				circleTime.isHidden = false
				resetStopWatch()
				stopWatchLabel.isHidden = true
				isWaitingForGhost = false
				circleTime.totalTime = Double(numMinutesOff!) * 60 + Double(numSecondsOff)
				circleTime.elapsedTime = 0
				circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.start()
				circleTime.timerLabel?.textColor = UIColor(ciColor: .white)
				whichGhostLabel.text = "Rest"
				isRest = true
				setsToGo -= 1
				setsLabel.text = String(setsToGo)
				if nextGhost == "FR"{
					writeValueFR(data: "0")
				}
				if nextGhost == "FL"{
					writeValueFL(data: "0")
				}
				if nextGhost == "CR"{
					writeValueCR(data: "0")
				}
				if nextGhost == "CL"{
					writeValueCL(data: "0")
				}
				if nextGhost == "LR"{
					writeValueLR(data: "0")
				}
				if nextGhost == "LL"{
					writeValueLL(data: "0")
				}
			}
			else{
				if nextGhost == "FR"{
					writeValueFR(data: "1")
					whichGhostLabel.text = "Front Right"
					playSound(sound: "Front-Right")
				}
				else if nextGhost == "FL"{
					writeValueFL(data: "1")
					whichGhostLabel.text = "Front Left"
					playSound(sound: "Front-Left")
				}
				else if nextGhost == "CR"{
					writeValueCR(data: "1")
					whichGhostLabel.text = "Center Right"
					playSound(sound: "Center-Right")
				}
				else if nextGhost == "CL"{
					writeValueCL(data: "1")
					whichGhostLabel.text = "Center Left"
					playSound(sound: "Center-Left")
				}
				else if nextGhost == "LR"{
					writeValueLR(data: "1")
					whichGhostLabel.text = "Back Right"
					playSound(sound: "Back-Right")
				}
				else if nextGhost == "LL"{
					writeValueLL(data: "1")
					whichGhostLabel.text = "Back Left"
					playSound(sound: "Back-Left")
				}
			}
			meet(corner: "FR")
			
		}
		if peripheral == FLPeripheral && nextGhost == "FL" && isWaitingForGhost && !isRest && !isPaused{
			totalGhosts += 1
			ghostsLabel.text = String((ghostsLabel.text! as NSString).integerValue - 1)
			nextGhost = getNextGhost()
			if ghostsLabel.text == "0"{
				playSound(sound: "chime")
				resetStopWatch()
				circleTime.isHidden = false
				stopWatchLabel.isHidden = true
				isWaitingForGhost = false
				circleTime.totalTime = Double(numMinutesOff!) * 60 + Double(numSecondsOff)
				circleTime.elapsedTime = 0
				circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.start()
				circleTime.timerLabel?.textColor = UIColor(ciColor: .white)
				whichGhostLabel.text = "Rest"
				isRest = true
				setsToGo -= 1
				setsLabel.text = String(setsToGo)
				if nextGhost == "FR"{
					writeValueFR(data: "0")
				}
				if nextGhost == "FL"{
					writeValueFL(data: "0")
				}
				if nextGhost == "CR"{
					writeValueCR(data: "0")
				}
				if nextGhost == "CL"{
					writeValueCL(data: "0")
				}
				if nextGhost == "LR"{
					writeValueLR(data: "0")
				}
				if nextGhost == "LL"{
					writeValueLL(data: "0")
				}
			}
			else{
				if nextGhost == "FR"{
					writeValueFR(data: "1")
					whichGhostLabel.text = "Front Right"
					playSound(sound: "Front-Right")
				}
				else if nextGhost == "FL"{
					writeValueFL(data: "1")
					whichGhostLabel.text = "Front Left"
					playSound(sound: "Front-Left")
				}
				else if nextGhost == "CR"{
					writeValueCR(data: "1")
					whichGhostLabel.text = "Center Right"
					playSound(sound: "Center-Right")
				}
				else if nextGhost == "CL"{
					writeValueCL(data: "1")
					whichGhostLabel.text = "Center Left"
					playSound(sound: "Center-Left")
				}
				else if nextGhost == "LR"{
					writeValueLR(data: "1")
					whichGhostLabel.text = "Back Right"
					playSound(sound: "Back-Right")
				}
				else if nextGhost == "LL"{
					writeValueLL(data: "1")
					whichGhostLabel.text = "Back Left"
					playSound(sound: "Back-Left")
				}
			}
			meet(corner: "FL")
		}
		if peripheral == CRPeripheral && nextGhost == "CR" && isWaitingForGhost && !isRest && !isPaused{
			totalGhosts += 1
			ghostsLabel.text = String((ghostsLabel.text! as NSString).integerValue - 1)
			nextGhost = getNextGhost()
			if ghostsLabel.text == "0"{
				playSound(sound: "chime")
				resetStopWatch()
				circleTime.isHidden = false
				stopWatchLabel.isHidden = true
				isWaitingForGhost = false
				circleTime.totalTime = Double(numMinutesOff!) * 60 + Double(numSecondsOff)
				circleTime.elapsedTime = 0
				circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.start()
				circleTime.timerLabel?.textColor = UIColor(ciColor: .white)
				whichGhostLabel.text = "Rest"
				isRest = true
				setsToGo -= 1
				setsLabel.text = String(setsToGo)
				if nextGhost == "FR"{
					writeValueFR(data: "0")
				}
				if nextGhost == "FL"{
					writeValueFL(data: "0")
				}
				if nextGhost == "CR"{
					writeValueCR(data: "0")
				}
				if nextGhost == "CL"{
					writeValueCL(data: "0")
				}
				if nextGhost == "LR"{
					writeValueLR(data: "0")
				}
				if nextGhost == "LL"{
					writeValueLL(data: "0")
				}
			}
			else{
				if nextGhost == "FR"{
					writeValueFR(data: "1")
					whichGhostLabel.text = "Front Right"
					playSound(sound: "Front-Right")
				}
				else if nextGhost == "FL"{
					writeValueFL(data: "1")
					whichGhostLabel.text = "Front Left"
					playSound(sound: "Front-Left")
				}
				else if nextGhost == "CR"{
					writeValueCR(data: "1")
					whichGhostLabel.text = "Center Right"
					playSound(sound: "Center-Right")
				}
				else if nextGhost == "CL"{
					writeValueCL(data: "1")
					whichGhostLabel.text = "Center Left"
					playSound(sound: "Center-Left")
				}
				else if nextGhost == "LR"{
					writeValueLR(data: "1")
					whichGhostLabel.text = "Back Right"
					playSound(sound: "Back-Right")
				}
				else if nextGhost == "LL"{
					writeValueLL(data: "1")
					whichGhostLabel.text = "Back Left"
					playSound(sound: "Back-Left")
				}
			}
			meet(corner: "CR")
		}
		if peripheral == CLPeripheral && nextGhost == "CL" && isWaitingForGhost && !isRest && !isPaused{
			totalGhosts += 1
			ghostsLabel.text = String((ghostsLabel.text! as NSString).integerValue - 1)
			nextGhost = getNextGhost()
			if ghostsLabel.text == "0"{
				playSound(sound: "chime")
				circleTime.isHidden = false
				resetStopWatch()
				stopWatchLabel.isHidden = true
				isWaitingForGhost = false
				circleTime.totalTime = Double(numMinutesOff!) * 60 + Double(numSecondsOff)
				circleTime.elapsedTime = 0
				circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.start()
				circleTime.timerLabel?.textColor = UIColor(ciColor: .white)
				whichGhostLabel.text = "Rest"
				isRest = true
				setsToGo -= 1
				setsLabel.text = String(setsToGo)
				if nextGhost == "FR"{
					writeValueFR(data: "0")
				}
				if nextGhost == "FL"{
					writeValueFL(data: "0")
				}
				if nextGhost == "CR"{
					writeValueCR(data: "0")
				}
				if nextGhost == "CL"{
					writeValueCL(data: "0")
				}
				if nextGhost == "LR"{
					writeValueLR(data: "0")
				}
				if nextGhost == "LL"{
					writeValueLL(data: "0")
				}
			}
			else{
				if nextGhost == "FR"{
					writeValueFR(data: "1")
					whichGhostLabel.text = "Front Right"
					playSound(sound: "Front-Right")
				}
				else if nextGhost == "FL"{
					writeValueFL(data: "1")
					whichGhostLabel.text = "Front Left"
					playSound(sound: "Front-Left")
				}
				else if nextGhost == "CR"{
					writeValueCR(data: "1")
					whichGhostLabel.text = "Center Right"
					playSound(sound: "Center-Right")
				}
				else if nextGhost == "CL"{
					writeValueCL(data: "1")
					whichGhostLabel.text = "Center Left"
					playSound(sound: "Center-Left")
				}
				else if nextGhost == "LR"{
					writeValueLR(data: "1")
					whichGhostLabel.text = "Back Right"
					playSound(sound: "Back-Right")
				}
				else if nextGhost == "LL"{
					writeValueLL(data: "1")
					whichGhostLabel.text = "Back Left"
					playSound(sound: "Back-Left")
				}
			}
			meet(corner: "CL")
		}
		if peripheral == LRPeripheral && nextGhost == "LR" && isWaitingForGhost && !isRest && !isPaused{
			totalGhosts += 1
			ghostsLabel.text = String((ghostsLabel.text! as NSString).integerValue - 1)
			nextGhost = getNextGhost()
			if ghostsLabel.text == "0"{
				playSound(sound: "chime")
				circleTime.isHidden = false
				resetStopWatch()
				stopWatchLabel.isHidden = true
				isWaitingForGhost = false
				circleTime.totalTime = Double(numMinutesOff!) * 60 + Double(numSecondsOff)
				circleTime.elapsedTime = 0
				circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.start()
				circleTime.timerLabel?.textColor = UIColor(ciColor: .white)
				whichGhostLabel.text = "Rest"
				isRest = true
				setsToGo -= 1
				setsLabel.text = String(setsToGo)
				if nextGhost == "FR"{
					writeValueFR(data: "0")
				}
				if nextGhost == "FL"{
					writeValueFL(data: "0")
				}
				if nextGhost == "CR"{
					writeValueCR(data: "0")
				}
				if nextGhost == "CL"{
					writeValueCL(data: "0")
				}
				if nextGhost == "LR"{
					writeValueLR(data: "0")
				}
				if nextGhost == "LL"{
					writeValueLL(data: "0")
				}
			}
			else{
				if nextGhost == "FR"{
					writeValueFR(data: "1")
					whichGhostLabel.text = "Front Right"
					playSound(sound: "Front-Right")
				}
				else if nextGhost == "FL"{
					writeValueFL(data: "1")
					whichGhostLabel.text = "Front Left"
					playSound(sound: "Front-Left")
				}
				else if nextGhost == "CR"{
					writeValueCR(data: "1")
					whichGhostLabel.text = "Center Right"
					playSound(sound: "Center-Right")
				}
				else if nextGhost == "CL"{
					writeValueCL(data: "1")
					whichGhostLabel.text = "Center Left"
					playSound(sound: "Center-Left")
				}
				else if nextGhost == "LR"{
					writeValueLR(data: "1")
					whichGhostLabel.text = "Back Right"
					playSound(sound: "Back-Right")
				}
				else if nextGhost == "LL"{
					writeValueLL(data: "1")
					whichGhostLabel.text = "Back Left"
					playSound(sound: "Back-Left")
				}
			}
			meet(corner: "LR")
		}
		if peripheral == LLPeripheral && nextGhost == "LL" && isWaitingForGhost && !isRest && !isPaused{
			totalGhosts += 1
			ghostsLabel.text = String((ghostsLabel.text! as NSString).integerValue - 1)
			nextGhost = getNextGhost()
			if ghostsLabel.text == "0"{
				playSound(sound: "chime")
				circleTime.isHidden = false
				stopWatchLabel.isHidden = true
				isWaitingForGhost = false
				resetStopWatch()
				circleTime.totalTime = Double(numMinutesOff!) * 60 + Double(numSecondsOff)
				circleTime.elapsedTime = 0
				circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
				circleTime.start()
				circleTime.timerLabel?.textColor = UIColor(ciColor: .white)
				whichGhostLabel.text = "Rest"
				isRest = true
				setsToGo -= 1
				setsLabel.text = String(setsToGo)
				if nextGhost == "FR"{
					writeValueFR(data: "0")
				}
				if nextGhost == "FL"{
					writeValueFL(data: "0")
				}
				if nextGhost == "CR"{
					writeValueCR(data: "0")
				}
				if nextGhost == "CL"{
					writeValueCL(data: "0")
				}
				if nextGhost == "LR"{
					writeValueLR(data: "0")
				}
				if nextGhost == "LL"{
					writeValueLL(data: "0")
				}
			}
			else{
				if nextGhost == "FR"{
					writeValueFR(data: "1")
					whichGhostLabel.text = "Front Right"
					playSound(sound: "Front-Right")
				}
				else if nextGhost == "FL"{
					writeValueFL(data: "1")
					whichGhostLabel.text = "Front Left"
					playSound(sound: "Front-Left")
				}
				else if nextGhost == "CR"{
					writeValueCR(data: "1")
					whichGhostLabel.text = "Center Right"
					playSound(sound: "Center-Right")
				}
				else if nextGhost == "CL"{
					writeValueCL(data: "1")
					whichGhostLabel.text = "Center Left"
					playSound(sound: "Center-Left")
				}
				else if nextGhost == "LR"{
					writeValueLR(data: "1")
					whichGhostLabel.text = "Back Right"
					playSound(sound: "Back-Right")
				}
				else if nextGhost == "LL"{
					writeValueLL(data: "1")
					whichGhostLabel.text = "Back Left"
					playSound(sound: "Back-Left")
				}
			}
			meet(corner: "LL")
		}
		if setsToGo == 0{
			circleTime.stop()
			circleTime.isHidden = true
			circleTime.isActive = false
			centralManager.stopScan()
			disconnectAllConnection()
			isWaitingForGhost = false
			stopWatch.invalidate()
			playSound(sound: "success")
			performSegue(withIdentifier: "NumberWorkoutCheckPopupViewControllerSegue", sender: nil)
			let seconds = 1.51
			DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
				self.performSegue(withIdentifier: "DoneNumberWorkoutViewControllerSegue", sender: nil)
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
		if (peripheral == FRPeripheral && FR) || (peripheral == FLPeripheral && FL) || (peripheral == CRPeripheral && CR) || (peripheral == CLPeripheral && CL) || (peripheral == LRPeripheral && LR) || (peripheral == LLPeripheral && LL){
			let alertVC = UIAlertController(title: "Not Connected To Devices", message: "Make sure that your bluetooth is turned on and all the neccessary devices are available.", preferredStyle: UIAlertController.Style.alert)
			self.centralManager.stopScan()
			let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
				self.dismiss(animated: true, completion: nil)
				self.navigationController?.popViewController(animated: true)
				self.circleTime.stop()
				self.stopWatch.invalidate()
				self.disconnectAllConnection()
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
					}
					else{
						circleTime.totalTime = 10
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
						}
						else{
							circleTime.totalTime = 10
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
		if segue.identifier == "DoneNumberWorkoutViewControllerSegue" {
			if let childVC = segue.destination as? DoneNumberWorkoutViewController {
				if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
					let workout = Workout(context: context)
					workout.type = "Number"
					workout.score = "N/A"
					workout.greatestLevel = 0
					workout.sets = Int16(numSets - setsToGo)
					if workout.sets == 0{
						workout.sets = 1
					}
					workout.totalGhosts = Int16(totalGhosts)
					if numSets - setsToGo == 0{
						workout.avgGhosts = Int16(ghostsToDo - (ghostsLabel.text! as NSString).integerValue)
					}
					else{
						workout.avgGhosts = Int16(totalGhosts/(numSets-setsToGo))
					}
					var hours = 0
					var minutes = 0
					var seconds = totalTimeinSeconds
					if seconds >= 60{
						minutes += Int(seconds / 60)
						seconds -= (Int(seconds / 60) * 60)
					}
					if minutes >= 60{
						hours += Int(minutes / 60)
						minutes -= Int(minutes / 60) * 60
					}
					workout.totalTimeOnInSeconds = Int64(totalTimeinSeconds)
					workout.totalTimeOn = String(hours) + " : "
					workout.totalTimeOn! += String(minutes) + " : " + String(seconds)
					if (numSets - setsToGo) != 0{
						seconds = seconds / (numSets - setsToGo)
					}
					hours = 0
					minutes = 0
					if seconds >= 60{
						minutes += Int(seconds / 60)
						seconds -= (Int(seconds / 60) * 60)
					}
					if minutes >= 60{
						hours += Int(minutes / 60)
						minutes -= Int(minutes / 60) * 60
					}
					workout.avgTimeOn = String(hours) + " : "
					workout.avgTimeOn! += String(minutes) + " : " + String(seconds)
					workout.date = Date()
					var allCorners = ""
					for i in cornersMet{
						if i == "FR"{
							allCorners += "Front Right. "
						}
						if i == "FL"{
							allCorners += "Front Left. "
						}
						if i == "CR"{
							allCorners += "Center Right. "
						}
						if i == "CL"{
							allCorners += "Center Left. "
						}
						if i == "LR"{
							allCorners += "Back Right. "
						}
						if i == "LL"{
							allCorners += "Back Left. "
						}
					}
					workout.ghostedCorners = allCorners
					childVC.totalTimeOn = workout.totalTimeOn
					childVC.avgTime = workout.avgTimeOn
					childVC.totalGhosts = Int(workout.totalGhosts)
					childVC.ghostedCorners = allCorners
					var allGoalsFromCore : [Goal] = []
					if let goalsFromCore = try? context.fetch(Goal.fetchRequest()){
						allGoalsFromCore = goalsFromCore as! [Goal]
						print ()
					}
					for goal in allGoalsFromCore{
						let goalGhosts = goal.ghosts
						let goalMinutes = goal.minutes
						let goalSeconds = goal.seconds
						let goalSets = goal.sets
						if (numSets - setsToGo) >= goalSets{
							if totalTimeinSeconds <= (goalMinutes*60 + goalSeconds)*goal.sets && workout.totalGhosts > goalGhosts*goal.sets{
								goal.isCompleted = true
							}
						}
					}
				}
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
			}
		}
		if segue.identifier == "NumberWorkoutConnectionProgressViewControllerViewControllerSegue" {
			if let childVC = segue.destination as? NumberWorkoutConnectionProgressViewController {
				childVC.parentView = self
				
			}
		}
	}
}
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
