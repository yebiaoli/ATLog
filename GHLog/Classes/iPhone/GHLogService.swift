//
//  GHLogService.swift
//  GHLogService
//
//  Created by abiaoyo on 2024/12/30.
//

import Foundation
import CocoaLumberjack
import GHLog

@objcMembers
public class GHLogService: NSObject {
    
    public static let shared = GHLogService()
    
    public func startup() {
        //初始化日志系统
        
        //打印
        DDLog.add(GHLogger())
        
        let logFileManager = GHLoggerFileManager()
        
        let fileLogger = DDFileLogger(logFileManager: logFileManager)
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 30  //最大文件数
        fileLogger.maximumFileSize = 0
        fileLogger.logFileManager.logFilesDiskQuota = 1024*1024*1024*10
        fileLogger.logFormatter = logFileManager

        //文件
        DDLog.add(fileLogger)
        
        GHLog.add(delegate: self)
    }
}

extension GHLogService: GHLogDelegate {
    
    public func log(level: GHLogLevel, log: String, tag: String?, message: String) {
        switch level {
        case .verbose:
            GHLogger.verbose(log)
        case .debug:
            GHLogger.debug(log)
        case .info:
            GHLogger.info(log)
        case .warn:
            GHLogger.warn(log)
        case .error:
            GHLogger.error(log)
        default:
            break
        }
    }
}
