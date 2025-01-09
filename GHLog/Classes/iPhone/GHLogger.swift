//
//  GHLogger.swift
//  GHLogService
//
//  Created by abiaoyo on 2024/12/30.
//

import Foundation
import CocoaLumberjack

@objcMembers
public class GHLoggerFileManager: DDLogFileManagerDefault {
    
    static let dateFormatter = DateFormatter()
    
    public static func dateFormat(date:Date = Date(), format:String = "yyyy-MM-dd HH:mm:ss") -> String {
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.locale = Locale.init(identifier: Locale.preferredLanguages.first!)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    public override var newLogFileName: String {
        let fileName = "govee\(GHLoggerFileManager.dateFormat(format: "yyyyMMdd")).log"
        return fileName
    }
    public override func isLogFile(withName fileName: String) -> Bool {
        return fileName.hasPrefix("govee") && fileName.hasSuffix(".log")
    }
}
extension GHLoggerFileManager:DDLogFormatter {
    public func format(message logMessage: DDLogMessage) -> String? {
        return logMessage.message
    }
}



public final class GHLogFormatter: NSObject, DDLogFormatter {
    
    public func format(message logMessage: DDLogMessage) -> String? {
        return logMessage.message
    }
}


public final class GHLogger: NSObject, DDLogger {
    
    public override init() {
        super.init()
        logFormatter = GHLogFormatter()
    }
    
    public var logFormatter: DDLogFormatter?
    
    public func log(message logMessage: DDLogMessage) {
        let message = logFormatter?.format(message: logMessage) ?? logMessage.message
        print(message)
    }
    
    @objc public static func verbose(_ log: String) {
        DDLogVerbose(log)
    }
    
    @objc public static func debug(_ log: String) {
        DDLogDebug(log)
    }
    
    @objc public static func info(_ log: String) {
        DDLogInfo(log)
    }
    
    @objc public static func warn(_ log: String) {
        DDLogWarn(log)
    }
    
    @objc public static func error(_ log: String) {
        DDLogError(log)
    }
}

