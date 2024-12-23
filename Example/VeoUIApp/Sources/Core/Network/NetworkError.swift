//
//  NetworkError.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 23/12/2024.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unknown(Error)

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidData:
            return "Invalid data received"
        case let .unknown(error):
            return error.localizedDescription
        }
    }
}
