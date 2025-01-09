public class GHLogiPad {
    public static let shared = GHLogiPad()
    
    public func startup() {
        GHLog.add(delegate: self)
    }
}

extension GHLogiPad: GHLogDelegate {
    
    public func log(level: GHLogLevel, log: String, tag: String?, message: String) {
        print(log + "(iPad)")
    }
}
