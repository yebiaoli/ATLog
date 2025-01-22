//
//  AppDelegate.swift
//  ATLogDemo
//
//  Created by abiaoyo on 2025/1/9.
//

import UIKit
import ATLog

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ATLogiWatch.shared.startup()
        ATLogiPad.shared.startup()
        ATLogiPhone.shared.startup()

        ATLog.level = .verbose
        ATLog.add(delegate: self)
        ATLog.log(.verbose) { "App 启动" }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

extension AppDelegate: ATLogDelegate {
    func log(level: ATLogLevel, log: String, tag: String?, message: String) {
        print(log + "(AppDelegate)")
    }
}
