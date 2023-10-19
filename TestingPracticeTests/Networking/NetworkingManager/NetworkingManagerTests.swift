//
//  NetworkingManagerTests.swift
//  TestingPracticeTests
//
//  Created by NH on 10/3/23.
//

import XCTest
@testable import TestingPractice

final class NetworkingManagerTests: XCTestCase {
    private var session: URLSession!
    private var url: URL!
    
    override func setUp() {
        url = URL(string: "https://reques.in/users")
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLSessionProtocol.self]
        session = URLSession(configuration: config)
    }
    
    override func tearDown() {
        session = nil
        url = nil
    }
    
    func test_with_success_response_is_valid() async throws {
        // simulate successful response with dummy data
        guard let path = Bundle.main.path(forResource: "UsersStaticData", ofType: "json"), let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get static users file")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, data)
        }
        
        let result = try await NetworkingManager.shared.request(session: session, .people(page: 1), type: UsersResponse.self)
        
        let staticJSON = try StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        XCTAssertEqual(result, staticJSON)
        
        
    }
    
    func test_with_success_response_void_is_valid() async throws {
        // not throw an error when response is 200
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, nil)
        }
        
        _ = try await NetworkingManager.shared.request(session: session, .people(page: 1))
        
    }
    
    func test_unsuccesful_response_code_in_invalid_range() async {
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 400, httpVersion: nil, headerFields: nil)
            return (response!, nil)
        }
        do {
            _ = try await NetworkingManager.shared.request(session: session, .people(page: 1), type: UsersResponse.self)
        } catch {
            guard let networkingError = error as? NetworkingManager.NetworkingError else {
                XCTFail("not right error")
                return
            }
            
            XCTAssertEqual(networkingError, NetworkingManager.NetworkingError.invalidStatusCode(statusCode: 400))
        }
    }
    
    func test_unsuccesful_response_code_void_in_invalid_range() async {
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 400, httpVersion: nil, headerFields: nil)
            return (response!, nil)
        }
        do {
            _ = try await NetworkingManager.shared.request(session: session, .people(page: 1))
        } catch {
            guard let networkingError = error as? NetworkingManager.NetworkingError else {
                XCTFail("not right error")
                return
            }
            
            XCTAssertEqual(networkingError, NetworkingManager.NetworkingError.invalidStatusCode(statusCode: 400))
        }
    }
    
    func test_with_successful_response_with_invalid_json() async {
        guard let path = Bundle.main.path(forResource: "UsersStaticData", ofType: "json"), let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get static users file")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, data)
        }
        
        do {
            _ = try await NetworkingManager.shared.request(session: session, .people(page: 1), type: UserDetailResponse.self)
        } catch {
            if error is NetworkingManager.NetworkingError {
                XCTFail("should be system error")
            }
        }
        
        
    }

}
