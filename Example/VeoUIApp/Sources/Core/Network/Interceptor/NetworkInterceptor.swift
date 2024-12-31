//
//  NetworkInterceptor.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 31/12/2024.
//

import Foundation

final class NetworkInterceptor: URLProtocol {
    private static var mockResponses: [MockResponse] = []
    private var responseWorkItem: DispatchWorkItem?
    
    static func register() {
        URLProtocol.registerClass(NetworkInterceptor.self)
    }
    
    static func unregister() {
        URLProtocol.unregisterClass(NetworkInterceptor.self)
    }
    
    static func addMock(_ mock: MockResponse) {
        mockResponses.append(mock)
    }
    
    static func removeMock(for url: String) {
        mockResponses.removeAll { $0.url == url }
    }
    
    static func clearMocks() {
        mockResponses.removeAll()
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url?.absoluteString else { return false }
        return mockResponses.first { mockResponse in
            let methodMatches = mockResponse.httpMethod == nil ||
                mockResponse.httpMethod?.uppercased() == request.httpMethod?.uppercased()
            let urlMatches = url == mockResponse.url
            return methodMatches && urlMatches
        } != nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client = client,
              let url = request.url?.absoluteString,
              let mockResponse = Self.mockResponses.first(where: { mock in
                  url == mock.url
              }) else {
            return
        }
        
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: mockResponse.statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: nil
        )!
        
        responseWorkItem = DispatchWorkItem { [weak self] in
            guard self != nil else { return }
            
            client.urlProtocol(self!, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let responseData = mockResponse.responseData {
                client.urlProtocol(self!, didLoad: responseData)
            }
            
            client.urlProtocolDidFinishLoading(self!)
        }
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + mockResponse.responseDelay,
            execute: responseWorkItem!
        )
    }
    
    override func stopLoading() {
        responseWorkItem?.cancel()
    }
}
