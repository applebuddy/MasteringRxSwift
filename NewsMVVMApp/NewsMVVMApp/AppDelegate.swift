//
//  AppDelegate.swift
//  NewsMVVMApp
//
//  Created by MinKyeongTae on 2022/09/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    window?.makeKeyAndVisible()
    UINavigationBar.appearance().barTintColor = UIColor(displayP3Red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
    UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    return true
  }
}

