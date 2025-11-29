//
//  Notes.swift
//  WA7_Bilwal_7432
//
//  Created by Student on 10/28/25.
//

import Foundation


struct Notes: Codable {
    let _id: String?
    let text: String?
    
    init(_id: String? = nil, text: String? = nil) {
        self._id = _id
        self.text = text
    }
}
