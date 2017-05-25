//
//  Blluetoth.swift
//  philippsLongboardSteuerung
//
//  Created by me on 26/11/16.
//  Copyright © 2016 none. All rights reserved.
//

import UIKit
import CoreBluetooth
import Foundation


class BluetoothLB{
	var manager: NRFManager
	init() {
		manager = NRFManager();
	}
	func sendBluetooth(power: CGFloat){
		print("sended power: \(power) to the longboard")
	}
	
}
