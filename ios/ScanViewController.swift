//
//  ScanViewController.swift
//  reactnativemoko
//
//  Created by Joyson P S on 25/04/21.
//

import UIKit

class ScanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  private func setUp(){
      self.title = "Available moko devices"
      MKLifeBLECentralManager.shared().startScan()
      
  }
  private func configureDevice(){
      let date = Date()
      let dateModel = MKConfigDeviceDateModel(date:date)
      MKLifeBLEInterface.configDeviceTime(dateModel) {
          let vc: ConnectedViewController = self.getViewController(with: "ConnectedViewController")
          self.push(viewController: vc)
      } failedBlock: { (err) in
          self.presentAlertWithTitle(title: "Failed", message: "Failed to connect update time error\(err.localizedDescription)", options: [.ok]) { (_) in
          }
      }
  }
  private func connectToDevice(){
    let selectedDevice = self.deviceData[indexPath.row]
    MKLifeBLECentralManager.shared().connectPeripheral(selectedDevice.peripheral) { (connectedperiphera) in
        self.configureDevice()
    } failedBlock: { (err) in
        self.presentAlertWithTitle(title: "Failed", message: "Failed to connect with device with error\(err.localizedDescription)", options: [.ok]) { (_) in
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

extension ScanViewController: MKLifeBLECentralManagerDelegate{
    func mokoLifeBleScanNewDevice(_ deviceModel: MKLifeBLEDeviceModel) {
  
        deviceData.append(deviceModel)
        MKLifeBLECentralManager.shared().stopScan()
        self.deviceListTableView.reloadData()
    }

    
}
extension ScanViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc: ConnectedViewController = self.getViewController(with: "ConnectedViewController")
//        self.push(viewController: vc)
//        print("device selected",self.deviceData[indexPath.row].deviceName)
//        print("device selected",self.deviceData[indexPath.row].macAddress)
     
    }
 
    
}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.deviceData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text =  self.deviceData[indexPath.row].deviceName
        return cell
    }
    
    
}
