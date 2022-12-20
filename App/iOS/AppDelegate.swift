//
//  AppDelegate.swift
//  ArchitectureDemo
//
//  Created by Chibundu Anwuna on 2022-12-09.
//

import UIKit
import Notification

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationHandler.shared.startListening()
        return true
    }

}

