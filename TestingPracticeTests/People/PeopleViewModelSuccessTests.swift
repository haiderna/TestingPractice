//
//  PeopleViewModelSuccessTests.swift
//  TestingPracticeTests
//
//  Created by NH on 10/6/23.
//

import XCTest
@testable import TestingPractice

final class PeopleViewModelSuccessTests: XCTestCase {
    
    private var networkingMock: NetworkingManagerImpl!
    private var vm: PeopleViewModel!
    
    override func setUp() {
        self.networkingMock = NetworkingManagerUsersSuccessMock()
        self.vm = PeopleViewModel(networkingManager: networkingMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }
    
    func test_with_successful_response_users_array_is_set() async throws {
        XCTAssertFalse(vm.isLoading)
        defer {
            XCTAssertFalse(vm.isLoading)
            XCTAssertEqual(vm.viewState, .finished)
        }
        await vm.fetchUsers()
        XCTAssertEqual(vm.users.count, 6)
       
    }
    
    func test_with_successful_pagination_users_array_is_bigger() async throws {
        XCTAssertFalse(vm.isLoading)
        
        defer {
            XCTAssertFalse(vm.isFetching)
            XCTAssertEqual(vm.viewState, .finished)
        }
        
        await vm.fetchUsers()
        
        XCTAssertEqual(vm.users.count, 6)
        
        
        await vm.fetchNextSetOfUsers()
        
        XCTAssertEqual(vm.users.count, 12)
        XCTAssertEqual(vm.page, 2)
         
    }
    
    func test_with_reset_value_is_reset() async throws {
        
        defer {
            // verify reset
            XCTAssertEqual(vm.users.count, 6)
            XCTAssertEqual(vm.page, 1)
            XCTAssertEqual(vm.totalPages, 2)
            XCTAssertEqual(vm.viewState, .finished)
            XCTAssertFalse(vm.isLoading)
        }
        
        // load
        await vm.fetchUsers()
        
        XCTAssertEqual(vm.users.count, 6)
        
        // add
        
        await vm.fetchNextSetOfUsers()
        
        XCTAssertEqual(vm.users.count, 12)
        XCTAssertEqual(vm.page, 2)
        
        // reset
        
        await vm.fetchUsers()
    }
    
    func test_with_last_user_func_returns_true() async {
        
        await vm.fetchUsers()
        
        let userData = try! StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        
        let hasReachedEnd = vm.hasReachedEnd(of: userData.data.last!)
        
        XCTAssertTrue(hasReachedEnd)
    }

}
