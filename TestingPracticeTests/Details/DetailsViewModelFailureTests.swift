//
//  DetailsViewModelFailureTests.swift
//  TestingPracticeTests
//
//  Created by NH on 10/11/23.
//

import XCTest
@testable import TestingPractice

final class DetailsViewModelFailureTests: XCTestCase {
    private var networkingManager: NetworkingManagerImpl!
    private var vm: DetailViewModel!
    
    override func setUp() {
        networkingManager = NetworkingManagerUserDetailResponseFailureMock()
        vm = DetailViewModel(networkingManager: networkingManager)
    }
    
    override func tearDown() {
        networkingManager = nil
        vm = nil
    }
    
    // test vm.isLoading and vm.userData == nil on failure
    func test_with_unsuccessful_response_error_is_handled() async {
        XCTAssertFalse(vm.isLoading)
        
        defer {
            XCTAssertFalse(vm.isLoading)
        }
        
        await vm.fetchDetails(for: 1)
        
        XCTAssertTrue(vm.hasError)
        XCTAssertNotNil(vm.error)
    }

}
