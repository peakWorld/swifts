import IOBluetooth
import Combine

/// 蓝牙设备管理类（macOS 专用）
final class BluetoothManager: NSObject, ObservableObject {
    
    // MARK: - 发布属性 (SwiftUI 绑定)
    
    /// 发现的设备列表（自动触发视图更新）
    @Published private(set) var devices: [IOBluetoothDevice] = []
    
    /// 当前连接设备（nil 表示未连接）
    @Published private(set) var connectedDevice: IOBluetoothDevice? = nil
    
    /// 是否正在搜索设备
    @Published private(set) var isDiscovering = false
    
    /// 最近发生的错误（自动显示警告）
    @Published private(set) var lastError: BluetoothError? = nil
    
    // MARK: - 私有属性
    
    /// 蓝牙设备搜索器（可选类型避免强制解包）
    private var inquiry: IOBluetoothDeviceInquiry?
    
    /// 正在尝试连接的设备地址（用于防止重复连接）
    fileprivate var pendingConnections = Set<String>()
    
    var showError: Bool {
        get { lastError != nil }
        set { if !newValue { lastError = nil } }
    }
    
    // MARK: - 初始化与销毁
    
    override init() {
        super.init()
        configureBluetoothInquiry()
    }
    
    deinit {
        inquiry?.stop() // 释放时停止搜索
        inquiry?.delegate = nil // 断开委托引用
    }
    
    /// 配置蓝牙搜索器（安全初始化）
    private func configureBluetoothInquiry() {
        // 使用安全方式创建实例
        inquiry = IOBluetoothDeviceInquiry(delegate: self)
        
        // 配置搜索参数（必须参数）
        inquiry?.inquiryLength = 60 // 搜索持续时间（秒）
        inquiry?.updateNewDeviceNames = true // 自动更新设备名称
        
        inquiry?.searchType = IOBluetoothDeviceSearchTypes(kIOBluetoothDeviceSearchClassic.rawValue) // 仅搜索经典设备
    }
    
    // 添加公共访问方法
    func isPendingConnection(for device: IOBluetoothDevice) -> Bool {
        pendingConnections.contains(device.addressString)
    }
    
    func addPendingConnection(for device: IOBluetoothDevice) {
        DispatchQueue.main.async {
            self.pendingConnections.insert(device.addressString)
        }
    }

    func removePendingConnection(for device: IOBluetoothDevice) {
        DispatchQueue.main.async {
            self.pendingConnections.remove(device.addressString)
        }
    }
    
    // MARK: - 公共方法
    
    /// 开始搜索设备（主线程安全）
    func startDiscovery() {
        guard !isDiscovering else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            do {
                try self.resetDiscoveryState()
                try self.startInquiry()
            } catch {
                self.handleError(error)
            }
        }
    }
    
    /// 停止搜索设备（线程安全）
    func stopDiscovery() {
        inquiry?.stop()
        isDiscovering = false
    }
    
    /// 连接指定设备（异步操作）
    func connect(to device: IOBluetoothDevice) {
        guard !pendingConnections.contains(device.addressString) else { return }
        
        pendingConnections.insert(device.addressString)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                try self.performDeviceConnection(device)
            } catch {
                self.handleError(error)
            }
            
            self.pendingConnections.remove(device.addressString)
        }
    }
    
    /// 断开当前连接
    func disconnect() {
        connectedDevice?.closeConnection()
        connectedDevice = nil
    }
    
    // MARK: - 错误处理
    
    /// 统一错误处理（主线程安全）
    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            if let btError = error as? BluetoothError {
                self.lastError = btError
            } else {
                self.lastError = .systemError(error.localizedDescription)
            }
        }
    }
    
    func clearError() {
        lastError = nil
    }
}

// MARK: - 蓝牙搜索委托协议
extension BluetoothManager: IOBluetoothDeviceInquiryDelegate {
    
