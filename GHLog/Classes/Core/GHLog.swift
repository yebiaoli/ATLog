//
//  GHLog.swift
//  GHLog
//
//  Created by abiaoyo on 2024/12/30.
//

@objc
public enum GHLogLevel:Int {
    case off
    case error
    case warn
    case info
    case debug
    case verbose
    
    public var key_short:String {
        switch self {
        case .off: "o"
        case .error: "e"
        case .warn: "w"
        case .info: "i"
        case .debug: "d"
        case .verbose: "v"
        }
    }
}

@objc
public protocol GHLogDelegate: AnyObject {
    func log(level:GHLogLevel, log:String, tag:String?, message:String)
}

fileprivate struct _GHLogService {
    static var weakContainer = NSHashTable<AnyObject>.weakObjects()
    static var delegates:[GHLogDelegate] {
        let objs = weakContainer.allObjects.compactMap({ $0 as? GHLogDelegate })
        return objs
    }
    static func add(delegate:GHLogDelegate) {
        weakContainer.add(delegate)
    }
    static func remove(delegate:GHLogDelegate) {
        weakContainer.remove(delegate)
    }
}

@objcMembers
final public class GHLogOC:NSObject {
    /// 日志级别
    public static var level:GHLogLevel {
        get { GHLog.level }
        set { GHLog.level = newValue }
    }
    
    public static func add(delegate:GHLogDelegate) {
        _GHLogService.add(delegate: delegate)
    }
    public static func remove(delegate:GHLogDelegate) {
        _GHLogService.remove(delegate: delegate)
    }
    
    public static func log(_ level:GHLogLevel, tag:String? = nil, messageCallback:(() -> String)) {
        GHLog.log(level, tag: tag, messageCallback: messageCallback)
    }
}

final public class GHLog {
    #if DEBUG
    public static var level:GHLogLevel = .debug
    #else
    public static var level:GHLogLevel = .off
    #endif
    
    private static let formatter = DateFormatter()

    public static func add(delegate:GHLogDelegate) {
        _GHLogService.add(delegate: delegate)
    }
    public static func remove(delegate:GHLogDelegate) {
        _GHLogService.remove(delegate: delegate)
    }
    
    private static func canNext(_ level:GHLogLevel) -> Bool {
        guard level != .off else {
            return false
        }
        return level.rawValue <= self.level.rawValue
    }
    
    private static func next(level:GHLogLevel, tag:String?, message:String) {
        let date = Date()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        var time = formatter.string(from: date)
        
        if let t = tag, t.hasPrefix("log.") {
            if t == "log.d" || t == "log.db" || t == "log.di" {
                formatter.dateFormat = "dd-HH:mm:ss.SSS"
                time = formatter.string(from: date)
            }
            
            let _message = message.replacingOccurrences(of: "\n", with: "\n" + t + " ").replacingOccurrences(of: "\r", with: "\r" + t + " ")
            let log = "\(time) \(t) \(_message)"
            _GHLogService.delegates.forEach { delegate in
                delegate.log(level: level, log: log, tag: tag, message: message)
            }
        } else {
            let tag = tag == nil ? "" : " \(tag ?? "")"
            let head = "\(level.key_short).log" + tag
            let _message = message.replacingOccurrences(of: "\n", with: "\n" + head + " ").replacingOccurrences(of: "\r", with: "\r" + head + " ")
            let log = "\(time) \(head) \(_message)"
            _GHLogService.delegates.forEach { delegate in
                delegate.log(level: level, log: log, tag: tag, message: message)
            }
        }
    }
    
    public static func log(_ level:GHLogLevel, tag:String? = nil, messageCallback:(() -> String)) {
        guard canNext(level) else {
            return
        }
        let message = messageCallback()
        
        next(level: level, tag: tag, message: message)
    }
    
    public static func log(_ level: GHLogLevel, tag:String? = nil, args: Any..., separator: String = " ") {
        guard canNext(level) else {
            return
        }
        let message = args.map { "\($0)" }.joined(separator: separator)
        next(level: level, tag: tag, message: message)
    }
    
}
