//
//  Endpoint.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 23/12/2024.
//

import Foundation

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let body: [String: Any]?
    let queryItems: [URLQueryItem]?

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "jsonplaceholder.typicode.com"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }

    init(
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        body: [String: Any]? = nil,
        queryItems: [URLQueryItem]? = nil)
    {
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
        self.queryItems = queryItems
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
