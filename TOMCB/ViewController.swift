//
//  ViewController.swift
//  TOMCB
//
//  Created by Kayhan on 1/19/18.
//  Copyright © 2018 Kayhan. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, UITableViewDataSource {
    
    let UUID = CBUUID(string: "0x180D")
    var centralManager: CBCentralManager!;
    var mainPeripheral: CBPeripheral!
    var peripherals = [CBPeripheral]()
    var data = [String]()
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var bluetoothStatus: UILabel!
    @IBOutlet weak var deviceStatus: UILabel!
    @IBOutlet weak var scanIndicator: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            fatalError("Unknown Error")
        case .resetting:
            fatalError("Unknown Error")
        case .unsupported:
            fatalError("Unknown Error")
        case .unauthorized:
            fatalError("Unknown Error")
        case .poweredOff:
            print("Bluetooth OFF!")
            scanIndicator.text = "Bluetooth OFF"
        case .poweredOn:
            bluetoothStatus.text = "On";
            scanIndicator.text = "Scanning for devices"
            activityIndicator.startAnimating()
            centralManager.scanForPeripherals(withServices: nil);
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripherals.append(peripheral);
        data.append(peripheral.name!)
        table.reloadData()
        scanIndicator.text = "devices found"
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothStatus.text = "OFF"
        deviceStatus.text = "Disconnected"
        table.dataSource = self;
    }
    
    //MARK: Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Devices") as UITableViewCell! else {
            fatalError("Unable to create tables")
        }
        let text = data[indexPath.row]
        cell.textLabel?.text = text;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        mainPeripheral = peripherals[indexPath.row];
        centralManager.stopScan()
        scanIndicator.text = "Connecting"
        centralManager.connect(mainPeripheral)
        deviceStatus.text = "Connected"
        activityIndicator.stopAnimating();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


