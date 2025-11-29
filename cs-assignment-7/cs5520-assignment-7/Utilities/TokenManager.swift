//
//  TokenManager.swift
//  cs5520-assignment-7
//
//  Created by Darshan Shah on 10/28/25.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private let tokenKey = "authToken"

    private init() {}

    // Save token
    func saveToken(_ token: String) {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: tokenKey)
        print("Token saved to UserDefaults")
    }

    // Retrieve token
    func getToken() -> String? {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: tokenKey)
        if token == nil {
            print("No token found in UserDefaults")
        }
        return token
    }

    // Delete token
    func deleteToken() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: tokenKey)
        print("🗑️ Token removed from UserDefaults")
    }
}
