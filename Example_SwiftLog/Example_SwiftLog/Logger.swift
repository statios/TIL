//
//  Logger.swift
//  Example_SwiftLog
//
//  Created by Stat on 2021/04/02.
//

import Foundation

enum LogEvent: String {
  case error = "🔴"
  case warning = "🟡"
  case info = "🟢"
  case debug = "🔵"
  case verbose = "🟣"
}

func print(_ object: Any) {
  #if DEBUG
  Swift.print(object)
  #endif
}

class Log {
  
  static var dateFormat = "hh:mm:ss"
  static var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    return formatter
  }
  
  class func error( _ object: Any,
                    filename: String = #file,
                    line: Int = #line,
                    funcName: String = #function) {
    print("\(LogEvent.error.rawValue) "
            + "\(sourceFileName(filePath: filename)):\(line) "
            + "\(funcName) -> "
            + "\(object)"
    )
  }
  
  class func warning( _ object: Any,
                      filename: String = #file,
                      line: Int = #line,
                      funcName: String = #function) {
    print("\(LogEvent.warning.rawValue) "
            + "\(sourceFileName(filePath: filename)):\(line) "
            + "\(funcName) -> "
            + "\(object)"
    )
  }
  
  class func info( _ object: Any,
                   filename: String = #file,
                   line: Int = #line,
                   funcName: String = #function) {
    print("\(LogEvent.info.rawValue) "
            + "\(sourceFileName(filePath: filename)):\(line) "
            + "\(funcName) -> "
            + "\(object)"
    )
  }
  
  class func debug( _ object: Any,
                    filename: String = #file,
                    line: Int = #line,
                    funcName: String = #function) {
    print("\(LogEvent.debug.rawValue) "
            + "\(sourceFileName(filePath: filename)):\(line) "
            + "\(funcName) -> "
            + "\(object)"
    )
  }
  
  class func verbose( _ object: Any,
                      filename: String = #file,
                      line: Int = #line,
                      funcName: String = #function) {
    print("\(LogEvent.verbose.rawValue) "
            + "\(sourceFileName(filePath: filename)):\(line) "
            + "\(funcName) -> "
            + "\(object)"
    )
  }
  
  private class func sourceFileName(filePath: String) -> String {
    let components = filePath.components(separatedBy: "/")
    return components.isEmpty ? "" : components.last!
  }
}

fileprivate extension Date {
  func toString() -> String {
    return Log.dateFormatter.string(from: self as Date)
  }
}
