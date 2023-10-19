//
//  NetworkingManagerUserDetailResponseSuccess.swift
//  TestingPracticeTests
//
//  Created by NH on 10/11/23.
//

import Foundation
@testable import TestingPractice

class NetworkingManagerUserDetailResponseSuccessMock: NetworkingManagerImpl {
    func request<T>(session: URLSession, _ endPoint: TestingPractice.Endpoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        return try StaticJSONMapper.decode(file: "SingleUserData", type: UserDetailResponse.self) as! T
    }
    
    func request(session: URLSession, _ endpoint: TestingPractice.Endpoint) async throws {
        
    }
    
}
