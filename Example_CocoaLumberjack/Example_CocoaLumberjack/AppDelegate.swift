//
//  AppDelegate.swift
//  Example_CocoaLumberjack
//
//  Created by Stat on 2021/04/02.
//

import UIKit
import CocoaLumberjackSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    print("Log Start")
    DDLogVerbose("Verbose")
    DDLogDebug("Debug")
    DDLogDebug(<#T##message: Any##Any#>)
    
    return true
  }
  
}

