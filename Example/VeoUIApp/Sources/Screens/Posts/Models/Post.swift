//
//  Post.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import Foundation

struct Post: Identifiable, Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int

    enum CodingKeys: String, CodingKey {
        case id, title, body, userId
    }
}
