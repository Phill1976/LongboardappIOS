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

	var lastTime: Double

	init() {
		manager = NRFManager(autoConnect: true)
		lastTime = Date().timeIntervalSince1970

	}
	func sendBluetooth(power: CGFloat, force: Bool = false){

		var p = power
		if p <= 0 { p = 0}

		if Date().timeIntervalSince1970 - lastTime > 0.05 || force{
			var intPower = UInt8(p * 255)

			let _ = manager.writeData(Data(bytes: &intPower, count: 1))

			lastTime = Date().timeIntervalSince1970
		}
		print("sended power: \(power) to the longboard")
	}

	func connect(){
		manager.connect( "UART" )
	}
}

