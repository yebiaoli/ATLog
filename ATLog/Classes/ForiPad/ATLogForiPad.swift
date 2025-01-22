public class ATLogForiPad {
    public static let shared = ATLogForiPad()
    
    public func startup() {
        ATLog.add(delegate: self)
    }
}

extension ATLogForiPad: ATLogDelegate {
    
    public func log(level: ATLogLevel, log: String, tag: String?, message: String) {
        print(log + "(iPad)")
    }
//    /Users/abiaoyo/ATLog/ATLogDemo/Pods/Headers/Public/ATLog/ATLog-umbrella.h:13:9 'ATLogStartup.h' file not found
}
