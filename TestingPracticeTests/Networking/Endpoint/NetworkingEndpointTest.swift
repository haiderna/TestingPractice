//
//  NetworkingEndpointTest.swift
//  TestingPracticeTests
//
//  Created by NH on 10/3/23.
//

import XCTest
@testable import TestingPractice

final class NetworkingEndpointTest: XCTestCase {
    
    func test_with_people_endpoint_request_is_valid() {
        let endpoint = Endpoint.people(page: 1)
        XCTAssertEqual(endpoint.host, "reques.in")
        XCTAssertEqual(endpoint.path, "/api/users")
        XCTAssertEqual(endpoint.methodType, .GET)
        XCTAssertEqual(endpoint.queryItems, ["page": "1"])
        
        XCTAssertEqual(endpoint.url?.absoluteString, "reques.in/apis/users?page=1&delay=5")
    }
    
    func test_with_detail_endpoint_request_is_valid() {
        let userId = 1
        let endpoint = Endpoint.detail(id: userId)
        XCTAssertEqual(endpoint.host, "reques.in")
        XCTAssertEqual(endpoint.path, "/api/users/\(userId)")
        XCTAssertEqual(endpoint.methodType, .GET)
        XCTAssertNil(endpoint.queryItems)
        
        XCTAssertEqual(endpoint.url?.absoluteString, "reques.in/apis/users/\(userId)?&delay=5")
    }
    
    func test_with_create_endpoint_request_is_valid() {
        let endpoint = Endpoint.create(submissionData: nil)
        XCTAssertEqual(endpoint.host, "reques.in")
        XCTAssertEqual(endpoint.path, "/api/users")
        XCTAssertEqual(endpoint.methodType, .POST(data: nil))
        XCTAssertNil(endpoint.queryItems)
        
        XCTAssertEqual(endpoint.url?.absoluteString, "reques.in/apis/users?&delay=5")
    }

}
