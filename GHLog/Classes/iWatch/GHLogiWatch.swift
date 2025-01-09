import GHLog

public class GHLogiWatch {
    public static let shared = GHLogiWatch()
    
    public func startup() {
        GHLog.add(delegate: self)
    }
}

extension GHLogiWatch: GHLogDelegate {
    
    public func log(level: GHLogLevel, log: String, tag: String?, message: String) {
        print(log + "(iWatch)")
    }
}
