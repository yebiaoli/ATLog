public class ATLogiWatch {
    public static let shared = ATLogiWatch()
    
    public func startup() {
        ATLog.add(delegate: self)
    }
}

extension ATLogiWatch: ATLogDelegate {
    
    public func log(level: ATLogLevel, log: String, tag: String?, message: String) {
        print(log + "(iWatch)")
    }
}
