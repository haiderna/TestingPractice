//
//  DetailsViewModelSuccessTests.swift
//  TestingPracticeTests
//
//  Created by NH on 10/11/23.
//

import XCTest
@testable import TestingPractice

final class DetailsViewModelSuccessTests: XCTestCase {
    private var networkingManager: NetworkingManagerImpl!
    private var vm: DetailViewModel!
    
    override func setUp() {
        networkingManager = NetworkingManagerUserDetailResponseSuccessMock()
        vm = DetailViewModel(networkingManager: networkingManager)
    }
    
    override func tearDown() {
        networkingManager = nil
        vm = nil
    }
    
    // checking userinfo matches mock
    // testing loading state before and after success
    
    func test_successful_response_user_details_set() async throws {
        XCTAssertFalse(vm.isLoading)
        
        defer {
            XCTAssertFalse(vm.isLoading)
        }
        
        await vm.fetchDetails(for: 1)
        
        XCTAssertNotNil(vm.userInfo)
        
        // compare data is the same from mock
        let userDetailsData = try StaticJSONMapper.decode(file: "SingleUserData", type: UserDetailResponse.self)
        XCTAssertEqual(userDetailsData, vm.userInfo)
    }

}
