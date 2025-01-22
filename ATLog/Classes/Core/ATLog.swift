@objc
public enum ATLogLevel:Int {
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
public protocol ATLogDelegate: AnyObject {
    func log(level:ATLogLevel, log:String, tag:String?, message:String)
}

@objc
public protocol ATLogCustomFormatDelegate: AnyObject {
    func logFormat(level:ATLogLevel, tag:String?, message:String) -> String?
}

fileprivate struct _ATLogiPhone {
    static var weakContainer = NSHashTable<AnyObject>.weakObjects()
    static var delegates:[ATLogDelegate] {
        let objs = weakContainer.allObjects.compactMap({ $0 as? ATLogDelegate })
        return objs
    }
    static func add(delegate:ATLogDelegate) {
        weakContainer.add(delegate)
    }
    static func remove(delegate:ATLogDelegate) {
        weakContainer.remove(delegate)
    }
    static weak var customLogFormatDelegate:ATLogCustomFormatDelegate?
}

@objcMembers
final public class ATLogOC:NSObject {
    /// 日志级别
    public static var level:ATLogLevel {
        get { ATLog.level }
        set { ATLog.level = newValue }
    }
    
    public static var customLogFormatDelegate:ATLogCustomFormatDelegate? {
        get { _ATLogiPhone.customLogFormatDelegate }
        set { _ATLogiPhone.customLogFormatDelegate = newValue }
    }
    
    public static func add(delegate:ATLogDelegate) {
        _ATLogiPhone.add(delegate: delegate)
    }
    public static func remove(delegate:ATLogDelegate) {
        _ATLogiPhone.remove(delegate: delegate)
    }
    
    public static func log(_ level:ATLogLevel, tag:String? = nil, messageCallback:(() -> String)) {
        ATLog.log(level, tag: tag, messageCallback: messageCallback)
    }
}

final public class ATLog {
    #if DEBUG
    public static var level:ATLogLevel = .debug
    #else
    public static var level:ATLogLevel = .off
    #endif
    
    public static var customLogFormatDelegate:ATLogCustomFormatDelegate? {
        get { _ATLogiPhone.customLogFormatDelegate }
        set { _ATLogiPhone.customLogFormatDelegate = newValue }
    }
    
    public static func add(delegate:ATLogDelegate) {
        _ATLogiPhone.add(delegate: delegate)
    }
    public static func remove(delegate:ATLogDelegate) {
        _ATLogiPhone.remove(delegate: delegate)
    }
    
    private static func canNext(_ level:ATLogLevel) -> Bool {
        guard level != .off else {
            return false
        }
        return level.rawValue <= self.level.rawValue
    }
    
    private static let formatter = DateFormatter()
    private static func next(level:ATLogLevel, tag:String?, message:String) {
        if let formatDelegate = _ATLogiPhone.customLogFormatDelegate, let log = formatDelegate.logFormat(level: level, tag: tag, message: message) {
            _ATLogiPhone.delegates.forEach { delegate in
                delegate.log(level: level, log: log, tag: tag, message: message)
            }
            return
        }
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
            _ATLogiPhone.delegates.forEach { delegate in
                delegate.log(level: level, log: log, tag: tag, message: message)
            }
        } else {
            let tag = tag == nil ? "" : " \(tag ?? "")"
            let head = "\(level.key_short).log" + tag
            let _message = message.replacingOccurrences(of: "\n", with: "\n" + head + " ").replacingOccurrences(of: "\r", with: "\r" + head + " ")
            let log = "\(time) \(head) \(_message)"
            _ATLogiPhone.delegates.forEach { delegate in
                delegate.log(level: level, log: log, tag: tag, message: message)
            }
        }
    }
    
    public static func log(_ level:ATLogLevel, tag:String? = nil, messageCallback:(() -> String)) {
        guard canNext(level) else {
            return
        }
        let message = messageCallback()
        
        next(level: level, tag: tag, message: message)
    }
    
    public static func log(_ level: ATLogLevel, tag:String? = nil, args: Any..., separator: String = " ") {
        guard canNext(level) else {
            return
        }
        let message = args.map { "\($0)" }.joined(separator: separator)
        next(level: level, tag: tag, message: message)
    }
    
}
