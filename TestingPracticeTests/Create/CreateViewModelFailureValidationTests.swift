//
//  CreateViewModelFailureValidationTests.swift
//  TestingPracticeTests
//
//  Created by NH on 10/9/23.
//

import XCTest
@testable import TestingPractice

final class CreateViewModelFailureValidationTests: XCTestCase {
    
    private var networkingMock: NetworkingManagerImpl!
    private var validationMock: CreateValidatorImpl!
    private var vm: CreateViewModel!
    
    override func setUp() {
        networkingMock = NetworkingManagerCreateSuccessMock()
        validationMock = CreateValidatorFailureMock()
        vm = CreateViewModel(networkingManager: networkingMock, validator: validationMock)
    }
    
    // invalid form
    func test_error_response_sub_state_failure() async throws {
       
        XCTAssertNil(vm.state)
        defer {
            XCTAssertEqual(vm.state, .unsuccessful)
        }
        
        await vm.create()
        XCTAssertTrue(vm.hasError)
        XCTAssertNotNil(vm.error)
        XCTAssertEqual(vm.error, .validation(error: CreateValidator.CreateValidatorError.invalidFirstName))
        
    }
    
    override func tearDown() {
        networkingMock = nil
        validationMock = nil
    }
}
