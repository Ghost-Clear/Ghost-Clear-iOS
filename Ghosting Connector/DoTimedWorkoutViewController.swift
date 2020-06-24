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

class DoTimedWorkoutViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate, AppusCircleTimerDelegate {
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
	var numMinutes : Int!
	var numSeconds : Int!
	var peripheralCount = 0
    @IBOutlet var circleTime: AppusCircleTimer!
    @IBAction func stopWorkout(_ sender: Any) {
        circleTime.isActive = false
        circleTime.isHidden = true
        circleTime.stop()
        centralManager.stopScan()
        disconnectAllConnection()
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet var workoutStartsIn: UILabel!
    
    func circleCounterTimeDidExpire(circleTimer: AppusCircleTimer) {
        circleTime.isActive = false
        circleTime.isHidden = true
        workoutStartsIn.isHidden = true
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
        workoutStartsIn.isHidden = true
        circleTime.delegate = self
         circleTime.font = UIFont(name: "System", size: 50 )
        circleTime.isBackwards = true
        circleTime.isActive = false
        circleTime.isHidden = true
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        updateIncomingData()
               
            // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          print("Stop Scanning")
          centralManager?.stopScan()
      }
    
    func updateIncomingData() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){
            notification in
                       
            
            
        }
    }
	
	@IBOutlet var FRbutton: UIButton!
	@IBAction func FR(_ sender: Any) {
		writeValueFR(data: "Hello")
	}
	
	
	@IBOutlet var FLbutton: UIButton!
	@IBAction func FL(_ sender: Any) {
		writeValueFL(data: "Hello")
	}
	
	
	@IBOutlet var CRbutton: UIButton!
	@IBAction func CR(_ sender: Any) {
		writeValueCR(data: "Hello")
	}
	
	
	@IBOutlet var CLbutton: UIButton!
	@IBAction func CL(_ sender: Any) {
		writeValueCL(data: "Hello")
	}
	
	
	@IBOutlet var LLbutton: UIButton!
	@IBAction func LL(_ sender: Any) {
		writeValueLL(data: "Hello")
	}
	
	
	
	@IBOutlet var LRbutton: UIButton!
	@IBAction func LR(_ sender: Any) {
		writeValueLR(data: "Hello")
	}
	
	
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
        
		if(peripheral.name == "FR"){
			FRPeripheral = peripheral
			FRPeripheral?.delegate = self
			centralManager?.connect(FRPeripheral!, options: nil)
			
		}
		if(peripheral.name == "FL"){
			FLPeripheral = peripheral
			FLPeripheral?.delegate = self
			centralManager?.connect(FLPeripheral!, options: nil)
		}
		if(peripheral.name == "CR"){
			CRPeripheral = peripheral
			CRPeripheral?.delegate = self
			centralManager?.connect(CRPeripheral!, options: nil)
		}
		if(peripheral.name == "CL"){
			CLPeripheral = peripheral
			CLPeripheral?.delegate = self
			centralManager?.connect(CLPeripheral!, options: nil)
		}
		if(peripheral.name == "LL"){
			LLPeripheral = peripheral
			LLPeripheral?.delegate = self
			centralManager?.connect(LLPeripheral!, options: nil)
		}
		if(peripheral.name == "LR"){
			LRPeripheral = peripheral
			LRPeripheral?.delegate = self
			centralManager?.connect(LRPeripheral!, options: nil)
		}
        self.peripherals.append(peripheral)
        self.RSSIs.append(RSSI)
        peripheral.delegate = self
		print("Peripheral name: \(String(describing: peripheral.name))")
            
        
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
				if peripheral.name == "FR"{
					frrxCharacteristic = characteristic
					peripheral.setNotifyValue(true, for: frrxCharacteristic!)
				}
				if peripheral.name == "FL"{
					flrxCharacteristic = characteristic
					peripheral.setNotifyValue(true, for: flrxCharacteristic!)
				}
				if peripheral.name == "CR"{
					crrxCharacteristic = characteristic
					peripheral.setNotifyValue(true, for: crrxCharacteristic!)
				}
				if peripheral.name == "CL"{
					clrxCharacteristic = characteristic
					peripheral.setNotifyValue(true, for: clrxCharacteristic!)
				}
				if peripheral.name == "LR"{
					lrrxCharacteristic = characteristic
					peripheral.setNotifyValue(true, for: lrrxCharacteristic!)
				}
				if peripheral.name == "LL"{
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
				if peripheral.name == "FR"{
					frtxCharacteristic = characteristic
				}
				if peripheral.name == "FL"{
					fltxCharacteristic = characteristic
					
				}
				if peripheral.name == "CR"{
					crtxCharacteristic = characteristic
					
				}
				if peripheral.name == "CL"{
					cltxCharacteristic = characteristic
					
				}
				if peripheral.name == "LR"{
					lrtxCharacteristic = characteristic
					
				}
				if peripheral.name == "LL"{
					lltxCharacteristic = characteristic
					
				}
                print("Tx Characteristic: \(characteristic.uuid)")
            }
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		if peripheral.name == "FR"{
			guard characteristic == frrxCharacteristic,
				let characteristicValue = characteristic.value,
				let ASCIIstring = NSString(data: characteristicValue,
										   encoding: String.Encoding.utf8.rawValue)
				else { return }
			characteristicASCIIValue = ASCIIstring
		}
		if peripheral.name == "FL"{
			guard characteristic == flrxCharacteristic,
				let characteristicValue = characteristic.value,
				let ASCIIstring = NSString(data: characteristicValue,
										   encoding: String.Encoding.utf8.rawValue)
				else { return }
			characteristicASCIIValue = ASCIIstring
		}
		if peripheral.name == "CR"{
			guard characteristic == crrxCharacteristic,
				let characteristicValue = characteristic.value,
				let ASCIIstring = NSString(data: characteristicValue,
										   encoding: String.Encoding.utf8.rawValue)
				else { return }
			characteristicASCIIValue = ASCIIstring
		}
		if peripheral.name == "CL"{
			guard characteristic == clrxCharacteristic,
				let characteristicValue = characteristic.value,
				let ASCIIstring = NSString(data: characteristicValue,
										   encoding: String.Encoding.utf8.rawValue)
				else { return }
			characteristicASCIIValue = ASCIIstring
		}
		if peripheral.name == "LR"{
			guard characteristic == lrrxCharacteristic,
				let characteristicValue = characteristic.value,
				let ASCIIstring = NSString(data: characteristicValue,
										   encoding: String.Encoding.utf8.rawValue)
				else { return }
			characteristicASCIIValue = ASCIIstring
		}
		if peripheral.name == "LL"{
			guard characteristic == llrxCharacteristic,
				let characteristicValue = characteristic.value,
				let ASCIIstring = NSString(data: characteristicValue,
										   encoding: String.Encoding.utf8.rawValue)
				else { return }
				characteristicASCIIValue = ASCIIstring
		}
		
        
        
        print("Value Recieved: \((characteristicASCIIValue as String))")
		if peripheral == FRPeripheral{
			//FRbutton.titleLabel?.text = characteristicASCIIValue as String
		}
		if peripheral == FLPeripheral{
			//FLbutton.titleLabel?.text = characteristicASCIIValue as String
		}
		if peripheral == CRPeripheral{
			//CRbutton.titleLabel?.text = characteristicASCIIValue as String
		}
		if peripheral == CLPeripheral{
			//CLbutton.titleLabel?.text = characteristicASCIIValue as String
		}
		if peripheral == LRPeripheral{
			//LRbutton.titleLabel?.text = characteristicASCIIValue as String
		}
		if peripheral == LLPeripheral{
			//LLbutton.titleLabel?.text = characteristicASCIIValue as String
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
            workoutStartsIn.isHidden = false
            startScan()
            circleTime.font = UIFont(name: "System", size: 50 )
            circleTime.isHidden = false
            circleTime.isActive = true
            circleTime.totalTime = 10
            circleTime.elapsedTime = 0
            circleTime.start()
            return
            
        } else {
            //If Bluetooth is off, display a UI alert message saying "Bluetooth is not enable" and "Make sure that your bluetooth is turned on"
            
			if central.state == CBManagerState.poweredOn && FRPeripheral != nil && FLPeripheral != nil && CRPeripheral != nil && CLPeripheral != nil && FRPeripheral != nil && FLPeripheral != nil {
            // We will just handle it the easy way here: if Bluetooth is on, proceed...start scan!
                print("Bluetooth Enabled")
                workoutStartsIn.isHidden = false
                circleTime.font = UIFont(name: "System", size: 50 )
                circleTime.isHidden = false
                circleTime.isActive = true
                circleTime.totalTime = 10
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
