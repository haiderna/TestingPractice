//
//  NetworkingMockUsersResponseFailure.swift
//  TestingPracticeTests
//
//  Created by NH on 10/6/23.
//

import Foundation
@testable import TestingPractice

class NetworkingMockUsersResponseFailure: NetworkingManagerImpl {
    
    func request<T>(session: URLSession, _ endPoint: TestingPractice.Endpoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        throw NetworkingManager.NetworkingError.invalidUrl
    }
    
    func request(session: URLSession, _ endpoint: TestingPractice.Endpoint) async throws {
        
    }
    
}
