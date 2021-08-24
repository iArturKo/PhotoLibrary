//
//  UserDefaults+extensions.swift
//  Photo Library
//
//  Created by Артур Кононович on 6.05.21.
//

import Foundation

extension UserDefaults {
    
    static func setAppWasLaunched() {
        standard.set(true, forKey: "wasAppLaunched")
    }
    
    static func wasAppLaunched() -> Bool {
        return standard.bool(forKey: "wasAppLaunched")
    }
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
    
}
