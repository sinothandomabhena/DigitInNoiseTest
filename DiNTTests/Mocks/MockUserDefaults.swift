//
//  MockUserDefaults.swift
//  DiNTTests
//
//  Created by Sinothando on 2025/01/30.
//

import Foundation

class MockUserDefaults {
    private var storage: [String: Any] = [:]
    
    static let shared = MockUserDefaults()
    
    private init() {}
    
    func set(_ value: Any?, forKey key: String) {
        storage[key] = value
    }
    
    func value(forKey key: String) -> Any? {
        return storage[key]
    }
    
    func data(forKey key: String) -> Data? {
        return storage[key] as? Data
    }
    
    func removeObject(forKey key: String) {
        storage.removeValue(forKey: key)
    }
}
