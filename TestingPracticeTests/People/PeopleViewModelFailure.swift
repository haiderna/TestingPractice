//
//  PeopleViewModelFailure.swift
//  TestingPracticeTests
//
//  Created by NH on 10/6/23.
//

import XCTest
@testable import TestingPractice

final class PeopleViewModelFailure: XCTestCase {

    private var networkingMock: NetworkingManagerImpl!
    private var vm: PeopleViewModel!
    
    override func setUp() {
        self.networkingMock = NetworkingMockUsersResponseFailure()
        self.vm = PeopleViewModel(networkingManager: networkingMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }
    
    func test_with_unsuccessful_response_error_is_handled() async {
        XCTAssertFalse(vm.isLoading)
        defer {
            XCTAssertFalse(vm.isLoading)
            XCTAssertEqual(vm.viewState, .finished)
        }
        
        await vm.fetchUsers()
        
        XCTAssertTrue(vm.hasError)
        XCTAssertNotNil(vm.error)
        
    }

}
