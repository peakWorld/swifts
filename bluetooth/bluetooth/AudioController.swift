import AudioToolbox

/// 系统音频控制器 (Core Audio 封装)
struct AudioController {
    /// 设置系统主音量 (0.0 ~ 1.0)
    /// - Parameter volume: 标准化音量值，超出范围自动修正
    static func setSystemVolume(_ volume: Float) {
        guard let defaultDeviceID = getDefaultOutputDevice() else {
            print("[AudioController] 错误: 未找到默认输出设备")
            return
        }
        
        // 音量范围标准化处理
        let normalizedVolume = volume.clamped(to: 0...1)
        
        // 配置 Core Audio 属性地址 (VirtualMainVolume)
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwareServiceDeviceProperty_VirtualMainVolume,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMain
        )
        
        // 检查设备是否支持音量控制
        guard isVolumeSettable(deviceID: defaultDeviceID, address: &address) else {
            print("[AudioController] 警告: 当前设备不支持软件音量控制")
            return
        }
        
        // 执行音量设置操作
        let status = AudioObjectSetPropertyData(
            defaultDeviceID,
            &address,
            0,
            nil,
            UInt32(MemoryLayout<Float>.size),
            &normalizedVolume
        )
        
        guard status == noErr else {
            print("[AudioController] 设置音量失败: \(status.description)")
            return
        }
    }
    
    // MARK: - 私有方法
    
    /// 获取默认输出设备ID
    private static func getDefaultOutputDevice() -> AudioDeviceID? {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        
        var deviceID: AudioDeviceID = 0
        var size = UInt32(MemoryLayout.size(ofValue: deviceID))
        
        let status = AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &address,
            0,
            nil,
            &size,
            &deviceID
        )
        
        guard status == noErr else {
            print("[AudioController] 获取默认设备失败: \(status.description)")
            return nil
        }
        return deviceID
    }
    
    /// 检查设备是否支持音量调节
    private static func isVolumeSettable(deviceID: AudioDeviceID, address: UnsafePointer<AudioObjectPropertyAddress>) -> Bool {
        var isSettable: DarwinBoolean = false
        let status = AudioObjectIsPropertySettable(deviceID, address, &isSettable)
        return status == noErr && isSettable.boolValue
    }
}

// MARK: - 扩展工具
extension Float {
    /// 数值范围限制
    fileprivate func clamped(to range: ClosedRange<Self>) -> Self {
        max(range.lowerBound, min(self, range.upperBound))
    }
}

extension OSStatus {
    /// 错误码描述转换
    fileprivate var description: String {
        switch self {
        case kAudioHardwareNoError: return "成功"
        case kAudioHardwareNotRunningError: return "音频服务未运行"
        case kAudioHardwareUnsupportedOperationError: return "不支持的操作"
        default: return "未知错误 (代码: \(self))"
        }
    }
}