    /// 发现新设备回调（后台线程）
    func deviceInquiryDeviceFound(
        _ sender: IOBluetoothDeviceInquiry!,
        device: IOBluetoothDevice!
    ) {
        
        // 过滤音频设备
        guard isAudioDevice(device) else { return }
        
        // 去重检查
        guard !devices.contains(where: { $0.addressString == device.addressString }) else {
            return
        }
        
        // 切换到主线程更新 UI
        DispatchQueue.main.async { [weak self] in
            self?.devices.append(device)
        }
    }
        
    /// 搜索完成回调（后台线程）
    func deviceInquiryComplete(
        _ sender: IOBluetoothDeviceInquiry!,
        error: IOReturn,
        aborted: Bool
    ) {
        DispatchQueue.main.async { [weak self] in
            self?.isDiscovering = false
            
            guard error != kIOReturnSuccess else { return }
            self?.handleError(BluetoothError.discoveryFailed(code: Int(error)))
        }
    }
}

// MARK: - 私有扩展方法
private extension BluetoothManager {
    /// 判断设备是否为音频设备（基于蓝牙设备类别）
        /// - Parameter device: 待检测的蓝牙设备
        /// - Returns: 是音频设备返回 true，否则返回 false
    func isAudioDevice(_ device: IOBluetoothDevice) -> Bool {
        // 获取设备的 Class of Device（设备类别编码）
        let cod = device.classOfDevice
        
        /* Class of Device 结构解析（按位）:
         - 第23-13位: 主要服务类别（Major Service Class）
         - 第12-8位: 主要设备类别（Major Device Class）
         - 第7-2位: 次要设备类别（Minor Device Class）
         - 第1-0位: 格式类型
         */
        
        // 提取主要设备类别（掩码 0x1F00 对应第8-12位）
        let majorDeviceClass = (cod & 0x1F00) >> 8
        
        // 判断是否为音视频设备大类（0x04 表示 Audio/Video 类别）
        return majorDeviceClass == 0x04
    }
    
    /// 重置搜索状态（主线程）
    func resetDiscoveryState() throws {
        devices.removeAll()
        pendingConnections.removeAll()
        
        guard inquiry != nil else {
            throw BluetoothError.inquiryNotReady
        }
    }
    
    /// 开始设备搜索（主线程）
    func startInquiry() throws {
        let result = inquiry?.start()
        
        guard result == kIOReturnSuccess else {
            throw BluetoothError.discoveryFailed(code: Int(result ?? -1))
        }
        
        isDiscovering = true
    }
    
    /// 执行设备连接（后台线程）
    func performDeviceConnection(_ device: IOBluetoothDevice) throws {
        let result = device.openConnection()
        
        guard result == kIOReturnSuccess else {
            throw BluetoothError.connectionFailed(code: Int(result))
        }
        
        // 注册连接状态监听
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleConnectionChange(_:)),
            name: NSNotification.Name("IOBluetoothDeviceConnectionStatusChanged"),
            object: device
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.connectedDevice = device
        }
    }
    
    /// 处理连接状态变化
    @objc func handleConnectionChange(_ notification: Notification) {
        guard let device = notification.object as? IOBluetoothDevice else { return }
        
        DispatchQueue.main.async { [weak self] in
            if !device.isConnected() {
                self?.connectedDevice = nil
            }
        }
    }
}

// MARK: - 错误类型定义
extension BluetoothManager {
    
    /// 蓝牙错误枚举（自定义可读描述）
    enum BluetoothError: LocalizedError {
        case inquiryNotReady        // 搜索器未就绪
        case discoveryFailed(code: Int) // 搜索失败
        case connectionFailed(code: Int) // 连接失败
        case systemError(String)    // 系统错误
        
        var errorDescription: String? {
            switch self {
            case .inquiryNotReady:
                return "蓝牙搜索器初始化失败"
            case .discoveryFailed(let code):
                return "设备搜索失败 (错误码: \(code))"
            case .connectionFailed(let code):
                return "设备连接失败 (错误码: \(code))"
            case .systemError(let msg):
                return "系统错误: \(msg)"
            }
        }
    }
}

