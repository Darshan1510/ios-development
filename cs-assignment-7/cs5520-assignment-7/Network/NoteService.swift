//
//  NotesService.swift
//  cs5520-assignment-7
//
//  Created by Darshan Shah on 10/28/25.
//

import Foundation
import Alamofire

class NotesService: NotesProtocol {
    private let baseURL = "https://apis.sakibnm.work:3000/api/note/"

    // MARK: - Get All Notes
    func getAllNotes() async -> [Notes]? {
        guard let token = TokenManager.shared.getToken(),
              let url = URL(string: baseURL + "getall") else { return nil }

        let response = await AF.request(
            url,
            method: .get,
            headers: ["x-access-token": token]
        )
        .serializingData()
        .response

        let statusCode = response.response?.statusCode ?? 0
        
        switch response.result {
        case .success(let data):
            switch statusCode {
            case 200...299:
                do {
                    // Decode the top-level object that contains the "notes" array
                    let decodedResponse = try JSONDecoder().decode(NotesResponse.self, from: data)
                    return decodedResponse.notes
                } catch {
                    print("Decoding error:", error)
                    if let rawJSON = String(data: data, encoding: .utf8) {
                        print("Raw JSON response:", rawJSON)
                    }
                    return nil
                }
            case 400...499:
                print("Client error:", statusCode)
                if let errorStr = String(data: data, encoding: .utf8) {
                    print("Response body:", errorStr)
                }
                return nil
            default:
                print("Server error:", statusCode)
                if let errorStr = String(data: data, encoding: .utf8) {
                    print("Response body:", errorStr)
                }
                return nil
            }

        case .failure(let error):
            print("Network error:", error)
            return nil
        }
    }

    // MARK: - Add Note
    func addNote(text: String) async -> Notes? {
        guard let token = TokenManager.shared.getToken(),
              let url = URL(string: baseURL + "post") else { return nil }

        let params = ["text": text]

        let response = await AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: URLEncodedFormParameterEncoder.default,
            headers: [
                "x-access-token": token,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        )
        .serializingData()
        .response

        let statusCode = response.response?.statusCode ?? 0

        switch response.result {
        case .success(let data):
            switch statusCode {
            case 200...299:
                do {
                    let note = try JSONDecoder().decode(Notes.self, from: data)
                    return note
                } catch {
                    print("Decoding error:", error)
                    return nil
                }
            case 400...499:
                print("Client error:", statusCode)
                if let errorStr = String(data: data, encoding: .utf8) {
                    print("Response body:", errorStr)
                }
                return nil
            default:
                print("Server error:", statusCode)
                if let errorStr = String(data: data, encoding: .utf8) {
                    print("Response body:", errorStr)
                }
                return nil
            }

        case .failure(let error):
            print("Network error:", error)
            return nil
        }
    }

    // MARK: - Delete Note
    func deleteNote(noteId: String) async -> Bool {
        guard let token = TokenManager.shared.getToken(),
              let url = URL(string: baseURL + "delete") else { return false }

        let params = ["id": noteId]

        let response = await AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: URLEncodedFormParameterEncoder.default,
            headers: [
                "x-access-token": token,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        )
        .serializingData()
        .response

        let statusCode = response.response?.statusCode ?? 0

        switch response.result {
        case .success(let data):
            switch statusCode {
            case 200...299:
                return true
            case 400...499:
                print("Client error:", statusCode)
                if let errorStr = String(data: data, encoding: .utf8) {
                    print("Response body:", errorStr)
                }
                return false
            default:
                print("Server error:", statusCode)
                if let errorStr = String(data: data, encoding: .utf8) {
                    print("Response body:", errorStr)
                }
                return false
            }

        case .failure(let error):
            print("Network error:", error)
            return false
        }
    }
}

// MARK: - API Response Models

private struct NotesResponse: Codable {
    let notes: [Notes]
}
