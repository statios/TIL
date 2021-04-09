//
//  AppDelegate.swift
//  Example_SwiftLog
//
//  Created by Stat on 2021/04/02.
//

import UIKit
import Logging

let logger = Logger(label: "")

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    logger.log(level: .critical, "")
    logger.info("application")
    logger.critical("application")
    logger.debug("application")
    
    return true
  }

}

