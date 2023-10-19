//
//  NetworkingManagerUsersSuccessMock.swift
//  TestingPracticeTests
//
//  Created by NH on 10/6/23.
//

import Foundation
@testable import TestingPractice

class NetworkingManagerUsersSuccessMock: NetworkingManagerImpl {
    
    func request<T>(session: URLSession, _ endPoint: TestingPractice.Endpoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        // set amount of data right here for mock 
        return try StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self) as! T
    }
    
    func request(session: URLSession, _ endpoint: TestingPractice.Endpoint) async throws {
        
    }
    
    
}
