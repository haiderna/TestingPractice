//
//  CreateViewModelFailureTests.swift
//  TestingPracticeTests
//
//  Created by NH on 10/9/23.
//

import XCTest
@testable import TestingPractice

final class CreateViewModelFailureTests: XCTestCase {

    private var networkingMock: NetworkingManagerImpl!
    private var validationMock: CreateValidatorImpl!
    private var vm: CreateViewModel!
    
    override func setUp() {
        networkingMock = NetworkingManagerCreateFailureMock()
        validationMock = CreateValidatorSuccessMock()
        vm = CreateViewModel(networkingManager: networkingMock, validator: validationMock)
    }
    
   // unsuccessful response sub state is unsuccessful
    func test_with_unsuccessful_response_sub_state_is_unsuccessful() async throws {
        XCTAssertNil(vm.state)
        defer {
            XCTAssertEqual(vm.state, .unsuccessful)
        }
        
        await vm.create()
        
        XCTAssertTrue(vm.hasError)
        XCTAssertNotNil(vm.error)
        XCTAssertEqual(vm.error, .networking(error: NetworkingManager.NetworkingError.invalidUrl))
    }
    
    
    override func tearDown() {
        networkingMock = nil
        validationMock = nil
    }

}
