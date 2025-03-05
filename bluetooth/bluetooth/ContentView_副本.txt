import SwiftUI
import IOBluetooth

struct ContentView: View {
    // MARK: - 状态管理
    // @StateObject 自动管理蓝牙管理器生命周期
    @StateObject private var bluetoothManager = BluetoothManager()
    // @State 管理当前选中的蓝牙设备（macOS 需要显式管理选中状态）
    @State private var selectedDevice: IOBluetoothDevice?
    // @State 管理音量滑动条数值
    @State private var volume: Float = 0.5
    
    // MARK: - 主界面布局
    var body: some View {
        VStack(spacing: 16) {
            // 设备列表区域
            deviceListSection()
            
            // 音量控制区域（macOS 需要特别处理滑动条样式）
            volumeControlSection()
            
            // 控制按钮区域（适配 macOS 按钮样式）
            controlButtonSection()
        }
        .padding()
        .frame(width: 500, height: 400) // 固定窗口尺寸（macOS 典型尺寸）
        // 错误提示处理
        .alert("蓝牙错误",
               isPresented: $bluetoothManager.showError,
               presenting: bluetoothManager.lastError) { error in
            Button("确定") { bluetoothManager.clearError() }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
    
    // MARK: - 子视图组件
    
    /// 设备列表区域
    private func deviceListSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("可用设备:")
                .font(.headline)
                .foregroundColor(.secondary)
            
            List(bluetoothManager.devices, id: \.addressString) { device in
                HStack {
                    // 设备名称显示（macOS 需要处理可选值）
                    Text(device.name ?? "未知设备")
                        .font(.system(size: 14, design: .monospaced))
                    
                    Spacer()
                    
                    // 连接状态指示器
                    connectionStatusIndicator(for: device)
                    
                    // 连接按钮（适配 macOS 按钮样式）
                    connectButton(for: device)
                }
                .padding(8)
                .background(selectedDevice == device ? Color.blue.opacity(0.1) : Color.clear)
                .cornerRadius(8)
            }
            .listStyle(.plain) // macOS 专用列表样式
            .frame(height: 200) // 固定列表高度
        }
    }
    
    /// 音量控制区域
    private func volumeControlSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("系统音量:")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack {
                // 滑动条组件（适配 macOS 滑动条样式）
                Slider(value: $volume, in: 0...1) {
                    Text("音量")
                }
                .disabled(bluetoothManager.connectedDevice == nil) // 无连接时禁用
                
                // 音量百分比显示（macOS 典型数值显示方式）
                Text("\(Int(volume * 100))%")
                    .font(.system(.body, design: .monospaced))
                    .frame(width: 50)
            }
            .onChange(of: volume) { _, newValue in
                // 音量调整逻辑（macOS 需要主线程操作）
                DispatchQueue.main.async {
                    AudioController.setSystemVolume(newValue)
                }
            }
        }
    }
    
    /// 控制按钮区域
    private func controlButtonSection() -> some View {
        HStack(spacing: 16) {
            // 开始搜索按钮
            Button(action: {
                bluetoothManager.startDiscovery()
            }) {
                Label("开始搜索", systemImage: "antenna.radiowaves.left.and.right")
            }
            .disabled(bluetoothManager.isDiscovering) // 正在搜索时禁用
            
            // 停止搜索按钮
            Button(action: {
                bluetoothManager.stopDiscovery()
            }) {
                Label("停止搜索", systemImage: "xmark.circle")
            }
            .disabled(!bluetoothManager.isDiscovering) // 未搜索时禁用
            
            Spacer()
            
            // 连接状态指示
            if let device = bluetoothManager.connectedDevice {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("已连接: \(device.name ?? "未知设备")")
                        .font(.caption)
                }
            }
        }
        .buttonStyle(.bordered) // macOS 专用按钮样式
        .controlSize(.large) // 大尺寸控件（符合 macOS 设计规范）
    }
    
    // MARK: - 辅助组件
    
    /// 连接状态指示器
    @ViewBuilder
    private func connectionStatusIndicator(for device: IOBluetoothDevice) -> some View {
        if device.isConnected() {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        } else if bluetoothManager.isPendingConnection(for: device) {
            ProgressView()
                .controlSize(.small)
        }
    }
    
    /// 连接按钮
    private func connectButton(for device: IOBluetoothDevice) -> some View {
        Button {
            if device.isConnected() {
                bluetoothManager.disconnect()
            } else {
                bluetoothManager.addPendingConnection(for: device)
                bluetoothManager.connect(to: device)
            }
        } label: {
            Text(device.isConnected() ? "断开" : "连接")
                .foregroundColor(bluetoothManager.isPendingConnection(for: device) ? .gray : .blue)
        }
        .disabled(bluetoothManager.isPendingConnection(for: device))
    }
    
    // MARK: - 操作处理
    
    /// 处理设备连接/断开
    private func handleConnect(for device: IOBluetoothDevice) {
        selectedDevice = device
        if device.isConnected() {
            device.closeConnection()
        } else {
            // macOS 需要异步执行蓝牙操作
            DispatchQueue.global(qos: .userInitiated).async {
                let _ = bluetoothManager.connect(to: device)
            }
        }
    }
}
