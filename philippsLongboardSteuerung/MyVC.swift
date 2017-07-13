//
//  ViewController.swift
//  philippsLongboardSteuerung
//

import UIKit
import AudioToolbox // importiert Datenbank für 3D Touch 

class MyVC: UIViewController {
    let MAX_SCROLL: CGFloat = 150
    let START_FORCE: CGFloat = 3

	var ble: BluetoothLB!
    var unlocked = false
    var driving = false
    
    @IBOutlet weak var topBarDist: NSLayoutConstraint!
    @IBOutlet weak var sideBar: UIView!
    
    @IBOutlet weak var innerHandle: UIView!
    @IBOutlet weak var outerHandle: UIView!
    @IBOutlet weak var powerLabel: UILabel!
	@IBOutlet weak var verbinden: UIButton!



    var pan: UIPanGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
		ble = BluetoothLB()
		ble.manager.delegate = self
		ble.connect()
		pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
		outerHandle.alpha = 0
        view.addGestureRecognizer(pan)
    }

    override func viewDidAppear(_ animated: Bool) {
        innerHandle.layer.cornerRadius = innerHandle.frame.width/2
        outerHandle.layer.cornerRadius = outerHandle.frame.width/2
        resetPosition()
        topBarDist.constant = view.frame.height
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !unlocked else {
            return
        }
        if let t = touches.first{
            if #available(iOS 9.0, *){
                if traitCollection.forceTouchCapability == .available{
                    let f = t.force
                    if f > START_FORCE{
                        let loc = t.location(in: view)
                        setCurser(position: loc)
                        fadeInCurser()
                        AudioServicesPlaySystemSound(1520)
                        unlocked = true
                    }
                    print(f)
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        deactivate()
    }

	@IBAction func verbindenPressed(_ sender: Any) {
		ble.connect()
	}
    func deactivate(){
        unlocked = false
        driving = false
        fadeOutCurser()
		ble.sendBluetooth(power: 0, force: true)
    }
    func handlePan(){
        guard unlocked else {
            print("notUnlocked so pan doesnt work")
            return
        }
        if pan.state == .began{
            driving = true
        }
        let y = pan.translation(in: view).y
        var percent = getCutToPercent(val: -y / MAX_SCROLL)
        let labelText = "\(percent * 100)"
        var shortLabelText = ""
        if labelText.characters.count > 4{
            shortLabelText = labelText.substring(to: labelText.index(labelText.startIndex, offsetBy: 4))
        }
        let loc = pan.location(in: view)
        setCurser(position: loc)
        powerLabel.text = shortLabelText
        if pan.state == .ended{
            deactivate()
            percent = 0
        }
        updateBar(power: percent)
        ble.sendBluetooth(power: percent)
    }
    
    func fadeInCurser(){
        UIView.animate(withDuration: 0.2){
            self.outerHandle.alpha = 1
        }
    }
    func fadeOutCurser(){
        UIView.animate(withDuration: 0.2){
            self.outerHandle.alpha = 0
        }
    }
    func resetPosition(){
        let w = view.frame.width
        let h = view.frame.height
        setCurser(position: CGPoint(x:w/2, y: h/2))
    }
    
    func setCurser(position: CGPoint){
        let size = outerHandle.frame.width
        outerHandle.frame.origin.x = position.x - (0.5 * size)
        outerHandle.frame.origin.y = position.y - (0.5 * size)
    }
    func updateBar(power: CGFloat){
        //power is from 1 to -1
        if power < 0{
            sideBar.backgroundColor = UIColor.red
        }else{
            sideBar.backgroundColor = UIColor.white
        }
        let h = view.frame.height
        //(max) 0 - h (min)
        if power == 0{
            UIView.animate(withDuration: 0.2, animations: {
                self.topBarDist.constant = h
                self.view.layoutIfNeeded()
            })
        }else{
            topBarDist.constant = h - abs(power) * h
        }
    }
}

func getCutToPercent(val: CGFloat) -> CGFloat{
    var returnVal = val
    if returnVal > 1{
        returnVal = 1
    }
    if returnVal < -1{
        returnVal = -1
    }
    return returnVal
}

extension MyVC : NRFManagerDelegate {
	func nrfDidConnect(_ nrfManager:NRFManager){
		verbinden.isEnabled = false
		verbinden.isHidden = true

		ble.sendBluetooth(power: 0, force: true)
	}
	func nrfDidDisconnect(_ nrfManager:NRFManager){
		verbinden.isEnabled = true
		verbinden.isHidden = false
	}
	func nrfReceivedData(_ nrfManager:NRFManager, data:Data?, string:String?){
	}
}



