public class ATLogiPad {
    public static let shared = ATLogiPad()
    
    public func startup() {
        ATLog.add(delegate: self)
    }
}

extension ATLogiPad: ATLogDelegate {
    
    public func log(level: ATLogLevel, log: String, tag: String?, message: String) {
        print(log + "(iPad)")
    }
//    /Users/abiaoyo/ATLog/ATLogDemo/Pods/Headers/Public/ATLog/ATLog-umbrella.h:13:9 'ATLogStartup.h' file not found
}
