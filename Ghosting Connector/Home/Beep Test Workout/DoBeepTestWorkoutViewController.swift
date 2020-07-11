//
//  DoBeepTestWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/5/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreBluetooth
import Foundation
import AppusCircleTimer
import CoreData
import AVFoundation
class DoBeepTestWorkoutViewController:  UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate, AppusCircleTimerDelegate {
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
	var FR : Bool! = true
	var FL : Bool! = true
	var CR : Bool! = true
	var CL : Bool! = true
	var LR : Bool! = true
	var LL : Bool! = true
	var peripheralCount = 0
	var isFirstPair : Bool!
	var FRname : String!
	var FLname : String!
	var CRname : String!
	var CLname : String!
	var LRname : String!
	var LLname : String!
	var isPrep = true
	var isWaiting = false
	var didConnect : Bool!
	var isPaused = false
	var level = 1
	var lives = 2
	var totalGhosts = 0
	var pendingGhosts = 6
	var cornersAvailable = ["FR","FL","CR","CL","LL","LR"]
	var nextGhost = ""
	var secondsToPlay : Double! = 5.3
	var totalTime = 0
	var centralManager : CBCentralManager!
	var peripheralManager: CBPeripheralManager?
	var RSSIs = [NSNumber]()
	var data = NSMutableData()
	var writeData: String = ""
	var stopSelected = false
	var peripherals: [CBPeripheral] = []
	var characteristicValue = [CBUUID: NSData]()
	var timer = Timer()
	var characteristics = [String : CBCharacteristic]()
	var totalTimeTimer : Timer! = Timer()
	@IBOutlet var circleTime: AppusCircleTimer!
	@IBOutlet weak var pauseButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!
	@IBOutlet weak var finishButton: UIButton!
	@IBOutlet weak var livesLabel: UILabel!
	func startTimer(){
		totalTimeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
	}
	func getNextGhost() -> String!{
		var toReturn : String!
		let orderCount = Int.random(in: 0..<cornersAvailable.count)
		toReturn = cornersAvailable[orderCount]
		return toReturn
	}
	@IBAction func pause(_ sender: Any) {
		isPaused = !isPaused
		if isPaused{
			totalTimeTimer.invalidate()
			isPaused = true
			pauseButton.setImage( UIImage(named: "Play Button"), for: .normal)
			self.circleTime.stop()
			writeValueFR(data: "0")
			writeValueFL(data: "0")
			writeValueCR(data: "0")
			writeValueCL(data: "0")
			writeValueLR(data: "0")
			writeValueLL(data: "0")
		}
		else{
			totalTimeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
			isPaused = false
			pauseButton.setImage( UIImage(named: "Pause Button"), for: .normal)
			self.circleTime.resume()
			if nextGhost == "FR" && isWaiting{
				writeValueFR(data: "1")
				playSound(sound: "Front-Right")
				whichCornerLabel.text = "Front Right"
			}
			if nextGhost == "FL" && isWaiting{
				writeValueFL(data: "1")
				playSound(sound: "Front-Left")
				whichCornerLabel.text = "Front Left"
			}
			if nextGhost == "CR" && isWaiting{
				writeValueCR(data: "1")
				playSound(sound: "Center-Right")
				whichCornerLabel.text = "Center Right"
			}
			if nextGhost == "CL" && isWaiting{
				writeValueCL(data: "1")
				playSound(sound: "Center-Left")
				whichCornerLabel.text = "Center Left"
			}
			if nextGhost == "LR" && isWaiting{
				writeValueLR(data: "1")
				playSound(sound: "Back-Right")
				whichCornerLabel.text = "Back Right"
			}
			if nextGhost == "LL" && isWaiting{
				writeValueLL(data: "1")
				playSound(sound: "Back-Left")
				whichCornerLabel.text = "Back Left"
			}
			
		}
	}
	func popBack(_ nb: Int) {
		if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
			guard viewControllers.count < nb else {
				self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
				return
			}
		}
	}
	@IBAction func stopWorkout(_ sender: Any) {
		stopSelected = true
		isWaiting = false
		circleTime.isActive = false
		circleTime.isHidden = true
		circleTime.stop()
		writeValueFR(data: "0")
		writeValueFL(data: "0")
		writeValueCR(data: "0")
		writeValueCL(data: "0")
		writeValueLR(data: "0")
		writeValueLL(data: "0")
		totalTimeTimer.invalidate()
		centralManager.stopScan()
		disconnectAllConnection()
		popBack(3)
		
	}
	func circleCounterTimeDidExpire(circleTimer: AppusCircleTimer) {
		if isWaiting && !isPrep{
			lives -= 1
		}
		livesLabel.text = String(lives)
		if lives == 0{
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
			centralManager.stopScan()
			disconnectAllConnection()
			playSound(sound: "success")
			performSegue(withIdentifier: "BeepTestWorkoutCheckPopupViewControllerSegue", sender: nil)
			let seconds = 1.51
			DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
				self.performSegue(withIdentifier: "DoneBeepTestWorkoutViewControllerSegue", sender: nil)
			}
		}
		isPrep = false
		isWaiting = true
		levelLabel.text = String(level)
		circleTime.totalTime = secondsToPlay
		circleTime.elapsedTime = 0
		circleTime.activeColor = UIColor(red: 26/256, green: 231/256, blue: 148/256, alpha: 1)
		circleTime.pauseColor = UIColor(red: 26/256, green: 231/256, blue: 148/256, alpha: 1)
		circleTime.start()
		if nextGhost == "FR"{
			playSound(sound: "Front-Right")
			writeValueFR(data: "1")
			whichCornerLabel.text = "Front Right"
		}
		if nextGhost == "FL"{
			playSound(sound: "Front-Left")
			writeValueFL(data: "1")
			whichCornerLabel.text = "Front Left"
		}
		if nextGhost == "CR"{
			playSound(sound: "Center-Right")
			writeValueCR(data: "1")
			whichCornerLabel.text = "Center Right"
		}
		if nextGhost == "CL"{
			playSound(sound: "Center-Left")
			writeValueCL(data: "1")
			whichCornerLabel.text = "Center Left"
		}
		if nextGhost == "LR"{
			playSound(sound: "Back-Right")
			writeValueLR(data: "1")
			whichCornerLabel.text = "Back Right"
		}
		if nextGhost == "LL"{
			playSound(sound: "Back-Left")
			writeValueLL(data: "1")
			whichCornerLabel.text = "Back Left"
		}
	}
	@IBOutlet weak var whichCornerLabel: UILabel!
	@IBOutlet weak var levelLabel: UILabel!
	@IBOutlet weak var ghostsLabel: UILabel!
	@IBAction func finish(_ sender: Any) {
		totalTimeTimer.invalidate()
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
		centralManager.stopScan()
		disconnectAllConnection()
		if isPrep{
			popBack(3)
		}
		else{
			playSound(sound: "success")
			performSegue(withIdentifier: "BeepTestWorkoutCheckPopupViewControllerSegue", sender: nil)
			let seconds = 1.51
			DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
				self.performSegue(withIdentifier: "DoneBeepTestWorkoutViewControllerSegue", sender: nil)
			}
		}
	}
	@objc func UpdateTimer(){
		totalTime += 1
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		pauseButton.contentMode = .scaleAspectFit
		stopButton.contentMode = .scaleAspectFit
		finishButton.contentMode = .scaleAspectFit
		circleTime.fontColor = UIColor.white
		whichCornerLabel.text = "Get Ready"
		circleTime.delegate = self
		circleTime.font = UIFont(name: "System", size: 50 )
		circleTime.isBackwards = true
		circleTime.isActive = false
		circleTime.isHidden = true
		centralManager = CBCentralManager(delegate: self, queue: nil)
		peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
		circleTime.fontColor = UIColor.white
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
		performSegue(withIdentifier: "BeepTestWorkoutConnectionProgressViewControllerSegue", sender: nil)
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
			}			
		}
		nextGhost = getNextGhost()
		cornersAvailable.remove(at: cornersAvailable.firstIndex(of: nextGhost)!)
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
		//Only look for services that matches transmit uuid
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
			//looks for the right characteristic
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
		if peripheral == FRPeripheral && isWaiting && nextGhost == "FR" && !isPaused{
			totalGhosts += 1
			pendingGhosts -= 1
			ghostsLabel.text = String(pendingGhosts)
			whichCornerLabel.text = "Rest"
			circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			writeValueFR(data: "0")
			writeValueFL(data: "0")
			writeValueCR(data: "0")
			writeValueCL(data: "0")
			writeValueLR(data: "0")
			writeValueLL(data: "0")
			if pendingGhosts == 0{
				cornersAvailable = ["FR","FL","CR","CL","LR","LL"]
				level += 1
				pendingGhosts = 6
				playSound(sound: "chime")
				secondsToPlay *= 0.9
			}
			isWaiting = false
			nextGhost = getNextGhost()
			cornersAvailable.remove(at: cornersAvailable.firstIndex(of: nextGhost)!)
		}
		else if peripheral == FLPeripheral && isWaiting && nextGhost == "FL" && !isPaused{
			totalGhosts += 1
			pendingGhosts -= 1
			ghostsLabel.text = String(pendingGhosts)
			whichCornerLabel.text = "Rest"
			circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			writeValueFR(data: "0")
			writeValueFL(data: "0")
			writeValueCR(data: "0")
			writeValueCL(data: "0")
			writeValueLR(data: "0")
			writeValueLL(data: "0")
			if pendingGhosts == 0{
				cornersAvailable = ["FR","FL","CR","CL","LR","LL"]
				level += 1
				pendingGhosts = 6
				playSound(sound: "chime")
				secondsToPlay *= 0.9
			}
			isWaiting = false
			nextGhost = getNextGhost()
			cornersAvailable.remove(at: cornersAvailable.firstIndex(of: nextGhost)!)
		}
		 else if peripheral == CRPeripheral && isWaiting && nextGhost == "CR" && !isPaused{
			totalGhosts += 1
			pendingGhosts -= 1
			ghostsLabel.text = String(pendingGhosts)
			whichCornerLabel.text = "Rest"
			circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			writeValueFR(data: "0")
			writeValueFL(data: "0")
			writeValueCR(data: "0")
			writeValueCL(data: "0")
			writeValueLR(data: "0")
			writeValueLL(data: "0")
			if pendingGhosts == 0{
				cornersAvailable = ["FR","FL","CR","CL","LR","LL"]
				level += 1
				pendingGhosts = 6
				playSound(sound: "chime")
				secondsToPlay *= 0.9
			}
			isWaiting = false
			nextGhost = getNextGhost()
			cornersAvailable.remove(at: cornersAvailable.firstIndex(of: nextGhost)!)
		}
		else if peripheral == CLPeripheral && isWaiting && nextGhost == "CL" && !isPaused{
			totalGhosts += 1
			pendingGhosts -= 1
			ghostsLabel.text = String(pendingGhosts)
			whichCornerLabel.text = "Rest"
			circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			writeValueFR(data: "0")
			writeValueFL(data: "0")
			writeValueCR(data: "0")
			writeValueCL(data: "0")
			writeValueLR(data: "0")
			writeValueLL(data: "0")
			if pendingGhosts == 0{
				cornersAvailable = ["FR","FL","CR","CL","LR","LL"]
				level += 1
				pendingGhosts = 6
				playSound(sound: "chime")
				secondsToPlay *= 0.9
			}
			isWaiting = false
			nextGhost = getNextGhost()
			cornersAvailable.remove(at: cornersAvailable.firstIndex(of: nextGhost)!)
		}
		else if peripheral == LRPeripheral && isWaiting && nextGhost == "LR" && !isPaused{
			totalGhosts += 1
			pendingGhosts -= 1
			ghostsLabel.text = String(pendingGhosts)
			whichCornerLabel.text = "Rest"
			circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			writeValueFR(data: "0")
			writeValueFL(data: "0")
			writeValueCR(data: "0")
			writeValueCL(data: "0")
			writeValueLR(data: "0")
			writeValueLL(data: "0")
			if pendingGhosts == 0{
				cornersAvailable = ["FR","FL","CR","CL","LR","LL"]
				level += 1
				pendingGhosts = 6
				playSound(sound: "chime")
				secondsToPlay *= 0.9
			}
			isWaiting = false
			nextGhost = getNextGhost()
			cornersAvailable.remove(at: cornersAvailable.firstIndex(of: nextGhost)!)
		}
		else if peripheral == LLPeripheral && isWaiting && nextGhost == "LL" && !isPaused{
			totalGhosts += 1
			pendingGhosts -= 1
			ghostsLabel.text = String(pendingGhosts)
			whichCornerLabel.text = "Rest"
			circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			writeValueFR(data: "0")
			writeValueFL(data: "0")
			writeValueCR(data: "0")
			writeValueCL(data: "0")
			writeValueLR(data: "0")
			writeValueLL(data: "0")
			if pendingGhosts == 0{
				cornersAvailable = ["FR","FL","CR","CL","LR","LL"]
				level += 1
				pendingGhosts = 6
				playSound(sound: "chime")
				secondsToPlay *= 0.9
			}
			isWaiting = false
			nextGhost = getNextGhost()
			cornersAvailable.remove(at: cornersAvailable.firstIndex(of: nextGhost)!)
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
		if !stopSelected{
			print("Disconnected")
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
						totalTime = Int(circleTime.totalTime * -1) + 1
					}
					else{
						circleTime.totalTime = 10
						totalTime = Int(circleTime.totalTime * -1) + 1
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
							totalTime = Int(circleTime.totalTime * -1) + 1
						}
						else{
							circleTime.totalTime = 10
							totalTime = Int(circleTime.totalTime * -1) + 1
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
		if segue.identifier == "BeepTestWorkoutConnectionProgressViewControllerSegue" {
			if let childVC = segue.destination as? BeepTestWorkoutConnectionProgressViewController {
				childVC.parentView = self
			}
		}
		if segue.identifier == "DoneBeepTestWorkoutViewControllerSegue" {
			if let childVC = segue.destination as? DoneBeepTestWorkoutViewController {
				totalTimeTimer.invalidate()
				childVC.totalGhost = totalGhosts
				childVC.greatestLevelAcheived = level
				var score = ""
				score += String(level) + "." + String(6-pendingGhosts)
				childVC.beepTestScore = score
				if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
					let workout = Workout(context: context)
					workout.score = score
					workout.type = "Beep Test"
					workout.sets = Int16(level)
					workout.totalGhosts = Int16(totalGhosts)
					workout.date = Date()
					workout.greatestLevel = Int16(level)
					workout.avgGhosts = 6
					var minutes = 0
					var hours = 0
					var seconds = totalTime
					var timeOnString = ""
					if seconds >= 60{
						minutes += Int(seconds/60)
						seconds -= minutes * 60
					}
					if minutes >= 60{
						hours += Int(minutes/60)
						minutes -= hours*60
					}
					timeOnString = String(hours) + " : "
					timeOnString += String(minutes) + " : " + String(seconds)
					workout.totalTimeOn = timeOnString
					totalTime /= level
					minutes = 0
					seconds = totalTime
					hours = 0
					timeOnString = ""
					if seconds >= 60{
						minutes += Int(seconds/60)
						seconds -= minutes * 60
					}
					if minutes >= 60{
						hours += Int(minutes/60)
						minutes -= hours*60
					}
					timeOnString = String(hours) + " : "
					timeOnString += String(minutes) + " : " + String(seconds)
					workout.avgTimeOn = timeOnString
					workout.ghostedCorners = "All Corners"
					childVC.totalTimeOn = workout.totalTimeOn
					workout.totalTimeOnInSeconds = Int64(totalTime)
					
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
