//
//  PostsService.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 23/12/2024.
//

import Foundation

protocol PostsServiceProtocol {
    func fetchPosts() async throws -> [Post]
}

final class PostsService: PostsServiceProtocol {
    private let baseURL = "https://api.test/api/v1"

    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: "\(baseURL)/posts") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard
            let httpResponse = response as? HTTPURLResponse,
            (200 ... 299).contains(httpResponse.statusCode) else
        {
            throw URLError(.badServerResponse)
        }

        let posts = try JSONDecoder().decode([Post].self, from: data)
        return posts
    }
}
