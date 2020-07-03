//
//  UUIDKey.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/13/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import Foundation
import CoreBluetooth
// file to store the UUID numbers of the Bluetooth Device
let kBLEService_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
let kBLE_Characteristic_uuid_Tx = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
let kBLE_Characteristic_uuid_Rx = "6e400003-b5a3-f393-e0a9-e50e24dcca9e"
let MaxCharacters = 20
let BLEService_UUID = CBUUID(string: kBLEService_UUID)
// write characteristic UUID
let BLE_Characteristic_uuid_Tx = CBUUID(string: kBLE_Characteristic_uuid_Tx)
//read characteristic UUIS
let BLE_Characteristic_uuid_Rx = CBUUID(string: kBLE_Characteristic_uuid_Rx)
