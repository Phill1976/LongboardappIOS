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
		manager = NRFManager(delegate: self, autoConnect: true);
		manager.connect( "naemSetUpINTHeArduineCode" )
		manager.writeString("test!!")
		
	}
	func sendBluetooth(power: CGFloat){
		print("sended power: \(power) to the longboard")
	}
	
}
extension BluetoothLB : NRFManagerDelegate{
	func nrfDidConnect(_ nrfManager:NRFManager){
		
	}
	func nrfDidDisconnect(_ nrfManager:NRFManager){
		
	}
	func nrfReceivedData(_ nrfManager:NRFManager, data:Data?, string:String?){
		
	}
}
