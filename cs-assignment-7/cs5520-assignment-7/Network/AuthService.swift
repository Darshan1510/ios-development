//
//  AuthService.swift
//  cs5520-assignment-7
//
//  Created by Darshan Shah on 10/28/25.
//

import Foundation
import Alamofire

class AuthService: UsersProtocol {
    private let baseURL = "https://apis.sakibnm.work:3000/api/auth/"

    // MARK: - Register
    func register(name: String, email: String, password: String) async -> Bool {
        guard let url = URL(string: baseURL + "register") else { return false }

        let parameters: [String: String] = [
            "name": name,
            "email": email,
            "password": password
        ]

        let response = await AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder.default,
            headers: ["Content-Type": "application/x-www-form-urlencoded"]
        )
        .serializingData()
        .response

        let statusCode = response.response?.statusCode

        switch response.result {
        case .success(let data):
            guard let uwStatusCode = statusCode else { return false }

            switch uwStatusCode {
            case 200...299:
                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    if result.auth {
                        TokenManager.shared.saveToken(result.token)
                        return true
                    } else {
                        return false
                    }
                } catch {
                    print("JSON decode error:", error)
                    return false
                }

            case 400...499:
                print("Client error:", uwStatusCode)
                return false

            default:
                print("Server error:", uwStatusCode)
                return false
            }

        case .failure(let error):
            print("Network error:", error)
            return false
        }
    }

    // MARK: - Login
    func login(email: String, password: String) async -> Bool {
        guard let url = URL(string: baseURL + "login") else { return false }

        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        let response = await AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder.default,
            headers: ["Content-Type": "application/x-www-form-urlencoded"]
        )
        .serializingData()
        .response

        let statusCode = response.response?.statusCode

        switch response.result {
        case .success(let data):
            guard let uwStatusCode = statusCode else { return false }

            switch uwStatusCode {
            case 200...299:
                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    if result.auth {
                        TokenManager.shared.saveToken(result.token)
                        return true
                    } else {
                        return false
                    }
                } catch {
                    print("JSON decode error:", error)
                    return false
                }

            case 400...499:
                print("Client error:", uwStatusCode)
                return false

            default:
                print("Server error:", uwStatusCode)
                return false
            }

        case .failure(let error):
            print("Network error:", error)
            return false
        }
    }

    // MARK: - Get Profile
    func getProfile() async -> UserProfile? {
        guard let token = TokenManager.shared.getToken() else {
            print("No token found")
            return nil
        }
        guard let url = URL(string: baseURL + "me") else { return nil }

        let response = await AF.request(
            url,
            method: .get,
            headers: ["x-access-token": token]
        )
        .serializingData()
        .response

        switch response.result {
        case .success(let data):
            let statusCode = response.response?.statusCode ?? 0
            switch statusCode {
            case 200...299:
                do {
                    let user = try JSONDecoder().decode(UserProfile.self, from: data)
                    return user
                } catch {
                    print("Decode error:", error)
                    return nil
                }
            default:
                print("Status:", statusCode)
                return nil
            }
        case .failure(let error):
            print("Network error:", error)
            return nil
        }
    }

    // MARK: - Logout
    func logout() async -> Bool {
        guard let url = URL(string: baseURL + "logout") else { return false }
        let response = await AF.request(url, method: .get).serializingData().response
        switch response.result {
        case .success(_):
            TokenManager.shared.deleteToken()
            return true
        case .failure(let error):
            print("Logout error:", error)
            return false
        }
    }
}

// MARK: - Model
private struct AuthResponse: Codable, Sendable {
    let auth: Bool
    let token: String
}
