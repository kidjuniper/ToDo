//
//  XCTest+ExpectToEventually.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 24.09.2024.
//

import Foundation
import XCTest

extension XCTest {
    func expectToEventually(_ isFulfilled: @autoclosure () -> Bool,
        timeout: TimeInterval,
        message: String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        completion: @escaping (() -> Void) = {}) {
        func wait() { RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01)) }
        let timeout = Date(timeIntervalSinceNow: timeout)
        func isTimeout() -> Bool { Date() >= timeout }
        repeat {
            if isFulfilled() {
                completion()
                return
            }
            wait()
        } while !isTimeout()
        XCTFail(message,
                file: file,
                line: line)
    }
}
