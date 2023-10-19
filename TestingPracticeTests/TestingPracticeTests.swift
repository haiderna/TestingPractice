//
//  TestingPracticeTests.swift
//  TestingPracticeTests
//
//  Created by NH on 9/19/23.
//

import XCTest

// Manual testing - time consuming, mising edge cases, how does each change affect other code?
// save time, build confidence in code, provide documentation for testing business logic
// three types of test
// unit testing - small modules of work/business logic
// integration testing - test a combination of unit tests: validation object and createviewmodel and how they interact with each other --> make sure validation works before creating a user
// uitesting - testing of UI (flow, when fetching data are buttons disabled?? ) 

final class TestingPracticeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
