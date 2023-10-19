//
//  NetworkingManagerCreateFailureMock.swift
//  TestingPracticeTests
//
//  Created by NH on 10/9/23.
//

import Foundation
@testable import TestingPractice

class NetworkingManagerCreateFailureMock: NetworkingManagerImpl {
    
    func request<T>(session: URLSession, _ endPoint: TestingPractice.Endpoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        return Data() as! T
    }
    
    func request(session: URLSession, _ endpoint: TestingPractice.Endpoint) async throws {
        throw NetworkingManager.NetworkingError.invalidUrl
    }
    
    
}
