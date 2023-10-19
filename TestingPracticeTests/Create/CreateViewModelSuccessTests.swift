//
//  CreateViewModelSuccessTests.swift
//  TestingPracticeTests
//
//  Created by NH on 10/9/23.
//

import XCTest
@testable import TestingPractice

final class CreateViewModelSuccessTests: XCTestCase {
    
    private var networkingMock: NetworkingManagerImpl!
    private var validationMock: CreateValidatorImpl!
    private var vm: CreateViewModel!
    
    override func setUp() {
        networkingMock = NetworkingManagerCreateSuccessMock()
        validationMock = CreateValidatorSuccessMock()
        vm = CreateViewModel(networkingManager: networkingMock, validator: validationMock)
    }
    
    // no error upon successful submission
    func test_successful_response_sub_state_successful() async throws {
        // when we submit data, sub state is successful, no errrors thrown
        XCTAssertNil(vm.state)
        defer {
            XCTAssertEqual(vm.state, .successful)
        }
        
        await vm.create()
    }
    
    // when view model fails test cases
    // form is wrong
    // or networking error when sending request 
    
    
    override func tearDown() {
        networkingMock = nil
        validationMock = nil
    }

}
