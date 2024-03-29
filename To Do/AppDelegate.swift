//
//  AppDelegate.swift
//  To Do
//
//  Created by Matthew Lundeen on 3/25/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let userInterfaceStyle = UserDefaults.standard.string(forKey: "AppTheme") ?? "system"
            
        if userInterfaceStyle == "light" {
            application.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        } else if userInterfaceStyle == "dark" {
            application.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        }
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

