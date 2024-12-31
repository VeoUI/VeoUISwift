//
//  MockResponse.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 31/12/2024.
//

import Foundation

protocol MockResponse {
    var url: String { get }
    var httpMethod: String? { get }
    var statusCode: Int { get }
    var responseData: Data? { get }
    var responseDelay: TimeInterval { get }
}

struct DefaultMockResponse: MockResponse {
    let url: String
    let httpMethod: String?
    let statusCode: Int
    let responseData: Data?
    let responseDelay: TimeInterval
    
    init(url: String,
         httpMethod: String? = nil,
         statusCode: Int = 200,
         responseData: Data? = nil,
         responseDelay: TimeInterval = 0.1) {
        self.url = url
        self.httpMethod = httpMethod
        self.statusCode = statusCode
        self.responseData = responseData
        self.responseDelay = responseDelay
    }
}
