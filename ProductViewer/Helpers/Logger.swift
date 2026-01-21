//
//  Logger.swift
//  ProductViewer
//
//  Created by Velmurugan on 21/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import Foundation


let logger = Logger.shared

final class Logger {
    
    static let shared = Logger()
    
    private init() {}
    
    func log(_ message: String, file: String = #file, function: String = #function,line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):\(line)] \(function) → \(message)")
    }
}
