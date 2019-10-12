//
//  AppDelegate.swift
//  MyServiceDemo
//
//  Created by Hsiao, Wayne on 2019/9/27.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import MyService

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let genericPassword = GenericPasswordQueryable(service: "test")
        let keychainWrapper = KeychainWrapper(queryable: genericPassword)
        try? keychainWrapper.removeAll()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
