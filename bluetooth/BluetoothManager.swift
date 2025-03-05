import IOBluetooth
import Combine

class BluetoothManager: NSObject, ObservableObject {
    @Published var devices: [IOBluetoothDevice] = []
    private var inquiry: IOBluetoothDeviceInquiry!
    
    override init() {
        super.init()
        inquiry = IOBluetoothDeviceInquiry(delegate: self)
        inquiry.updateNewDeviceNames = true
        inquiry.inquiryLength = 8
    }
    
    func startDiscovery() {
        devices.removeAll()
        do {
            try inquiry.start()
        } catch {
            print("Discovery error: \(error)")
        }
    }
    
    func stopDiscovery() {
        inquiry.stop()
    }
    
    func connect(to device: IOBluetoothDevice) -> Bool {
        let result = device.openConnection()
        return result == kIOReturnSuccess
    }
}

extension BluetoothManager: IOBluetoothDeviceInquiryDelegate {
    func deviceInquiryDeviceFound(_ sender: IOBluetoothDeviceInquiry!, device: IOBluetoothDevice!) {
        DispatchQueue.main.async {
            if !self.devices.contains(where: { $0.addressString == device.addressString }) {
                self.devices.append(device)
            }
        }
    }
    
    func deviceInquiryComplete(_ sender: IOBluetoothDeviceInquiry!, error: IOReturn, aborted: Bool) {
        print("Discovery completed")
    }
}
