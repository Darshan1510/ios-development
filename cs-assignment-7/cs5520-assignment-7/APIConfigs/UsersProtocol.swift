//
//  UserProtocol.swift
//  cs5520-assignment-7
//
//  Created by Darshan Shah on 10/28/25.
//

import Foundation

protocol UsersProtocol {
    func register(name: String, email: String, password: String) async throws -> Bool
    func login(email: String, password: String) async throws -> Bool
    func getProfile() async throws -> UserProfile?
    func logout() async throws -> Bool
}
