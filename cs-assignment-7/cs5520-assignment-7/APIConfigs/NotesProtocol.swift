//
//  NotesProtocol.swift
//  cs5520-assignment-7
//
//  Created by Darshan Shah on 10/28/25.
//

import Foundation

protocol NotesProtocol {
    func getAllNotes() async throws -> [Notes]?
    func addNote(text: String) async throws -> Notes?
    func deleteNote(noteId: String) async throws -> Bool
}
