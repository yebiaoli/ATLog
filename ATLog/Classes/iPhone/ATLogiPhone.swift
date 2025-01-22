import Foundation
import CocoaLumberjack

@objcMembers
public class ATLogiPhone: NSObject {
    
    public static let shared = ATLogiPhone()
    
    public func startup() {
        //初始化日志系统
        
        //打印
        DDLog.add(ATLogger())
        
        let logFileManager = ATLoggerFileManager()
        
        let fileLogger = DDFileLogger(logFileManager: logFileManager)
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 30  //最大文件数
        fileLogger.maximumFileSize = 0
        fileLogger.logFileManager.logFilesDiskQuota = 1024*1024*1024*10
        fileLogger.logFormatter = logFileManager

        //文件
        DDLog.add(fileLogger)
        
//        fileLogger.currentLogFileInfo?.fileName
        
        ATLog.add(delegate: self)
    }
}

extension ATLogiPhone: ATLogDelegate {
    
    public func log(level: ATLogLevel, log: String, tag: String?, message: String) {
        switch level {
        case .verbose:
            ATLogger.verbose(log)
        case .debug:
            ATLogger.debug(log)
        case .info:
            ATLogger.info(log)
        case .warn:
            ATLogger.warn(log)
        case .error:
            ATLogger.error(log)
        default:
            break
        }
    }
}
