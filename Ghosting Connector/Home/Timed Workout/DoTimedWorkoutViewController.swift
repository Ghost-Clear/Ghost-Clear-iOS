//
//  DoTimedWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/12/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreBluetooth
import Foundation
import AppusCircleTimer
import CoreData
import AVFoundation
class DoTimedWorkoutViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate, AppusCircleTimerDelegate {
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
	var isPaused : Bool! = false
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
	var numSecondsOn : Int! = 0
	var numMinutesOff : Int!
	var numSecondsOff : Int!
	var peripheralCount = 0
	var checkTimer : Timer!
	var isFirstPair : Bool!
	var FRname : String!
	var FLname : String!
	var CRname : String!
	var CLname : String!
	var LRname : String!
	var LLname : String!
	var isRest : Bool! = true
	var setsToGo : Int!
	var ghostsDone : Int! = 0
	var order : [String]!
	var orderCount = 0
	var nextGhost : String!
	var currentGhosts : Int! = 0
	var cornersMet : [String]! = []
    @IBOutlet var circleTime: AppusCircleTimer!
	@IBOutlet weak var setsLabel: UILabel!
	@IBOutlet weak var ghostsLabel: UILabel!
	@IBOutlet weak var whichGhostLabel: UILabel!
	@IBOutlet weak var stopButton: UIButton!
	@IBOutlet weak var pauseButton: UIButton!
	@IBOutlet weak var finishButton: UIButton!
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
	@IBAction func stopWorkout(_ sender: Any) {
        circleTime.isActive = false
        circleTime.isHidden = true
        circleTime.stop()
        centralManager.stopScan()
        disconnectAllConnection()
        popBack(3)
		
    }
    
	
	@IBAction func pauseWorkout(_ sender: Any) {
		isPaused = !isPaused
		if isPaused{
			pauseButton.setImage( UIImage(named: "play"), for: .normal)
			self.circleTime.stop()
			writeValueFR(data: "0")
			writeValueFL(data: "0")
			writeValueCR(data: "0")
			writeValueCL(data: "0")
			writeValueLR(data: "0")
			writeValueLL(data: "0")

		}
		else{
			pauseButton.setImage( UIImage(named: "pause"), for: .normal)
			self.circleTime.resume()
			if nextGhost == "FR" && !isRest{
				writeValueFR(data: "1")
				playSound(sound: "Front-Right")
				whichGhostLabel.text = "Front Right"
			}
			if nextGhost == "FL" && !isRest{
				writeValueFL(data: "1")
				playSound(sound: "Front-Left")
				whichGhostLabel.text = "Front Left"
			}
			if nextGhost == "CR" && !isRest{
				writeValueCR(data: "1")
				playSound(sound: "Center-Right")
				whichGhostLabel.text = "Center Right"
			}
			if nextGhost == "CL" && !isRest{
				writeValueCL(data: "1")
				playSound(sound: "Center-Left")
				whichGhostLabel.text = "Center Left"
			}
			if nextGhost == "LR" && !isRest{
				writeValueLR(data: "1")
				playSound(sound: "Back-Right")
				whichGhostLabel.text = "Back Right"
			}
			if nextGhost == "LL" && !isRest{
				writeValueLL(data: "1")
				playSound(sound: "Back-Left")
				whichGhostLabel.text = "Back Left"
			}
			
		}
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
		centralManager.stopScan()
		disconnectAllConnection()
		if numSets == setsToGo && isRest{
			popBack(4)
		}
		else{
			performSegue(withIdentifier: "TimedWorkoutCheckPopUpViewControllerSegue", sender: nil)
			let seconds = 1.51
			DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
				self.performSegue(withIdentifier: "DoneTimedWorkoutViewControllerSegue", sender: nil)
			}
			
		}
		
	}
	func meet(corner : String){
		for c in cornersMet{
			if c == corner{
				return
			}
		}
		cornersMet.append(corner)
	}
    func circleCounterTimeDidExpire(circleTimer: AppusCircleTimer) {
		if isRest && setsToGo != 0{
			circleTime.totalTime = Double(numMinutesOn) * 60 + Double(numSecondsOn)
			circleTime.elapsedTime = 0
			circleTime.activeColor = UIColor(red: 26/256, green: 231/256, blue: 148/256, alpha: 1)
			circleTime.pauseColor = UIColor(red: 26/256, green: 231/256, blue: 148/256, alpha: 1)
			
			circleTime.start()
			isRest = false
			ghostsDone = 0
			ghostsLabel.text = String(ghostsDone)
			nextGhost = getNextGhost()
			if nextGhost == "FR"{
				writeValueFR(data: "1")
				playSound(sound: "Front-Right")
				whichGhostLabel.text = "Front Right"
			}
			else if nextGhost == "FL"{
				writeValueFL(data: "1")
				playSound(sound: "Front-Left")
				whichGhostLabel.text = "Front Left"
			}
			else if nextGhost == "CR"{
				writeValueCR(data: "1")
				playSound(sound: "Center-Right")
				whichGhostLabel.text = "Center Right"
			}
			else if nextGhost == "CL"{
				writeValueCL(data: "1")
				playSound(sound: "Center-Left")
				whichGhostLabel.text = "Center Left"
			}
			else if nextGhost == "LR"{
				writeValueLR(data: "1")
				playSound(sound: "Back-Right")
				whichGhostLabel.text = "Back Right"
			}
			else  if nextGhost == "LL"{
				writeValueLL(data: "1")
				playSound(sound: "Back-Left")
				whichGhostLabel.text = "Back Left"
			}
		}
		else if setsToGo != 0 && !isRest{
			playSound(sound: "chime")
			circleTime.totalTime = Double(numMinutesOff!) * 60 + Double(numSecondsOff)
			circleTime.elapsedTime = 0
			circleTime.activeColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			circleTime.pauseColor = UIColor(red: 255/256, green: 88/256, blue: 96/256, alpha: 1)
			circleTime.start()
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
		if setsToGo == 0{
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
			centralManager.stopScan()
			disconnectAllConnection()
			performSegue(withIdentifier: "TimedWorkoutCheckPopUpViewControllerSegue", sender: nil)
			let seconds = 1.51
			DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
				self.performSegue(withIdentifier: "DoneTimedWorkoutViewControllerSegue", sender: nil)
			}
			
			
		}
		
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
    override func viewDidLoad() {
        super.viewDidLoad()
		stopButton.imageView?.contentMode = .scaleAspectFit
		pauseButton.imageView?.contentMode = .scaleAspectFit
		finishButton.imageView?.contentMode = .scaleAspectFit
		whichGhostLabel.text = "Get Ready"
		setsToGo = numSets
		setsLabel.text = String(setsToGo)
        circleTime.delegate = self
         circleTime.font = UIFont(name: "System", size: 50 )
        circleTime.isBackwards = true
        circleTime.isActive = false
        circleTime.isHidden = true
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //updateIncomingData()
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
		checkTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { timer in
			if self.FRPeripheral == nil || self.FLPeripheral == nil || self.CRPeripheral == nil || self.CLPeripheral == nil || self.LRPeripheral == nil || self.LLPeripheral == nil{
				self.circleTime.stop()
				let alertVC = UIAlertController(title: "Not Connected To Devices", message: "Make sure that your bluetooth is turned on and all 6 devices are available before starting the workout.", preferredStyle: UIAlertController.Style.alert)
				self.centralManager.stopScan()
				let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
					self.dismiss(animated: true, completion: nil)
					//add segue
					self.disconnectFromDevice()
					self.popBack(3)
					self.disconnectAllConnection()
				})
				alertVC.addAction(action)
				if self.navigationController?.visibleViewController == self{
					self.present(alertVC, animated: true, completion: nil)
				}
				
			}
		})
		// Do any additional setup after loading the view.
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
    
    /*
	func updateIncomingData() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){
            notification in
                       
            
            
        }
    }*/
	
	
	
    func writeValueFR(data: String){
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        //change the "data" to valueString
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
		//change the "data" to valueString
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
		//change the "data" to valueString
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
		//change the "data" to valueString
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
		//change the "data" to valueString
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
		//change the "data" to valueString
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
        if FRPeripheral != nil {
            // We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
            // Therefore, we will just disconnect from the peripheral
            centralManager?.cancelPeripheralConnection(FRPeripheral!)
        }
		if FLPeripheral != nil {
			// We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
			// Therefore, we will just disconnect from the peripheral
			centralManager?.cancelPeripheralConnection(FLPeripheral!)
		}
		if CRPeripheral != nil {
			// We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
			// Therefore, we will just disconnect from the peripheral
			centralManager?.cancelPeripheralConnection(CRPeripheral!)
		}
		if CLPeripheral != nil {
			// We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
			// Therefore, we will just disconnect from the peripheral
			centralManager?.cancelPeripheralConnection(CLPeripheral!)
		}
		if LRPeripheral != nil {
			// We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
			// Therefore, we will just disconnect from the peripheral
			centralManager?.cancelPeripheralConnection(LRPeripheral!)
		}
		if LLPeripheral != nil {
			// We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
			// Therefore, we will just disconnect from the peripheral
			centralManager?.cancelPeripheralConnection(LLPeripheral!)
		}
    }
    func restoreCentralManager() {
        //Restores Central Manager delegate if something went wrong
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
				//let finalData = joke()
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
				//let finalData = joke()
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
				//let finalData = joke()
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
				//let finalData = joke()
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
				//let finalData = joke()
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
        //Stop Scan- We don't need to scan once we've connected to a peripheral. We got what we came for.
		if peripheralCount == 6{
			//centralManager?.stopScan()
			print("Scan Stopped")
		}
        //Erase data that we might have
        data.length = 0
        //Discovery callback
        peripheral.delegate = self
        //Only look for services that matches transmit uuid
        peripheral.discoverServices([BLEService_UUID])
        
        
        //Once connected, move to new view controller to manager incoming and outgoing data
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if error != nil {
            print("Failed to connect to peripheral")
            return
        }
    }
    
    func disconnectAllConnection() {
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
        //We need to discover the all characteristic
        for service in services {
            
            peripheral.discoverCharacteristics(nil, for: service)
            // bleService = service
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
				
                
                //Once found, subscribe to the this particular characteristic...
                // We can return after calling CBPeripheral.setNotifyValue because CBPeripheralDelegate's
                // didUpdateNotificationStateForCharacteristic method will be called automatically
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
		if peripheral == FRPeripheral && nextGhost == "FR" && !isRest && !isPaused{
			nextGhost = getNextGhost()
			isRest = false
			ghostsDone += 1
			ghostsLabel.text = String(ghostsDone)
			meet(corner: "FR")
			currentGhosts += 1
			if nextGhost == "FR"{
				writeValueFR(data: "1")
				playSound(sound: "Front-Right")
				whichGhostLabel.text = "Front Right"
			}
			else if nextGhost == "FL"{
				writeValueFL(data: "1")
				playSound(sound: "Front-Left")
				whichGhostLabel.text = "Front Left"
			}
			else if nextGhost == "CR"{
				writeValueCR(data: "1")
				playSound(sound: "Center-Right")
				whichGhostLabel.text = "Center Right"
			}
			else if nextGhost == "CL"{
				writeValueCL(data: "1")
				playSound(sound: "Center-Left")
				whichGhostLabel.text = "Center Left"
			}
			else if nextGhost == "LR"{
				writeValueLR(data: "1")
				playSound(sound: "Back-Right")
				whichGhostLabel.text = "Back Right"
			}
			else if nextGhost == "LL"{
				writeValueLL(data: "1")
				playSound(sound: "Back-Left")
				whichGhostLabel.text = "Back Left"
			}
			
		}
		else if peripheral == FLPeripheral && nextGhost == "FL" && !isRest && !isPaused{
			isRest = false
			nextGhost = getNextGhost()
			isRest = false
			ghostsDone += 1
			ghostsLabel.text = String(ghostsDone)
			meet(corner: "FL")
			currentGhosts += 1
			if nextGhost == "FR"{
				writeValueFR(data: "1")
				playSound(sound: "Front-Right")
				whichGhostLabel.text = "Front Right"
			}
			else if nextGhost == "FL"{
				writeValueFL(data: "1")
				playSound(sound: "Front-Left")
				whichGhostLabel.text = "Front Left"
			}
			else if nextGhost == "CR"{
				writeValueCR(data: "1")
				playSound(sound: "Center-Right")
				whichGhostLabel.text = "Center Right"
			}
			else if nextGhost == "CL"{
				writeValueCL(data: "1")
				playSound(sound: "Center-Left")
				whichGhostLabel.text = "Center Left"
			}
			else if nextGhost == "LR"{
				writeValueLR(data: "1")
				playSound(sound: "Back-Right")
				whichGhostLabel.text = "Back Right"
			}
			else if nextGhost == "LL"{
				writeValueLL(data: "1")
				playSound(sound: "Back-Left")
				whichGhostLabel.text = "Back Left"
			}
			
		}
		else if peripheral == CRPeripheral && nextGhost == "CR" && !isRest && !isPaused{
			
			isRest = false
			nextGhost = getNextGhost()
			ghostsDone += 1
			ghostsLabel.text = String(ghostsDone)
			meet(corner: "CR")
			currentGhosts += 1
			if nextGhost == "FR"{
				writeValueFR(data: "1")
				playSound(sound: "Front-Right")
				whichGhostLabel.text = "Front Right"
			}
			else if nextGhost == "FL"{
				writeValueFL(data: "1")
				playSound(sound: "Front-Left")
				whichGhostLabel.text = "Front Left"
			}
			else if nextGhost == "CR"{
				writeValueCR(data: "1")
				playSound(sound: "Center-Right")
				whichGhostLabel.text = "Center Right"
			}
			else if nextGhost == "CL"{
				writeValueCL(data: "1")
				playSound(sound: "Center-Left")
				whichGhostLabel.text = "Center Left"
			}
			else if nextGhost == "LR"{
				writeValueLR(data: "1")
				playSound(sound: "Back-Right")
				whichGhostLabel.text = "Back Right"
			}
			else if nextGhost == "LL"{
				writeValueLL(data: "1")
				playSound(sound: "Back-Left")
				whichGhostLabel.text = "Back Left"
			}
			
		}
		else if peripheral == CLPeripheral && nextGhost == "CL" && !isRest && !isPaused{
			
			nextGhost = getNextGhost()
			
			ghostsDone += 1
			ghostsLabel.text = String(ghostsDone)
			meet(corner: "CL")
			currentGhosts += 1
			isRest = false
			if nextGhost == "FR"{
				writeValueFR(data: "1")
				playSound(sound: "Front-Right")
				whichGhostLabel.text = "Front Right"
			}
			if nextGhost == "FL"{
				writeValueFL(data: "1")
				playSound(sound: "Front-Left")
				whichGhostLabel.text = "Front Left"
			}
			if nextGhost == "CR"{
				writeValueCR(data: "1")
				playSound(sound: "Center-Right")
				whichGhostLabel.text = "Center Right"
			}
			if nextGhost == "CL"{
				writeValueCL(data: "1")
				playSound(sound: "Center-Left")
				whichGhostLabel.text = "Center Left"
			}
			if nextGhost == "LR"{
				writeValueLR(data: "1")
				playSound(sound: "Back-Right")
				whichGhostLabel.text = "Back Right"
			}
			if nextGhost == "LL"{
				writeValueLL(data: "1")
				playSound(sound: "Back-Left")
				whichGhostLabel.text = "Back Left"
			}
			
		}
		else if peripheral == LRPeripheral && nextGhost == "LR" && !isRest && !isPaused{
			
			isRest = false
			nextGhost = getNextGhost()
			
			ghostsDone += 1
			ghostsLabel.text = String(ghostsDone)
			meet(corner: "LR")
			currentGhosts += 1
			if nextGhost == "FR"{
				writeValueFR(data: "1")
				playSound(sound: "Front-Right")
				whichGhostLabel.text = "Front Right"
			}
			else if nextGhost == "FL"{
				writeValueFL(data: "1")
				playSound(sound: "Front-Left")
				whichGhostLabel.text = "Front Left"
			}
			else if nextGhost == "CR"{
				writeValueCR(data: "1")
				playSound(sound: "Center-Right")
				whichGhostLabel.text = "Center Right"
			}
			else if nextGhost == "CL"{
				writeValueCL(data: "1")
				playSound(sound: "Center-Left")
				whichGhostLabel.text = "Center Left"
			}
			else if nextGhost == "LR"{
				writeValueLR(data: "1")
				playSound(sound: "Back-Right")
				whichGhostLabel.text = "Back Right"
			}
			else if nextGhost == "LL"{
				writeValueLL(data: "1")
				playSound(sound: "Back-Left")
				whichGhostLabel.text = "Back Left"
			}
			
		}
		else if peripheral == LLPeripheral && nextGhost == "LL" && !isRest && !isPaused{
			isRest = false
			nextGhost = getNextGhost()
			ghostsDone += 1
			ghostsLabel.text = String(ghostsDone)
			meet(corner: "LL")
			currentGhosts += 1
			if nextGhost == "FR"{
				writeValueFR(data: "1")
				playSound(sound: "Front-Right")
				whichGhostLabel.text = "Front Right"
			}
			else if nextGhost == "FL"{
				writeValueFL(data: "1")
				playSound(sound: "Front-Left")
				whichGhostLabel.text = "Front Left"
			}
			else if nextGhost == "CR"{
				writeValueCR(data: "1")
				playSound(sound: "Center-Right")
				whichGhostLabel.text = "Center Right"
			}
			else if nextGhost == "CL"{
				writeValueCL(data: "1")
				playSound(sound: "Center-Left")
				whichGhostLabel.text = "Center Left"
			}
			else if nextGhost == "LR"{
				writeValueLR(data: "1")
				playSound(sound: "Back-Right")
				whichGhostLabel.text = "Back Right"
			}
			else if nextGhost == "LL"{
				writeValueLL(data: "1")
				playSound(sound: "Back-Left")
				whichGhostLabel.text = "Back Left"
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
    

    
    
    
    /*
     Invoked when the central manager’s state is updated.
     This is where we kick off the scan if Bluetooth is turned on.
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            // We will just handle it the easy way here: if Bluetooth is on, proceed...start scan!
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
            circleTime.start()
            return
            
        } else {
            //If Bluetooth is off, display a UI alert message saying "Bluetooth is not enable" and "Make sure that your bluetooth is turned on"
            
			if central.state == CBManagerState.poweredOn && FRPeripheral != nil && FLPeripheral != nil && CRPeripheral != nil && CLPeripheral != nil && FRPeripheral != nil && FLPeripheral != nil {
            // We will just handle it the easy way here: if Bluetooth is on, proceed...start scan!
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
                circleTime.start()
                startScan()
            }
            else{
                print("Bluetooth Disabled- Make sure your Bluetooth is turned on")
                
                let alertVC = UIAlertController(title: "Not Connected To Devices", message: "Make sure that your bluetooth is turned on and all 6 devices are available before starting the workout.", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                    //add segue
                    self.navigationController?.popViewController(animated: true)
                })
                alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "DoneTimedWorkoutViewControllerSegue" {
			if let childVC = segue.destination as? DoneTimedWorkoutViewController {
				//Some property on ChildVC that needs to be set
				var shownMinutesLeft = ((circleTime.timerLabel?.text?.prefix(2))! as NSString).integerValue
				var shownSecondsLeft = ((circleTime.timerLabel?.text?.suffix(2))! as NSString).integerValue
				if isRest{
					shownMinutesLeft = numMinutesOn
					shownSecondsLeft = numSecondsOn
				}
				childVC.minutesOn = (numMinutesOn * (numSets-setsToGo))
				childVC.minutesOn = childVC.minutesOn + (numMinutesOn - shownMinutesLeft)
				childVC.secondsOn = (numSecondsOn * (numSets-setsToGo))
				childVC.secondsOn = childVC.secondsOn + (numSecondsOn - shownSecondsLeft)
				// had to split up expressions above because swift compiler was timing out
				childVC.totalghosts = currentGhosts
				childVC.numSets = numSets - setsToGo
				childVC.ghostedCorners = cornersMet
				
				if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
					let workout = Workout(context: context)
					workout.type = "Timed"
					workout.sets = Int16(childVC.numSets)
					if childVC.numSets == 0{
						childVC.numSets = 1
					}
					if workout.sets == 0{
						workout.sets = 1
					}
					workout.totalGhosts = Int16(currentGhosts)
					workout.totalTimeOnInSeconds = Int64(childVC.minutesOn * 60 + childVC.secondsOn)
					if numSets - setsToGo == 0{
						workout.avgGhosts = Int16(currentGhosts)
					}
					else{
						workout.avgGhosts = Int16(currentGhosts/(numSets-setsToGo))
					}
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
					var hours = 0
					var mins = childVC.minutesOn!
					var seconds = childVC.secondsOn!
					if seconds >= 60{
						mins += Int(seconds / 60)
						seconds -= (Int(seconds / 60) * 60)
					}
					if mins >= 60{
						hours += Int(mins / 60)
						mins -= Int(mins / 60) * 60
					}
					workout.totalTimeOn = (String(hours) + " : ")
					workout.totalTimeOn! +=  String(mins) + " : " + String(seconds)
					var totalSeconds = hours*360 + mins*60 + seconds
					if childVC.numSets == 0{
						if isRest{
							totalSeconds = 0
						}
						else{
							totalSeconds = (numMinutesOn - shownMinutesLeft) * 60
							totalSeconds += (numSecondsOn - shownSecondsLeft)
						}
					}
					else{
						totalSeconds /= childVC.numSets
					}
					seconds = totalSeconds
					if seconds >= 60{
						mins = Int(seconds / 60)
						seconds -= Int(seconds / 60) * 60
					}
					if mins >= 60{
						hours += mins / 60
						mins -= Int(mins / 60) * 60
					}
					workout.avgTimeOn = String(hours) + " : "
					workout.avgTimeOn! += String(mins) + " : " + String(seconds)
					workout.date = Date()
					
					// check goals now
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
						if childVC.numSets >= goalSets{
							if childVC.minutesOn*60 + childVC.secondsOn <= (goalMinutes*60 + goalSeconds) * goal.sets && currentGhosts > goalGhosts*goal.sets{
								goal.isCompleted = true
							}
						}
					}
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
