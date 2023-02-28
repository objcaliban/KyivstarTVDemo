//
//  Task.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 28.02.2023.
//

import Foundation

extension Task where Failure == Never, Success == Void {
    @discardableResult
    init(priority: TaskPriority? = nil,
         operation: @escaping () async throws -> Void,
         `catch`: @escaping (Error) -> Void) {
        self.init(priority: priority) {
            do {
                _ = try await operation()
            } catch {
                `catch`(error)
            }
        }
    }
}
