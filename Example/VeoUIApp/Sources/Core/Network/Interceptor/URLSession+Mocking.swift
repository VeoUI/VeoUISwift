//
//  URLSession+Mocking.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 31/12/2024.
//

import Foundation

extension NetworkInterceptor {
    static func setupDefaultMocks() {
        
        let allPosts = """
            [
              {
                "userId": 1,
                "id": 1,
                "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                "body": "quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto"
              },
              {
                "userId": 1,
                "id": 2,
                "title": "qui est esse",
                "body": "est rerum tempore vitae\\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\\nqui aperiam non debitis possimus qui neque nisi nulla"
              },
              {
                "userId": 1,
                "id": 3,
                "title": "ea molestias quasi exercitationem repellat qui ipsa sit aut",
                "body": "et iusto sed quo iure\\nvoluptatem occaecati omnis eligendi aut ad\\nvoluptatem doloribus vel accusantium quis pariatur\\nmolestiae porro eius odio et labore et velit aut"
              }
            ]
            """.data(using: .utf8)
        
        let allPostsMock = DefaultMockResponse(
            url: "https://api.test/api/v1/posts",
            httpMethod: "GET",
            statusCode: 200,
            responseData: allPosts,
            responseDelay: 3
        )
        
        addMock(allPostsMock)
    }
}

extension URLSession {
    static func configureForMocking() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [NetworkInterceptor.self]
        let mockedSession = URLSession(configuration: config)
        swizzleSharedSession(with: mockedSession)
    }
    
    private static func swizzleSharedSession(with mockedSession: URLSession) {
        guard let originalMethod = class_getClassMethod(URLSession.self, #selector(getter: URLSession.shared)),
              let mockedMethod = class_getInstanceMethod(URLSession.self, #selector(getter: URLSession.shared)) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, mockedMethod)
    }
}
